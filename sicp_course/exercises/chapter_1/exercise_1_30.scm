(define (sum term a next b)
    (define (iter a result)
        (if (> a b)
            result
            (iter (next a) (+ result (term a)))))
    (iter a 0)
)


(define (square x) (* x x))
(define (inc x) (+ x 1))

(sum square 1 inc 3) ; Expected: 1 + 4 + 9 = 14
