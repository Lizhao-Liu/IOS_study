//
//  MBAPMMainThreadStackMgr.m
//  MBAPMLib
//
//  Created by xp on 2020/11/11.
//

#import "MBAPMMainThreadStackMgr.h"
#import <pthread.h>
#import "MBAPMLogDef.h"

#define STACK_PER_MAX_COUNT 100 // the max address count of one stack

#define SHORTEST_LENGTH_OF_STACK 5 // the min address count of one stack

/*
 * Create a recycle queue to save lastest main thread call stack
 * Create a array to save stack continuous repeat count, stacks is the same if the top stack address is the same
 */
@interface MBAPMMainThreadStackMgr() {
    pthread_mutex_t m_threadLock; //the lock to protect read and write operation of the recycle queue
    int m_cycleArrayCount;        //the max stack count in the recycle queue
    uintptr_t **m_mainThreadStackCycleArray; //the array to save stack
    size_t *m_mainThreadStackCount;          // the size of the stack array
    uint64_t m_tailPoint;                    // the tail point of the recycle queue
    size_t *m_topStackAddressRepeatArray;    // the array to save stack continuous repeat count
}

   

@end

@implementation MBAPMMainThreadStackMgr

- (id)initWithCycleArrayCount:(int)cycleArrayCount {
    self = [super init];
    if(self) {
        m_cycleArrayCount = cycleArrayCount;

        size_t cycleArrayBytes = m_cycleArrayCount * sizeof(uintptr_t *);
        m_mainThreadStackCycleArray = (uintptr_t **)malloc(cycleArrayBytes);
        if(m_mainThreadStackCycleArray != NULL) {
            memset(m_mainThreadStackCycleArray, 0, cycleArrayBytes);
        }
        size_t countArrayBytes = m_cycleArrayCount * sizeof(size_t);
        m_mainThreadStackCount = (size_t *) malloc(countArrayBytes);
        if (m_mainThreadStackCount != NULL) {
            memset(m_mainThreadStackCount, 0, countArrayBytes);
        }
        size_t addressArrayBytes = m_cycleArrayCount * sizeof(size_t);
        m_topStackAddressRepeatArray = (size_t *) malloc(addressArrayBytes);
        if (m_topStackAddressRepeatArray != NULL) {
            memset(m_topStackAddressRepeatArray, 0, addressArrayBytes);
        }

        m_tailPoint = 0;
        pthread_mutex_init(&m_threadLock, NULL);
    }
    return self;
}

- (id)init {
    return [self initWithCycleArrayCount:20];
}

- (void)clearThreadStacks {
    pthread_mutex_lock(&m_threadLock);
    for (uint32_t i = 0; i < m_cycleArrayCount; i++) {
        if (m_mainThreadStackCycleArray[i] != NULL) {
            free(m_mainThreadStackCycleArray[i]);
            m_mainThreadStackCycleArray[i] = NULL;
        }
        m_mainThreadStackCount[i] = 0;
        m_topStackAddressRepeatArray[i] = 0;
    }
    pthread_mutex_unlock(&m_threadLock);
}

- (void)dealloc {
   for (uint32_t i = 0; i < m_cycleArrayCount; i++) {
        if (m_mainThreadStackCycleArray[i] != NULL) {
            free(m_mainThreadStackCycleArray[i]);
            m_mainThreadStackCycleArray[i] = NULL;
        }
    }
    
    if (m_mainThreadStackCount != NULL) {
        free(m_mainThreadStackCount);
        m_mainThreadStackCount = NULL;
    }
    
    if (m_topStackAddressRepeatArray != NULL) {
        free(m_topStackAddressRepeatArray);
        m_topStackAddressRepeatArray = NULL;
    }
}

- (void)addThreadStack:(uintptr_t *)stackArray andStackCount:(size_t)stackCount {
    if (stackArray == NULL) {
        return;
    }
    if (m_mainThreadStackCycleArray == NULL || m_mainThreadStackCount == NULL) {
        return;
    }
    pthread_mutex_lock(&m_threadLock);
    if(m_mainThreadStackCycleArray[m_tailPoint] != NULL) {
        free(m_mainThreadStackCycleArray[m_tailPoint]);
    }
    m_mainThreadStackCycleArray[m_tailPoint] = stackArray;
    m_mainThreadStackCount[m_tailPoint] = stackCount;
    
    uint64_t lastTailPoint = (m_tailPoint + m_cycleArrayCount - 1) % m_cycleArrayCount;
    uintptr_t lastTopStack = 0;
    if (m_mainThreadStackCycleArray[lastTailPoint] != NULL) {
        lastTopStack = m_mainThreadStackCycleArray[lastTailPoint][0];
    }
    uintptr_t currentTopStackAddr = stackArray[0];
    if(lastTopStack == currentTopStackAddr) {
        size_t lastRepeatCount = m_topStackAddressRepeatArray[lastTailPoint];
        m_topStackAddressRepeatArray[m_tailPoint] = lastRepeatCount + 1;
    } else {
        m_topStackAddressRepeatArray[m_tailPoint] = 0;
    }
    m_tailPoint = (m_tailPoint + 1) % m_cycleArrayCount;
    pthread_mutex_unlock(&m_threadLock);
}

- (size_t)getLastMainThreadStackCount {
    uint64_t lastPoint = (m_tailPoint + m_cycleArrayCount - 1) % m_cycleArrayCount;
    return m_mainThreadStackCount[lastPoint];
}

- (uintptr_t *)getLastMainThreadStack {
    uint64_t lastPoint = (m_tailPoint + m_cycleArrayCount - 1) % m_cycleArrayCount;
    return m_mainThreadStackCycleArray[lastPoint];
}

- (MBAPMBacktraceStack *)getPointStack {
    pthread_mutex_lock(&m_threadLock);
    size_t maxValue = 0;
    BOOL trueStack = NO;
    for(int i = 0; i < m_cycleArrayCount; i++) {
        size_t currentValue = m_topStackAddressRepeatArray[i];
        int stackCount = (int)m_mainThreadStackCount[i];
        if (currentValue >= maxValue && stackCount > SHORTEST_LENGTH_OF_STACK) {
            maxValue = currentValue;
            trueStack = YES;
        }
    }
    
    if(!trueStack) {
        pthread_mutex_unlock(&m_threadLock);
        return NULL;
    }
    size_t currentIndex = (m_tailPoint + m_cycleArrayCount - 1) % m_cycleArrayCount;
    for (int i = 0; i < m_cycleArrayCount; i++) {
        int trueIndex = (m_tailPoint + m_cycleArrayCount - i - 1) % m_cycleArrayCount;
        int stackCount = (int) m_mainThreadStackCount[trueIndex];
        if (m_topStackAddressRepeatArray[trueIndex] == maxValue && stackCount > SHORTEST_LENGTH_OF_STACK) {
            currentIndex = trueIndex;
            break;
        }
    }
    
    size_t stackCount = m_mainThreadStackCount[currentIndex];
    size_t pointThreadSize = sizeof(uintptr_t) * stackCount;
    uintptr_t *pointThreadStack = (uintptr_t *) malloc(pointThreadSize);
    
    if(pointThreadStack != NULL) {
        memset(pointThreadStack, 0, pointThreadSize);
        for (size_t idx = 0; idx < stackCount; idx++) {
            pointThreadStack[idx] = m_mainThreadStackCycleArray[currentIndex][idx];
        }
        MBAPMBacktraceStack *pointStack = (MBAPMBacktraceStack *) malloc(sizeof(MBAPMBacktraceStack));
        pointStack->stack = pointThreadStack;
        pointStack->count = stackCount;
        pthread_mutex_unlock(&m_threadLock);
        return pointStack;
    }
    pthread_mutex_unlock(&m_threadLock);
    return NULL;
}

@end
