(define (p) (p))
(define (test x y) (if (= x 0) 0 y))

(test 0 (p)) ; in applicative order result will be 0 because we do not need to evaluate y in normal infinite recursion
