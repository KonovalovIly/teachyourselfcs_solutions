(define (cont-frac n d k)
    (define (frac i)
        (if (> i k)
            0
            (/ (n i) (+ (d i) (frac (+ i 1))))))
    (frac 1))

(define (reciprocal-phi k)
  (cont-frac (lambda (i) 1.0) (lambda (i) 1.0) k))

; b

(define (cont-frac-iter n d k)
  (define (iter i result)
    (if (= i 0)
        result
        (iter (- i 1) (/ (n i) (+ (d i) result)))))
  (iter k 0))
