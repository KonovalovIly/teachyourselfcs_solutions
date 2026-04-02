/**
 * @file queue.c
 * @brief Implementation of a queue that supports FIFO and LIFO operations.
 *
 * This queue implementation uses a singly-linked list to represent the
 * queue elements. Each queue element stores a string value.
 *
 * Assignment for basic C skills diagnostic.
 * Developed for courses 15-213/18-213/15-513 by R. E. Bryant, 2017
 * Extended to store strings, 2018
 *
 * TODO: fill in your name and Andrew ID
 * @author XXX <XXX@andrew.cmu.edu>
 */

#include "queue.h"
#include "harness.h"

#include <stdlib.h>
#include <string.h>

/**
 * @brief Allocates a new queue
 * @return The new queue, or NULL if memory allocation failed
 */
queue_t *queue_new(void) {
    queue_t *q = malloc(sizeof(queue_t));

    /* What if malloc returned NULL? */
    if (q == NULL) {
        return NULL;  // Return NULL if memory allocation failed
    }

    q->head = NULL;
    q->tail = NULL;  // Initialize tail pointer
    q->size = 0;     // Initialize size counter
    return q;
}

/**
 * @brief Frees all memory used by a queue
 * @param[in] q The queue to free
 */
void queue_free(queue_t *q) {
    /* How about freeing the list elements and the strings? */
    if (q == NULL) {
        return;  // Handle NULL pointer to avoid undefined behavior
    }

    q->tail = q->head;
    list_ele_t *current = q->head;
    while (current != NULL)
    {
        q->head = current->next;
        free(current->value);
        free(current);
        q->size -= 1;
        current = q->head;
    }

    /* Free queue structure */
    free(q);
}

/**
 * @brief Attempts to insert an element at head of a queue
 *
 * This function explicitly allocates space to create a copy of `s`.
 * The inserted element points to a copy of `s`, instead of `s` itself.
 *
 * @param[in] q The queue to insert into
 * @param[in] s String to be copied and inserted into the queue
 *
 * @return true if insertion was successful
 * @return false if q is NULL, or memory allocation failed
 */
bool queue_insert_head(queue_t *q, const char *s) {
    /* What should you do if the q is NULL? */
    if (q == NULL) {
        return false;
    }

    list_ele_t *newh = malloc(sizeof(list_ele_t));
    /* Don't forget to allocate space for the string and copy it */
    /* What if either call to malloc returns NULL? */
    if (newh == NULL) {
        return false;  // Memory allocation failed
    }

    /* Don't forget to allocate space for the string and copy it */
    newh->value = malloc(strlen(s) + 1);  // +1 for null terminator
    if (newh->value == NULL) {
        free(newh);  // Clean up the list element allocation
        return false;  // Memory allocation failed
    }

    strcpy(newh->value, s);  // Copy the string
    if (q->head == NULL){
        q->tail = newh;
    }

    newh->next = q->head;
    q->head = newh;
    q->size ++;
    return true;
}

/**
 * @brief Attempts to insert an element at tail of a queue
 *
 * This function explicitly allocates space to create a copy of `s`.
 * The inserted element points to a copy of `s`, instead of `s` itself.
 *
 * @param[in] q The queue to insert into
 * @param[in] s String to be copied and inserted into the queue
 *
 * @return true if insertion was successful
 * @return false if q is NULL, or memory allocation failed
 */
bool queue_insert_tail(queue_t *q, const char *s) {
    /* You need to write the complete code for this function */
    /* Remember: It should operate in O(1) time */

    if (q == NULL) {
        return false;
    }

    list_ele_t *new_tail = malloc(sizeof(list_ele_t));
    if (new_tail == NULL) {
        return false;
    }

    new_tail->value = malloc(strlen(s) + 1);
    if (new_tail->value == NULL) {
        free(new_tail);
        return false;
    }

    strcpy(new_tail->value, s);
    new_tail->next = NULL;

    if (q->head == NULL) {
        q->head = new_tail;
    } else {
        q->tail->next = new_tail;
    }
    q->tail = new_tail;
    q->size += 1;
    return true;
}

/**
 * @brief Attempts to remove an element from head of a queue
 *
 * If removal succeeds, this function frees all memory used by the
 * removed list element and its string value before returning.
 *
 * If removal succeeds and `buf` is non-NULL, this function copies up to
 * `bufsize - 1` characters from the removed string into `buf`, and writes
 * a null terminator '\0' after the copied string.
 *
 * @param[in]  q       The queue to remove from
 * @param[out] buf     Output buffer to write a string value into
 * @param[in]  bufsize Size of the buffer `buf` points to
 *
 * @return true if removal succeeded
 * @return false if q is NULL or empty
 */
bool queue_remove_head(queue_t *q, char *buf, size_t bufsize) {
    /* You need to fix up this code. */

    // Check for NULL pointers and empty queue
    if (q == NULL || q->head == NULL || buf == NULL) {
        return false;
    }

    list_ele_t *element_to_remove = q->head;

    // Copy the string to the buffer (with bounds checking)
    strncpy(buf, element_to_remove->value, bufsize - 1);
    buf[bufsize - 1] = '\0'; // Ensure null termination

    // Update the head pointer
    q->head = element_to_remove->next;

    // If we removed the last element, update tail pointer too
    if (q->head == NULL) {
        q->tail = NULL;
    }

    // Free the memory
    free(element_to_remove->value);
    free(element_to_remove);

    q->size --;
    return true;
}

/**
 * @brief Returns the number of elements in a queue
 *
 * This function runs in O(1) time.
 *
 * @param[in] q The queue to examine
 *
 * @return the number of elements in the queue, or
 *         0 if q is NULL or empty
 */
size_t queue_size(queue_t *q) {
    /* You need to write the code for this function */
    /* Remember: It should operate in O(1) time */

    if (q == NULL) {
        return 0;
    }

    return q->size;
}

/**
 * @brief Reverse the elements in a queue
 *
 * This function does not allocate or free any list elements, i.e. it does
 * not call malloc or free, including inside helper functions. Instead, it
 * rearranges the existing elements of the queue.
 *
 * @param[in] q The queue to reverse
 */
void queue_reverse(queue_t *q) {
    /* You need to write the code for this function */

    if (q == NULL || q->head == NULL || q->head->next == NULL) {
        return;  // Nothing to reverse for NULL, empty, or single-element queue
    }

    list_ele_t *prev = NULL;
    list_ele_t *current = q->head;
    list_ele_t *next = NULL;

    // Reverse the linked list
    while (current != NULL) {
        next = current->next;    // Store next node
        current->next = prev;    // Reverse current node's pointer
        prev = current;          // Move prev to current
        current = next;          // Move to next node
    }

    // Update head and tail pointers
    q->tail = q->head;  // Old head becomes new tail
    q->head = prev;     // Last node becomes new head
}
