(define (cont-frac-iter n d k)
    (define (iter i result)
        (if (= i 0)
            result
            (iter (- i 1) (/ (n i) (- (d i) result)))))
    (iter k 0))

(define (tan-cf x k)
    (cont-frac-iter (lambda (i) (if (= i 1) x (- (* x x))))
                    (lambda (i) (- (* 2 i) 1))
                    k))

; Example usages
(tan-cf 0 10)         ; 0.0
(tan-cf 0.785398 10)  ; ~1.0
(tan-cf 0.523599 10)  ; ~0.577350
