(
    define (sub-interval in1 in2)
    (
        make-interval (- (lower-bound in1) (upper-bound in2))
                      (- (upper-bound in1) (lower-bound in2))
    )
)
