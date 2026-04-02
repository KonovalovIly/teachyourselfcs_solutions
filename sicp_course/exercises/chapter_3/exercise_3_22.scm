(define (make-queue)
  (let ((front-ptr '())
        (rear-ptr '()))

    ; Internal helper procedures
    (define (empty?) (null? front-ptr))

    (define (front)
      (if (empty?)
          (error "FRONT called with empty queue")
          (car front-ptr)))

    (define (insert! item)
      (let ((new-pair (cons item '())))
        (cond ((empty?)
               (set! front-ptr new-pair)
               (set! rear-ptr new-pair))
              (else
               (set-cdr! rear-ptr new-pair)
               (set! rear-ptr new-pair)))))

    (define (delete!)
      (cond ((empty?)
             (error "DELETE! called with empty queue"))
            (else
             (set! front-ptr (cdr front-ptr))
             (if (null? front-ptr)
                 (set! rear-ptr '())))))

    ; Dispatch procedure
    (define (dispatch m)
      (cond ((eq? m 'empty?) empty?)
            ((eq? m 'front) front)
            ((eq? m 'insert!) insert!)
            ((eq? m 'delete!) delete!)
            (else (error "Unknown operation -- QUEUE" m))))

    dispatch))

(define (empty-queue? queue) ((queue 'empty?)))
(define (front-queue queue) ((queue 'front)))
(define (insert-queue! queue item) ((queue 'insert!) item))
(define (delete-queue! queue) ((queue 'delete!)))
