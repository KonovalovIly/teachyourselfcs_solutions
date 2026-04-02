(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else (+ (cc amount (except-first-denomination coin-values))
                 (cc (- amount (first-denomination coin-values)) coin-values)))))

(define (first-denomination coin-values)
  (car coin-values))

(define (except-first-denomination coin-values)
  (cdr coin-values))

(define (no-more? coin-values)
  (null? coin-values))

;Now: Does the order of coin-values affect the answer?
;✅ Short answer:
;No, the order does not affect the number of ways to make change.
;✅ Why?
;Because the program is recursively trying all possible ways to make change using the coins available. Whether you list coins from largest to smallest, or smallest to largest, the program systematically tries both "using" and "not using" each coin.
;So, although the structure of the computation (i.e., the recursion tree) and maybe performance might vary depending on the order, the final count of ways will be the same.
