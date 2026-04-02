(define (stream-car s) (car s))
(define (stream-cdr s) ((cdr s)))
(define (stream-cons a b) (cons a (lambda () b)))

(define (add-streams s1 s2)
  (stream-cons (+ (stream-car s1) (stream-car s2))
               (add-streams (stream-cdr s1) (stream-cdr s2))))

(define (integers-starting-from n)
  (stream-cons n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))

(define sums (partial-sums integers))
