(define (sqrt x)
  (define (good-enough? old-guess new-guess)
    (< (abs (- new-guess old-guess))
       (* 0.0001 old-guess))) ; Relative tolerance

  (define (improve guess)
    (/ (+ guess (/ x guess)) 2))

  (define (sqrt-iter guess)
    (let ((next-guess (improve guess)))
      (if (good-enough? guess next-guess)
          next-guess
          (sqrt-iter next-guess))))
          
  (sqrt-iter 1.0))
