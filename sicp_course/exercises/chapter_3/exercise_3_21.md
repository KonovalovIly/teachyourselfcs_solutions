### Understanding the Queue Implementation

The queue is implemented using a pair of pointers:
- `front-ptr`: Points to the front of the queue (where items are deleted).
- `rear-ptr`: Points to the rear of the queue (where items are inserted).

Here's the implementation from the book:
```scheme
(define (make-queue) (cons '() '()))

(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))

(define (empty-queue? queue) (null? (front-ptr queue)))

(define (front-queue queue)
  (if (empty-queue? queue)
      (error "FRONT called with an empty queue" queue)
      (car (front-ptr queue))))

(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-pair)
           (set-rear-ptr! queue new-pair))
          (else
           (set-cdr! (rear-ptr queue) new-pair)
           (set-rear-ptr! queue new-pair)))
    queue))

(define (delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with an empty queue" queue))
        (else
         (set-front-ptr! queue (cdr (front-ptr queue)))
         queue))
```

### Ben's Observations

Ben tests the queue:
```scheme
(define q1 (make-queue))
(insert-queue! q1 'a) ; ((a) a)
(insert-queue! q1 'b) ; ((a b) b)
(delete-queue! q1)    ; ((b) b)
(delete-queue! q1)    ; (() b)
```

He complains:
1. After inserting `'a` and `'b`, the rear pointer shows `'b` twice: `((a b) b)`.
2. After deleting both items, the queue shows `(() b)`, suggesting it's not empty when it should be.

### Eva Lu's Explanation

The issue isn't with the queue implementation but with how the standard Lisp printer displays it. The queue is represented as a pair `(front-ptr . rear-ptr)`, where:
- `front-ptr` is the list of items in the queue.
- `rear-ptr` points to the last pair in `front-ptr` (for efficient insertion).

When printing:
- `(insert-queue! q1 'a)` creates `front-ptr = (a)`, `rear-ptr = (a)` → printed as `((a) a)`.
- `(insert-queue! q1 'b)` appends `'b` to `front-ptr = (a b)`, `rear-ptr = (b)` → printed as `((a b) b)`.
- After deletions, `front-ptr` becomes `()`, but `rear-ptr` still points to the last item, `(b)` → printed as `(() b)`.

### Correct Printing with `print-queue`

To print just the items in the queue (ignoring the `rear-ptr`), define:
```scheme
(define (print-queue queue)
  (display (front-ptr queue))
  (newline))
```

Now testing:
```scheme
(define q1 (make-queue))
(insert-queue! q1 'a) ; (a)
(insert-queue! q1 'b) ; (a b)
(delete-queue! q1)    ; (b)
(delete-queue! q1)    ; ()
```

### Why Ben Saw What He Saw

1. **First Insert (`'a`)**:
   - `front-ptr`: `(a)`
   - `rear-ptr`: `(a)` (points to the same pair)
   - Printed as `((a) a)`.

2. **Second Insert (`'b`)**:
   - `front-ptr`: `(a b)`
   - `rear-ptr`: `(b)` (last pair)
   - Printed as `((a b) b)`.

3. **First Delete**:
   - `front-ptr`: `(b)` (after deleting `'a`)
   - `rear-ptr`: `(b)` (unchanged)
   - Printed as `((b) b)`.

4. **Second Delete**:
   - `front-ptr`: `()` (queue is empty)
   - `rear-ptr`: `(b)` (still points to the last pair, but `front-ptr` is `null`)
   - Printed as `(() b)`.

### Key Takeaways
- The queue works correctly internally, but the standard printer shows both `front-ptr` and `rear-ptr`.
- The `rear-ptr` is an implementation detail for efficient insertion and doesn't affect the queue's logical contents.
- Use `print-queue` to display only the items in the queue.

### Final Answer
Eva Lu is correct: the queue works fine, but the default printer shows internal pointers. Here's the corrected printer:
```scheme
(define (print-queue queue)
  (display (front-ptr queue))
  (newline))
```
Now:
```scheme
(print-queue q1) ; Shows the actual queue items, e.g., (a b).
```
