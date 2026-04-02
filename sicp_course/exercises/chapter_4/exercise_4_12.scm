(define (traverse-environment var env if-found if-not-found)
  (define (scan bindings)
    (cond ((null? bindings)
           (traverse-environment var
                               (enclosing-environment env)
                               if-found
                               if-not-found))
          ((eq? var (binding-variable (car bindings)))
           (if-found (car bindings)))
          (else (scan (cdr bindings)))))
  (if (eq? env the-empty-environment)
      (if-not-found)
      (scan (frame-bindings (first-frame env)))))

(define (lookup-variable-value var env)
  (traverse-environment
   var env
   (lambda (binding) (binding-value binding))
   (lambda () (error "Unbound variable" var))))

(define (set-variable-value! var val env)
  (traverse-environment
   var env
   (lambda (binding) (set-cdr! binding val))
   (lambda () (error "Unbound variable -- SET!" var))))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (traverse-environment
     var env
     (lambda (binding) (set-cdr! binding val))
     (lambda () (add-binding-to-frame! var val frame)))))

(define (binding-variable binding) (car binding))
(define (binding-value binding) (cdr binding))

(define (add-binding-to-frame! var val frame)
  (set! frame (cons (cons var val) frame)))
