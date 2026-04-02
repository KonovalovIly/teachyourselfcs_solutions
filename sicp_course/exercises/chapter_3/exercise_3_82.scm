(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (* (random) range))))

(define (monte-carlo experiment-stream passed total)
  (define (next passed total)
    (cons-stream
     (/ passed total)
     (monte-carlo (stream-cdr experiment-stream)
                  (+ passed (if (stream-car experiment-stream) 1 0))
                  (+ total 1))))
  (next passed total))

(define (estimate-integral p x1 x2 y1 y2)
  (define (experiment)
    (p (random-in-range x1 x2) (random-in-range y1 y2)))
  (define experiment-stream
    (stream-map (lambda (_) (experiment)) (integers-starting-from 1)))
  (define area (* (- x2 x1) (- y2 y1)))
  (stream-map (lambda (frac) (* area frac))
              (monte-carlo experiment-stream 0 0)))

(define (in-unit-circle? x y)
  (<= (+ (* x x) (* y y)) 1))

(define pi-estimates
  (estimate-integral in-unit-circle? -1 1 -1 1))

; First few estimates:
(stream-ref pi-estimates 10)    ; Early rough estimate
(stream-ref pi-estimates 100)   ; Better estimate
(stream-ref pi-estimates 1000)  ; More accurate
