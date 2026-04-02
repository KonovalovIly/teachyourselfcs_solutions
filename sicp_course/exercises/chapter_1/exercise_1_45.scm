(define tolerance 0.00001)

(define (fixed-point f first-guess)
    (define (close-enough? v1 v2)
        (< (abs (- v1 v2)) tolerance))
    (define (try guess)
        (let ((next (f guess)))
        (if (close-enough? guess next)
            next
            (try next))))
    (try first-guess))

(define (average-damp f)
    (lambda (x) (/ (+ x (f x)) 2)))

(define (compose f g)
    (lambda (x) (f (g x))))

(define (repeated f n)
    (if (= n 1)
        f
        (compose f (repeated f (- n 1)))))

(define (num-dampings n)
    (floor (/ (log n) (log 2))))

(define (nth-root x n)
    (fixed-point ((repeated average-damp (num-dampings n))
                    (lambda (y) (/ x (expt y (- n 1))))
                1.0)))

; Example usages:
(nth-root 16 2)  ; 4.0
(nth-root 27 3)  ; 3.0
(nth-root 16 4)  ; 2.0
(nth-root 32 5)  ; 2.0
(nth-root 256 8) ; 2.0
