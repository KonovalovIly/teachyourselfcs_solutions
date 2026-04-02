(define (square x) (* x x))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (let ((x (expmod base (/ exp 2) m)))
           (if (and (not (= x 1))
                    (not (= x (- m 1)))
                    (= (remainder (square x) m) 1))
               0
               (remainder (square x) m))))
        (else
         (remainder (* base (expmod base (- exp 1) m)) m))))

(define (miller-rabin-test n)
  (define (try-it a)
    (= (expmod a (- n 1) n) 1))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) #t)
        ((miller-rabin-test n) (fast-prime? n (- times 1)))
        (else #f)))
