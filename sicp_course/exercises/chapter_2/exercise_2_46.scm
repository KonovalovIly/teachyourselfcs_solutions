(define make-vect cons)
(define xcor-vect car)
(define ycor-vect cdr)

(
    define (add-vect a b)
    (
        make-vect
            (+ (xcor-vect a) (xcor-vect b))
            (+ (ycor-vect a) (ycor-vect b))
    )
)

(
    define (sub-vect a b)
    (
        make-vect
            (- (xcor-vect a) (xcor-vect b))
            (- (ycor-vect a) (ycor-vect b))
    )
)

(
    define (scale-vect k a)
    (
        make-vect
            (* k (xcor-vect a))
            (* k (ycor-vect a))
    )
)
