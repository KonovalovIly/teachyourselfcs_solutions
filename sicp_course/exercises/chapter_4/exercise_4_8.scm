(define (let? exp) (tagged-list? exp 'let))
(define (let-name exp) (if (symbol? (cadr exp)) (cadr exp) #f))
(define (let-bindings exp)
  (if (named-let? exp) (caddr exp) (cadr exp)))
(define (let-body exp)
  (if (named-let? exp) (cdddr exp) (cddr exp)))

(define (named-let? exp)
  (and (let? exp) (symbol? (cadr exp))))

(define (let->combination exp)
  (if (named-let? exp)
      (named-let->combination exp)
      (regular-let->combination exp)))

(define (regular-let->combination exp)
  (cons (make-lambda (map car (let-bindings exp))
                     (let-body exp))
        (map cadr (let-bindings exp))))

(define (named-let->combination exp)
  (let ((name (let-name exp))
        (bindings (let-bindings exp))
        (body (let-body exp)))
    (make-let '()  ; Empty bindings for the outer let
      (list (list name
                  (make-lambda (map car bindings) body)))
      (cons name (map cadr bindings)))))
