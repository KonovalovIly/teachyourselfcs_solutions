### ✅ **Exercise 3.47 — SICP**
> Implement **semaphores**, a generalization of mutexes, in two different ways:
>
> - **(a)** In terms of **mutexes**
> - **(b)** In terms of **atomic `test-and-set!` operations**

---

## 🧠 What Is a Semaphore?

A **semaphore** is a synchronization primitive used to control access to a shared resource.

- It has a **count** (initially set to some value `n`)
- Supports two operations:
  - `acquire`: Decrements the count if it's > 0; otherwise, waits
  - `release`: Increments the count

It allows **up to `n` processes** to access a resource concurrently.

---

## ✅ Part (a): Implementing a Semaphore Using Mutexes

We’ll use:

- A **mutex** to protect access to the internal state (the counter)
- A **counter** to track how many are currently using the semaphore
- A **condition variable** or polling loop to wait when the semaphore is full

Here’s one possible implementation in Scheme:

```scheme
(define (make-semaphore n)
  (let ((mutex (make-mutex))
        (available n)
        (waiters '())) ; list of thunks to notify when released
    (define (call-if-waiting)
      (if (not (null? waiters))
          (let ((w (car waiters)))
            (set! waiters (cdr waiters))
            (w))))

    (define (the-semaphore m)
      (cond
        ((eq? m 'acquire)
         (mutex 'acquire)
         (if (> available 0)
             (begin
               (set! available (- available 1))
               (mutex 'release))
             (begin
               (mutex 'release)
               (synchronize-on
                (lambda ()
                  (the-semaphore 'acquire))))))

        ((eq? m 'release)
         (mutex 'acquire)
         (set! available (+ available 1))
         (call-if-waiting)
         (mutex 'release))

        ((eq? m 'try-acquire)
         (mutex 'acquire)
         (if (> available 0)
             (begin
               (set! available (- available 1))
               (mutex 'release)
               #t)
             (begin
               (mutex 'release)
               #f)))

        (else (error "Unknown request: SEMAPHORE" m))))
    the-semaphore))
```

> Note: This assumes you have a way to **block and retry** (e.g., via event loop or threads). If not, you can implement waiting with a simple polling loop.

---

## ✅ Part (b): Implementing a Semaphore Using Atomic `test-and-set!`

We'll simulate a **low-level semaphore** using only an atomic `test-and-set!` operation.

This version doesn't use higher-level constructs like mutexes but builds everything from scratch using a shared cell.

```scheme
(define (make-semaphore n)
  (let ((lock-cell (list false)) ; for mutual exclusion
        (available n))
    (define (acquire)
      (define (waiting-loop)
        (if (not (try-acquire))
            (waiting-loop))) ; busy-wait
      (waiting-loop))

    (define (try-acquire)
      (if (>= available 1)
          (let ((result (test-and-set! lock-cell)))
            (if (not result) ; we got the lock
                (begin
                  (set! available (- available 1))
                  (set-car! lock-cell false)
                  #t)
                #f))
          #f))

    (define (release)
      (test-and-set! lock-cell) ; acquire lock
      (set! available (+ available 1))
      (set-car! lock-cell false)) ; release lock

    (define (dispatch m)
      (cond ((eq? m 'acquire) (acquire))
            ((eq? m 'release) (release))
            ((eq? m 'try-acquire) (try-acquire))
            (else (error "Unknown request: SEMAPHORE" m))))
    dispatch))
```

> ⚠️ Note: This uses **busy waiting** (`waiting-loop`) — inefficient but correct. Real systems would use **condition variables** or **scheduler hooks**.

---

## 📌 Summary

| Approach | Description |
|--------|-------------|
| **Using Mutexes** | Use a mutex to protect access to a counter and a queue of waiting processes |
| **Using test-and-set!** | Build everything from scratch using atomic operations; includes busy waiting unless enhanced |

Both implementations support:

- `acquire`: Wait until space is available
- `release`: Make a slot available
- Optional `try-acquire`: Non-blocking attempt

---

## 💡 Final Thought

This exercise shows how **higher-level synchronization primitives** like semaphores can be built on top of lower-level ones like mutexes or atomic operations.

It also illustrates trade-offs between:
- Simplicity vs efficiency (busy waiting)
- High-level abstractions vs low-level control

