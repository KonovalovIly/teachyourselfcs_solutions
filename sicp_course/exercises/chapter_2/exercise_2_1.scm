(define
    (make-rat n d)
    (let ((g (gcd n d)))
        (cond
            ((and (> 0 n) (> 0 d)) (cons (-(/ n g)) (- (/ d g))))
            ((and (< 0 n) (> 0 d)) (cons (-(/ n g)) (- (/ d g))))
            (else(cons (/ n g) (/ d g)))
        )
    )
)
