(define (RC R C dt)
  (lambda (i-stream v0)
    (define v-stream
      (cons-stream v0
                   (add-streams (scale-stream i-stream (/ dt C))
                               (scale-stream v-stream (- (/ dt (* R C)))))))
    v-stream))

(define RC1 (RC 5 1 0.5))
