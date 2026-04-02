(define (timed-prime-test n)
    (newline)
    (display n)
    (start-prime-test n (runtime))
)

(define (start-prime-test n start-time)
    (if (prime? n)
        (report-prime
        (- (runtime) start-time))
    )
)

(define (report-prime elapsed-time)
    (display " *** ")
    (display elapsed-time)
)


(define (square x) (* x x))

(define (divides? a b)
    (= (remainder b a) 0))

(define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (smallest-divisor n)
     (find-divisor n 2))

(define (prime? n)
     (= (smallest-divisor n) n))

(define (search-for-primes start k)
    (define (iter n count start-time)
        (cond (
            (= count k)
                (display "Done.")
                (newline))
            ((prime? n)
                (display n)
                (display " is prime. Time elapsed: ")
                (display (- (runtime) start-time))
                (newline)
                (iter (+ n 2) (+ count 1) (runtime)))
            (else
                (iter (+ n 2) count start-time))))
    (iter (if (even? start) (+ start 1) start) 0 (runtime)))
