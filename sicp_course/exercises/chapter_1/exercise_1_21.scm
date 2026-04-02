(define (square x) (* x x))

(define (divides? a b)
  (= (remainder b a) 0))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (smallest-divisor n)
  (find-divisor n 2))

; Result: 199 (no divisors other than 1 and itself).
; Result: 1999 (no divisors other than 1 and itself).
; Result: 7 (since 19999 = 7 × 2857).
