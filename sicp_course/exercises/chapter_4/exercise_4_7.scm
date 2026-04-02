(define (let*? exp) (tagged-list? exp 'let*))
(define (let*-bindings exp) (cadr exp))
(define (let*-body exp) (cddr exp))

(define (let*->nested-lets exp)
  (let ((bindings (let*-bindings exp))
        (body (let*-body exp)))
    (define (make bindings)
      (if (null? bindings)
          body
          (list 'let
                (list (car bindings))
                (make (cdr bindings)))))
    (make bindings)))
