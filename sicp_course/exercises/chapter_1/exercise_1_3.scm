(define (square x) (* x x))

(define (max_t x y z)
    (cond
        ((and (>= x z) (>= x y)) x)
        ((and (>= y z) (>= y x)) y)
        ((and (>= z x) (>= z y)) z)
    )
)

(define (max x y)
    (if (> x y) x y)
)

(define (process x y z)
    ( +
        (square (max_t x y z))
        (square (cond
            (( = (max_t x y z) x) (max y z))
            (( = (max_t x y z) y) (max x z))
            (( = (max_t x y z) z) (max x y))
            )
        )
    )
)
