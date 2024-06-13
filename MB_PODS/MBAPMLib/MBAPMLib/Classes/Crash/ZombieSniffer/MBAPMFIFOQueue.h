//
//  MBAPMFIFOQueue.h
//  MBAPMLib
//
//  Created by xp on 2022/11/7.
//

#import <Foundation/Foundation.h>

#ifndef __LIBMBAPM_QUEUE_H__
#define __LIBMBAPM_QUEUE_H__

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/*
 * MBAPMFIFOQueue is a thread-safe queue that has no limitation on the number of
 * threads that can call mbapm_fifo_queue_put and mbapm_fifo_queue_get simultaneously.
 * That is, it supports a multiple producer and multiple consumer model.
 */

/* MBAPMFIFOQueue implements a thread-safe queue using a fairly standard
 * circular buffer. */
struct MBAPMFIFOQueue;

/* Allocates a new MBAPMFIFOQueue with a buffer size of the capacity given. */
struct MBAPMFIFOQueue *
mbapm_fifo_queue_create(uint32_t buffer_capacity);

/* Frees all data used to create a MBAPMFIFOQueue. It should only be called after
 * a call to mbapm_fifo_queue_close to make sure all 'gets' are terminated before
 * destroying mutexes/condition variables.
 *
 * Note that the data inside the buffer is not freed. */
void
mbapm_fifo_queue_free(struct MBAPMFIFOQueue *queue);

/* Returns the current length (number of items) in the queue. */
int
mbapm_fifo_queue_length(struct MBAPMFIFOQueue *queue);

/* Returns the capacity of the queue. This is always equivalent to the
 * size of the initial buffer capacity. */
int
mbapm_fifo_queue_capacity(struct MBAPMFIFOQueue *queue);

/* Closes a queue. A closed queue cannot add any new values.
 *
 * When a queue is closed, an empty queue will always be empty.
 * Therefore, `mbapm_fifo_queue_get` will return NULL and not block when
 * the queue is empty. Therefore, one can traverse the items in a queue
 * in a thread-safe manner with something like:
 *
 *  void *queue_item;
 *  while (NULL != (queue_item = mbapm_fifo_queue_get(queue)))
 *      do_something_with(queue_item);
 */
void
mbapm_fifo_queue_close(struct MBAPMFIFOQueue *queue);

/* Adds new values to a queue (or "sends values to a consumer").
 * `mbapm_fifo_queue_put` cannot be called with a queue that has been closed. If
 * it is, an assertion error will occur.
 * If the queue is full, `mbapm_fifo_queue_put` will block until it is not full,
 * in which case the value will be added to the queue. */
void
mbapm_fifo_queue_put(struct MBAPMFIFOQueue *queue, void *item);

/* Reads new values from a queue (or "receives values from a producer").
 * `mbapm_fifo_queue_get` will block if the queue is empty until a new value has been
 * added to the queue with `mbapm_fifo_queue_put`. In which case, `mbapm_fifo_queue_get` will
 * return the next item in the queue.
 * `mbapm_fifo_queue_get` can be safely called on a queue that has been closed (indeed,
 * this is probably necessary). If the queue is closed and not empty, the next
 * item in the queue is returned. If the queue is closed and empty, it will
 * always be empty, and therefore NULL will be returned immediately. */
void *
mbapm_fifo_queue_get(struct MBAPMFIFOQueue *queue);

/* Adds new values to a queue (or "sends values to a consumer").
* `mbapm_fifo_queue_put` cannot be called with a queue that has been closed. If
* it is, an assertion error will occur.
* If the queue is full, `mbapm_fifo_queue_put` will pop the first item, and return the item,
* in which case the value will be added to the queue. */
void *
mbapm_fifo_queue_put_pop_first_item_if_need(struct MBAPMFIFOQueue *queue, void *item);

/*
 *Reads new values from a queue (or "receives values from a producer").
 *return NULL immediately if the queue is empty
 */
void*
mbapm_fifo_queue_try_get(struct MBAPMFIFOQueue *queue);
    
#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif
