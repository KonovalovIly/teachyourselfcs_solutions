(define tolerance 0.00001)

(define (fixed-point f first-guess n)
    (define (close-enough? v1 v2)
        (< (abs (- v1 v2)) tolerance))
    (define (try guess n)
        (display n) (display " - ") (display guess) (newline)
        (let ((next (f guess)))
        (if (close-enough? guess next)
            next
            (try next (+ n 1)))))
    (try first-guess n))

(define (average-damp f)
    (lambda (x) (/ (+ x (f x)) 2)))

; Without average damping
(define (solution)
    (fixed-point (lambda (x) (/ (log 1000) (log x))) 2.0 1))

; With average damping
(define (solution-damped)
    (fixed-point (average-damp (lambda (x) (/ (log 1000) (log x)))) 2.0 1))

; Uncomment to run:
; (solution)       ; ~34 steps
; (solution-damped) ; ~10 steps
