(define (count-pairs x)
  (let ((visited '()))  ; Initialize an empty list to track visited pairs
    (define (helper x)
      (cond ((not (pair? x)) 0)  ; Base case: not a pair
            ((memq x visited) 0) ; Already counted this pair
            (else
             (set! visited (cons x visited)) ; Mark this pair as visited
             (+ (helper (car x))
                (helper (cdr x))
                1)))) ; Count the current pair
    (helper x)))

(define a (cons 'a '()))
(define b (cons 'b a))
(define c (cons 'c b))
