;;; New syntax predicates and selectors

(define (self-evaluating? exp)
  (or (number? exp) (string? exp) (boolean? exp)))

(define (variable? exp) (symbol? exp))

(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (assignment? exp)
  (tagged-list? exp 'set!))

(define (definition? exp)
  (tagged-list? exp 'define))

(define (lambda? exp)
  (tagged-list? exp 'lambda))

(define (if? exp)
  (tagged-list? exp 'if))

(define (begin? exp)
  (tagged-list? exp 'begin))

(define (application? exp)
  (pair? exp))  ; Now handles both (func args) and [func args]

(define (operator app)
  (if (square-brackets? app)
      (cadr app)
      (car app)))

(define (operands app)
  (if (square-brackets? app)
      (cddr app)
      (cdr app)))

(define (square-brackets? exp)
  (and (pair? exp) (eq? (car exp) 'vector))) ; We'll parse [x y] as (vector x y)


(define (parse exp)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) exp)
        ((quoted? exp) exp)
        ((and (pair? exp) (eq? (car exp) 'vector))  ; [f x] becomes (vector f x)
         (cons (cadr exp) (cddr exp)))  ; Convert to normal application
        (else exp)))

(define (lookup-variable-value var env)
  (env-lookup var env 'variable))

(define (lookup-function-value var env)
  (env-lookup var env 'function))

(define (env-lookup var env namespace)
  (define (scan vars vals)
    (cond ((null? vars) (env-lookup var (enclosing-environment env) namespace))
          ((eq? var (car vars)) (car vals))
          (else (scan (cdr vars) (cdr vals)))))
  (if (eq? env the-empty-environment)
      (error "Unbound variable" var)
      (let ((frame (first-frame env)))
        (scan (namespace-vars frame namespace)
              (namespace-vals frame namespace)))))
