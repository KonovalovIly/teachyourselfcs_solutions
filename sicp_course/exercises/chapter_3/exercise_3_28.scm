(
  define (or-gate w1 w2 out)
    (define (or-action-procedure)
      (let ((new-value (logical-or (set-signal w1) (get_signal w2))))
      (after-delay or-gate-delay (lambda () (set-signal! output new-value))))
    )
    (add-action! w1 or-action-procedure)
    (add-action! w2 or-action-procedure)
    `ok

(define (logical-or s1 s2)
  (cond ((and (= s1 0) (= s2 0)) 0)
        ((or (= s1 1) (= s2 1)) 1)
        (else (error "Invalid signal" s1 s2)))))
