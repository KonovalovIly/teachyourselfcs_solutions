(define (random-in-range low high)
  (+ low (random (- high low))))  ; [low, high)

(define (monte-carlo trials experiment)
  (define (iter remaining passed)
    (cond ((= remaining 0) (/ passed trials))
          ((experiment) (iter (- remaining 1) (+ passed 1)))
          (else (iter (- remaining 1) passed))))
  (iter trials 0))

(define (estimate-integral P x1 x2 y1 y2 trials)
  (let ((area-rect (* (- x2 x1) (- y2 y1)))
        (experiment
          (lambda ()
            (P (random-in-range x1 x2)
               (random-in-range y1 y2)))))
    (* area-rect (monte-carlo trials experiment))))

(define (in-unit-circle? x y)
  (<= (+ (square x) (square y)) 1))

(estimate-integral in-unit-circle? -1.0 1.0 -1.0 1.0 100000)
