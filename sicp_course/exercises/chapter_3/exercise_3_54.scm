(define (integers-starting-from n)
  (cons-stream
    n
    (integers-starting-from (+ n 1))
    )
    )

(define integers (integers-starting-from 1))

(define (mul-streams s1 s2)
  (cons-stream
   (* (stream-car s1) (stream-car s2))
   (mul-streams (stream-cdr s1) (stream-cdr s2))))

(define factorials
  (cons-stream 1
               (mul-streams (integers-starting-from 2)
                            factorials)))
