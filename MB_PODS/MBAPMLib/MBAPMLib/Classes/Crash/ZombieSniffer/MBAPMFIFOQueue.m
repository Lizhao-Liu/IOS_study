//
//  MBAPMFIFOQueue.m
//  MBAPMLib
//
//  Created by xp on 2022/11/7.
//

#import "MBAPMFIFOQueue.h"

#include <assert.h>
#include <pthread.h>
#include <semaphore.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "MBAPMFIFOQueue.h"


struct MBAPMFIFOQueue {
    /* An array of elements in the queue. */
    void **buf;

    /* The position of the first element in the queue. */
    uint32_t pos;

    /* The number of items currently in the queue.
     * When `length` = 0, mbapm_fifo_queue_get will block.
     * When `length` = `capacity`, mbapm_fifo_queue_put will block. */
    uint32_t length;

    /* The total number of allowable items in the queue */
    uint32_t capacity;

    /* When true, the queue has been closed. A run-time error will occur
     * if a value is sent to a closed queue. */
    bool closed;

    /* Guards the modification of `length` (a condition variable) and `pos`. */
    pthread_mutex_t mutate;

    /* A condition variable that is pinged whenever `length` has changed or
     * when the queue has been closed. */
    pthread_cond_t cond_length;
};


struct MBAPMFIFOQueue *
mbapm_fifo_queue_create(uint32_t buffer_capacity)
{
    struct MBAPMFIFOQueue *queue;
    int errno;

    assert(buffer_capacity > 0);

    queue = malloc(sizeof(*queue));
    assert(queue);

    queue->pos = 0;
    queue->length = 0;
    queue->capacity = buffer_capacity;
    queue->closed = false;

    queue->buf = malloc(buffer_capacity * sizeof(*queue->buf));
    assert(queue->buf);

    if (0 != (errno = pthread_mutex_init(&queue->mutate, NULL))) {
        fprintf(stderr, "Could not create mutex. Errno: %d\n", errno);
        exit(1);
    }
    if (0 != (errno = pthread_cond_init(&queue->cond_length, NULL))) {
        fprintf(stderr, "Could not create cond var. Errno: %d\n", errno);
        exit(1);
    }

    return queue;
}

void
mbapm_fifo_queue_free(struct MBAPMFIFOQueue *queue)
{
    if (!queue) {
        return;
    }
    int errno;

    if (0 != (errno = pthread_mutex_destroy(&queue->mutate))) {
        fprintf(stderr, "Could not destroy mutex. Errno: %d\n", errno);
        exit(1);
    }
    if (0 != (errno = pthread_cond_destroy(&queue->cond_length))) {
        fprintf(stderr, "Could not destroy cond var. Errno: %d\n", errno);
        exit(1);
    }
    free(queue->buf);
    free(queue);
}

int
mbapm_fifo_queue_length(struct MBAPMFIFOQueue *queue)
{
    if (!queue) {
        return 0;
    }
    int len;
    pthread_mutex_lock(&queue->mutate);
    len = queue->length;
    pthread_mutex_unlock(&queue->mutate);
    return len;
}

int
mbapm_fifo_queue_capacity(struct MBAPMFIFOQueue *queue)
{
    if (!queue) {
        return 0;
    }
    return queue->capacity;
}

void
mbapm_fifo_queue_close(struct MBAPMFIFOQueue *queue)
{
    if (!queue) {
        return;
    }
    pthread_mutex_lock(&queue->mutate);
    queue->closed = true;
    pthread_cond_broadcast(&queue->cond_length);
    pthread_mutex_unlock(&queue->mutate);
}

void
mbapm_fifo_queue_put(struct MBAPMFIFOQueue *queue, void *item)
{
    if (!queue) {
        return;
    }
    pthread_mutex_lock(&queue->mutate);
    assert(!queue->closed);

    while (queue->length == queue->capacity)
        pthread_cond_wait(&queue->cond_length, &queue->mutate);

    assert(!queue->closed);
    assert(queue->length < queue->capacity);

    queue->buf[(queue->pos + queue->length) % queue->capacity] = item;
    queue->length++;
    pthread_cond_broadcast(&queue->cond_length);

    pthread_mutex_unlock(&queue->mutate);
}

void *
mbapm_fifo_queue_get(struct MBAPMFIFOQueue *queue)
{
    if (!queue) {
        return NULL;
    }
    void *item;

    pthread_mutex_lock(&queue->mutate);

    while (queue->length == 0) {
        /* This is a bit tricky. It is possible that the queue has been closed
         * *and* has become empty while `pthread_cond_wait` is blocking.
         * Therefore, it is necessary to always check if the queue has been
         * closed when the queue is empty, otherwise we will deadlock. */
        if (queue->closed) {
            pthread_mutex_unlock(&queue->mutate);
            return NULL;
        }
        pthread_cond_wait(&queue->cond_length, &queue->mutate);
    }

    assert(queue->length <= queue->capacity);
    assert(queue->length > 0);

    item = queue->buf[queue->pos];
    queue->buf[queue->pos] = NULL;
    queue->pos = (queue->pos + 1) % queue->capacity;

    queue->length--;
    pthread_cond_broadcast(&queue->cond_length);

    pthread_mutex_unlock(&queue->mutate);

    return item;
}

void*
mbapm_fifo_queue_put_pop_first_item_if_need(struct MBAPMFIFOQueue *queue, void *item)
{
    if (!queue) {
        return NULL;
    }
    void *pop_item = NULL;
    
    pthread_mutex_lock(&queue->mutate);
    assert(!queue->closed);
    
    //pop the first item if queue is full
    if (queue->length == queue->capacity) {
        assert(queue->length > 0);
        
        pop_item = queue->buf[queue->pos];
        queue->buf[queue->pos] = NULL;
        queue->pos = (queue->pos + 1) % queue->capacity;
        queue->length--;
    }
    
    assert(queue->length < queue->capacity);
    
    queue->buf[(queue->pos + queue->length) % queue->capacity] = item;
    queue->length++;
    pthread_cond_broadcast(&queue->cond_length);
    
    pthread_mutex_unlock(&queue->mutate);
    return pop_item;
}

void*
mbapm_fifo_queue_try_get(struct MBAPMFIFOQueue *queue) {
    if (!queue) {
        return NULL;
    }
    void *item = NULL;
    
    pthread_mutex_lock(&queue->mutate);
    
    if (queue->length == 0) {
        pthread_mutex_unlock(&queue->mutate);
        return NULL;
    }
    
    assert(queue->length <= queue->capacity);
    assert(queue->length > 0);
    
    item = queue->buf[queue->pos];
    queue->buf[queue->pos] = NULL;
    queue->pos = (queue->pos + 1) % queue->capacity;
    
    queue->length--;
    pthread_cond_broadcast(&queue->cond_length);
    
    pthread_mutex_unlock(&queue->mutate);
    
    return item;
}

