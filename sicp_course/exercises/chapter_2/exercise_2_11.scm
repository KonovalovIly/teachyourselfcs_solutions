(define (mul-interval in1 in2)
    (let
        (
            (a (lower-bound in1))
            (b (upper-bound in1))
            (c (lower-bound in2))
            (d (upper-bound in2))
        )
        (cond
            ((and (>= a 0) (>= c 0)) (make-interval (* a c) (* b d)))          ; Case 1
            ((and (>= a 0) (<= d 0)) (make-interval (* b c) (* a d)))          ; Case 2
            ((and (>= a 0) (< c 0) (> d 0)) (make-interval (* b c) (* b d)))   ; Case 3
            ((and (<= b 0) (>= c 0)) (make-interval (* a d) (* b c)))          ; Case 4
            ((and (<= b 0) (<= d 0)) (make-interval (* b d) (* a c)))          ; Case 5
            ((and (<= b 0) (< c 0) (> d 0)) (make-interval (* a d) (* a c)))   ; Case 6
            ((and (< a 0) (> b 0) (>= c 0)) (make-interval (* a d) (* b d)))   ; Case 7
            ((and (< a 0) (> b 0) (<= d 0)) (make-interval (* b c) (* a c)))   ; Case 8
            ((and (< a 0) (> b 0) (< c 0) (> d 0))                             ; Case 9
                    (let ((p1 (* a c))
                       (p2 (* a d))
                       (p3 (* b c))
                       (p4 (* b d)))
                    (make-interval (min p1 p2 p3 p4) (max p1 p2 p3 p4))))
        )
    )
)
