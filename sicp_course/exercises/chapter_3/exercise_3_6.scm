(define rand
  (let ((state 0))  ; Internal state initialized to 0
    (lambda (message . args)
      (cond ((eq? message 'generate)
             (set! state (random state))  ; Update state
             state)                       ; Return new random number
            ((eq? message 'reset)
             (set! state (car args)))     ; Reset state to provided value
            (else
             (error "Unknown message: RAND" message))))))
