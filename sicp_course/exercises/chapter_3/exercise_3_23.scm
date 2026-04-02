(define (make-node value prev next)
  (cons value (cons prev next)))

(define (node-value node) (car node))
(define (node-prev node) (cadr node))
(define (node-next node) (cddr node))
(define (set-node-prev! node prev) (set-car! (cdr node) prev))
(define (set-node-next! node next) (set-cdr! (cdr node) next))

(define (make-deque) (cons '() '()))

(define (front-ptr deque) (car deque))
(define (rear-ptr deque) (cdr deque))
(define (set-front-ptr! deque item) (set-car! deque item))
(define (set-rear-ptr! deque item) (set-cdr! deque item))

(define (empty-deque? deque) (null? (front-ptr deque)))

(define (front-deque deque)
  (if (empty-deque? deque)
      (error "FRONT called with an empty deque" deque)
      (node-value (front-ptr deque))))

(define (rear-deque deque)
  (if (empty-deque? deque)
      (error "REAR called with an empty deque" deque)
      (node-value (rear-ptr deque))))

(define (front-insert-deque! deque value)
  (let ((new-node (make-node value '() (front-ptr deque))))
    (cond ((empty-deque? deque)
           (set-front-ptr! deque new-node)
           (set-rear-ptr! deque new-node))
          (else
           (set-node-prev! (front-ptr deque) new-node)
           (set-front-ptr! deque new-node)))
    deque))

(define (rear-insert-deque! deque value)
  (let ((new-node (make-node value (rear-ptr deque) '())))
    (cond ((empty-deque? deque)
           (set-front-ptr! deque new-node)
           (set-rear-ptr! deque new-node))
          (else
           (set-node-next! (rear-ptr deque) new-node)
           (set-rear-ptr! deque new-node)))
    deque))

(define (front-delete-deque! deque)
  (cond ((empty-deque? deque)
         (error "FRONT-DELETE! called with an empty deque" deque))
        ((null? (node-next (front-ptr deque))) ; Only one item
         (set-front-ptr! deque '())
         (set-rear-ptr! deque '()))
        (else
         (set-front-ptr! deque (node-next (front-ptr deque)))
         (set-node-prev! (front-ptr deque) '())))
  deque)

(define (rear-delete-deque! deque)
  (cond ((empty-deque? deque)
         (error "REAR-DELETE! called with an empty deque" deque))
        ((null? (node-prev (rear-ptr deque))) ; Only one item
         (set-front-ptr! deque '())
         (set-rear-ptr! deque '()))
        (else
         (set-rear-ptr! deque (node-prev (rear-ptr deque)))
         (set-node-next! (rear-ptr deque) '())))
  deque)
