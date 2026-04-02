;; Constructor: center + width
(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))

;; Selectors
(define (center interval) (center (/ (+ (lower-bound interval) (upper-bound interval)) 2)))
(define (width i) (/ (- (upper-bound i) (lower-bound i)) 2))

;; New: center + percentage tolerance
(define (make-center-percent c p)
  (let ((w (* c (/ p 100.0))))
    (make-center-width c w)))

(define (percent i)
  (* 100.0 (/ (width i) (center i))))

