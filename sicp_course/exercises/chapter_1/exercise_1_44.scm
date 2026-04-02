; Define a small dx for smoothing
(define dx 0.0001)

; Smooth a function f
(define (smooth f)
  (lambda (x) (/ (+ (f (- x dx))
                    (f x)
                    (f (+ x dx)))
                 3)))

; From Exercise 1.43
(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeated f n)
  (if (= n 1)
      f
      (compose f (repeated f (- n 1)))))

; Generate the n-fold smoothed function
(define (n-fold-smooth f n)
  ((repeated smooth n) f))

; Example usage
(define (square x) (* x x))

(define smoothed-square (smooth square))
(smoothed-square 2) ; ≈ 4

(define double-smoothed-square (n-fold-smooth square 2))
(double-smoothed-square 2) ; ≈ 4, more smoothed
