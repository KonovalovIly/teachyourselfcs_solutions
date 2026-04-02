(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))

  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)

  (define (dispatch p m)
    (if (eq? p password)
        (cond ((eq? m 'withdraw) withdraw)
              ((eq? m 'deposit) deposit)
              (else (error "Unknown request: MAKE-ACCOUNT" m)))
        (lambda (_) "Incorrect password")))
  dispatch)

(define (make-joint account old-password new-password)
  (define (dispatch p m)
    (if (eq? p new-password)
        (account old-password m)  ; Delegate to original account
        (lambda (_) "Incorrect joint password")))
  dispatch)

(define peter-acc (make-account 100 'open-sesame))
(define paul-acc (make-joint peter-acc 'open-sesame 'rosebud))
