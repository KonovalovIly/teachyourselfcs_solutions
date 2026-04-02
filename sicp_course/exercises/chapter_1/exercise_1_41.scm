(define (double f)
    (lambda (x) (f (f x))))

(define (inc x) (+ x 1))

; Example evaluations:
((double inc) 5)               ; 7
(((double double) inc) 5)      ; 9
(((double (double double)) inc) 5) ; 21
