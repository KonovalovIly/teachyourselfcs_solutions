(define (make-frame variables values)
  (cons variables values))

(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))

(define (make-frame variables values)
  (map cons variables values))  ; List of (var . value) pairs

(define (frame-bindings frame) frame)  ; The frame is now just its bindings

(define (add-binding-to-frame! var val frame)
  (set! frame (cons (cons var val) frame)))

(define (binding-variable binding) (car binding))
(define (binding-value binding) (cdr binding))

(define (lookup-variable-value var env)
  (define (scan bindings)
    (cond ((null? bindings)
           (lookup-variable-value var (enclosing-environment env)))
          ((eq? var (binding-variable (car bindings)))
           (binding-value (car bindings)))
          (else (scan (cdr bindings)))))
  (if (eq? env the-empty-environment)
      (error "Unbound variable" var)
      (scan (frame-bindings (first-frame env)))))

(define (set-variable-value! var val env)
  (define (scan bindings)
    (cond ((null? bindings)
           (set-variable-value! var val (enclosing-environment env)))
          ((eq? var (binding-variable (car bindings)))
           (set-cdr! (car bindings) val))
          (else (scan (cdr bindings)))))
  (if (eq? env the-empty-environment)
      (error "Unbound variable -- SET!" var)
      (scan (frame-bindings (first-frame env)))))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan bindings)
      (cond ((null? bindings)
             (add-binding-to-frame! var val frame))
            ((eq? var (binding-variable (car bindings)))
             (set-cdr! (car bindings) val))
            (else (scan (cdr bindings)))))
    (scan (frame-bindings frame))))

(define env (extend-environment '(x y) '(1 2) the-empty-environment))
; Frame is now ((x . 1) (y . 2)) instead of ((x y) 1 2)

(lookup-variable-value 'x env)  ; => 1
(define-variable! 'z 3 env)     ; Frame becomes ((z . 3) (x . 1) (y . 2))
(set-variable-value! 'y 4 env)  ; Updates y's binding to 4
