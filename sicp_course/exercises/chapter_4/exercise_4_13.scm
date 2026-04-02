(define (make-unbound? exp)
  (tagged-list? exp 'make-unbound!))

(define (make-unbound-variable exp)
  (cadr exp))

(define (remove-binding-from-frame! var frame)
  (define (scan prev-bindings bindings)
    (cond ((null? bindings)
           (error "Variable not found in frame -- MAKE-UNBOUND!" var))
          ((eq? var (binding-variable (car bindings)))
           (if (null? prev-bindings)
               (set! frame (cdr bindings))
               (set-cdr! prev-bindings (cdr bindings))))
          (else (scan bindings (cdr bindings)))))
  (scan '() frame))

(define (eval-make-unbound exp env)
  (let ((var (make-unbound-variable exp)))
    (remove-binding-from-frame! var (first-frame env))
    'ok))

(cond ((make-unbound? exp) (eval-make-unbound exp env))
      ...)

(define x 10)     ; x => 10
(make-unbound! x) ; Removes x binding
x                 ; Error: Unbound variable x
