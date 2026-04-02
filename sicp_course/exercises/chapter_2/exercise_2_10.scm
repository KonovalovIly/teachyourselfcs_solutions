(define (div-interval in1 in2)
    (
        if (span-zero? in2)
            (error "Denominator interval spans zero and cannot be used for division")
            (mul-interval x
                    (make-interval (/ 1.0 (upper-bound y))
                                   (/ 1.0 (lower-bound y))
                        )
                )
    )
)

;; Helper function to check if an interval spans zero
(define (spans-zero? interval)
  (and (<= (lower-bound interval) 0)
       (>= (upper-bound interval) 0)))
