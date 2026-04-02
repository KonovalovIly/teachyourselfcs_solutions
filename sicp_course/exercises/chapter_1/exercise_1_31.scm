(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b)))
)

(define (identity x) x)
(define (inc x) (+ x 1))

(define (factorial n) (product identity 1 inc n))


(define (pi-product n)
    (define (term k)
        (/  (* (* 2 k) (* 2 k))
            (* (- (* 2 k) 1) (+ (* 2 k) 1))))
    (* 4 (product term 1 inc n))
)

(define (product-iter term a next b)
    (define (iter a result)
        (if (> a b)
            result
            (iter (next a) (* result (term a)))))
    (iter a 1)
)
