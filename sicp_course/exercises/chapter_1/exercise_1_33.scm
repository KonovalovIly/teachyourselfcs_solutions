(define (filtered-accumulate combiner null-value term a next b filter)
    (if (> a b)
        null-value
        (if (filter a)
            (combiner (term a) (filtered-accumulate combiner null-value term (next a) next b filter))
            (filtered-accumulate combiner null-value term (next a) next b filter)))
)

(define (filtered-accumulate-iter combiner null-value term a next b filter)
    (define (iter a result)
        (if (> a b)
            result
            (iter (next a) (if (filter a)
                            (combiner (term a) result)
                            result))))
    (iter a null-value)
)

(define (inc x) (+ 1 x))

(define (prime? n)
    (define (smallest-divisor n)
        (define (find-divisor n test-divisor)
        (cond ((> (* test-divisor test-divisor) n) n)
                ((= (remainder n test-divisor) 0) test-divisor)
                (else (find-divisor n (+ test-divisor 1)))))
        (find-divisor n 2))
    (and (> n 1) (= (smallest-divisor n) n))
)

(define (sum-of-squares-of-primes a b)
    (filtered-accumulate + 0 (lambda (x) (* x x)) a inc b prime?))

(define (product-of-relative-primes n)
    (define (relative-prime? x)
        (= (gcd x n) 1))
    (filtered-accumulate * 1 identity 1 inc (- n 1) relative-prime?)
)
