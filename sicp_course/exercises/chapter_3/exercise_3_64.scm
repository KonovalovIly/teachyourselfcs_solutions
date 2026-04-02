(define (stream-limit s tolerance)
  (let loop ((s s))
    (let ((current (stream-car s))
          (next (stream-car (stream-cdr s))))
      (if (< (abs (- next current)) tolerance)
          next
          (loop (stream-cdr s))))))

(define (sqrt-stream x)
  (define guesses
    (cons-stream 1.0
                 (stream-map (lambda (guess)
                               (sqrt-improve guess x))
                             guesses)))
  guesses)

(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))
