(define (cube-root x)

  (define (good-enough? old-guess new-guess)
    (< (abs (- new-guess old-guess))
       (* 0.0001 old-guess))) ; Relative tolerance

  (define (improve guess)
    (/ (+ (/ x (square guess)) (* 2 guess)) 3))

  (define (cube-iter guess)
    (let ((next-guess (improve guess)))
      (if (good-enough? guess next-guess)
          next-guess
          (cube-iter next-guess))))

  (cube-iter 1.0)
)
