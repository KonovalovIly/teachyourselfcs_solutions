(define (make-monitored f)
    (let ((count 0))
        (lambda (value)
        (if (eq? value 'how-many-calls?)
                count
                (begin
                    (set! count (+ count 1))
                    (f value)
                )
            )
        )
    )
)
