(define (simpson-integral f a b n)

    (define h (/ (- b a) n))                ; calculate width

    (define (term k)
        (let ((y_k (f (+ a (* k h)))))
        (cond
            ((or (= k 0) (= k n)) y_k)
            ((odd? k) (* 4 y_k))
            (else (* 2 y_k))
            )
        )
    )                                       ; calculate function part

    (define (sum-term k)
        (if (> k n)
            0
            (+ (term k) (sum-term (+ k 1))))
    )                                       ; helper for sum-term

    (* (/ h 3) (sum-term 0))                ; all calculations
)

(define (cube x) (* x x x))
