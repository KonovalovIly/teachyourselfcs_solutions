(define (cont-frac n d k)
    (define (frac i)
        (if (> i k)
            0
            (/ (n i) (+ (d i) (frac (+ i 1))))))
    (frac 1))

(define (d i)
    (if (= (remainder i 3) 2)
        (* 2 (/ (+ i 1) 3))
        1))

(define (approximate-e k)
    (+ 2 (cont-frac (lambda (i) 1.0) d k)))
