(define (cubic a b c)
    (lambda (x) (+ (* x x x) (* a x x) (* b x) c)))

(define (deriv g)
    (lambda (x) (/ (- (g (+ x dx)) (g x)) dx)))

(define dx 0.00001)

(define (newton-transform g)
    (lambda (x) (- x (/ (g x) ((deriv g) x)))))

(define (fixed-point f first-guess)

    (define (close-enough? v1 v2)
        (< (abs (- v1 v2)) 0.00001))

    (define (try guess)
        (let ((next (f guess)))
        (if (close-enough? guess next)
            next
            (try next))))

    (try first-guess)
)

(define (newtons-method g guess)
    (fixed-point (newton-transform g) guess))

; Example usage:
(define (find-cubic-root a b c guess)
    (newtons-method (cubic a b c) guess))

; Find a root of x^3 - 3x^2 + 2x - 1 = 0:
(find-cubic-root -3 2 -1 1.0) ; Expected: ~2.3247179572453938
