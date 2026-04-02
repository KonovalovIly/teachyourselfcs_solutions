(define (make-accumulator start)
    (lambda (value)
        (begin
            (set! start (+ start value))
            start
        )
    )
)
