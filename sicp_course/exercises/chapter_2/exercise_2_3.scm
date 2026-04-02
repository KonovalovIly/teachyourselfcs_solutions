; point func
(define (x-point point) (car point))
(define (y-point point) (cdr point))
(define (make-point x y) (cons x y))


(define (width rect)
  (- (x-point (top-right rect))
     (x-point (bottom-left rect))))

(define (height rect)
  (- (y-point (top-right rect))
     (y-point (bottom-left rect))))

(define (perimeter rect)
  (* 2 (+ (width rect) (height rect))))

(define (area rect)
  (* (width rect) (height rect)))


; Constructor: Takes two points (bottom-left and top-right)
(define (make-rectangle p1 p2) (cons p1 p2))

; Selectors
(define (bottom-left rect) (car rect))
(define (top-right rect) (cdr rect))


(define p1 (make-point 0 0))
(define p2 (make-point 4 3))
(define rect1 (make-rectangle p1 p2))
