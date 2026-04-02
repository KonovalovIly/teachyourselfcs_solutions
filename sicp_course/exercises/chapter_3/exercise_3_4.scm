(define (make-account balance password)
  (let ((consecutive-failures 0))  ; Local state for failed attempts
    (define (withdraw amount)
      (if (>= balance amount)
          (begin (set! balance (- balance amount))
                 balance)
          "Insufficient funds"))

    (define (deposit amount)
      (set! balance (+ balance amount))
      balance)

    (define (dispatch p m)
      (cond ((not (eq? p password)) (begin (set! consecutive-failures (+ consecutive-failures 1))
                   (if (> consecutive-failures 7)
                       (call-the-cops)
                       "Incorrect password")))
            (else
             (begin (set! consecutive-failures 0)  ; Reset on success
             (cond ((eq? m 'withdraw) withdraw)
                   ((eq? m 'deposit) deposit)
                   (else (error "Unknown request: MAKE-ACCOUNT" m)))))))
    dispatch)
)

(define (call-the-cops)
  "🚨 Police have been alerted!")
