(define (compose f g)
    (lambda (x) (f (g x))))

; Example functions
(define (inc x) (+ x 1))
(define (square x) (* x x))

; Composing square and inc
(define square-after-inc (compose square inc))

; Testing
(square-after-inc 6) ; Returns 49
