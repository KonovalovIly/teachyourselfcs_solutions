; point func
(define (x-point point) (car point))
(define (y-point point) (cdr point))
(define (make-point x y) (cons x y))

;segment func
(define (start-segment segment) (car segment))
(define (end-segment segment) (cdr segment))
(define (make-segment start end) (cons start end))


; midpoint
(define (midpoint-segment segment)
    (
        (let ((start-point (start-segment segment))
              (end-point (end-segment segment)))
        (make-segment
            ( / (+ (x-point start-point) (x-point end-point)) 2 )
            ( / (+ (y-point start-point) (y-point end-point)) 2 )))
    )
)

(define st (make-point -1 -1))
(define et (make-point 1 1))
(define ms (make-segment st et))
