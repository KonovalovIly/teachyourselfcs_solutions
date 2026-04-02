(define (variable? x) (symbol? x))
(define (same-variable? v1 v2) (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (sum? x) (and (pair? x) (eq? (cadr x) '+)))

(define (addend s) (car s))
(define (augend s) (caddr s))

(define (product? x) (and (pair? x) (eq? (cadr x) '*)))

(define (multiplier p) (car p))
(define (multiplicand p) (caddr p))
(define (=number? exp num) (and (number? exp) (= exp num)))

(define (exponentiation? x) (and (pair? x) (eq? (cadr x) '**)))
(define (base p) (car p))
(define (exponent p) (caddr p))

(define
      (make-sum a1 a2)
      (cond
            ((=number? a1 0) a2)
            ((=number? a2 0) a1)
            ((and (number? a1) (number? a2)) (+ a1 a2))
            (else (list a1 '+ a2))
      )
)

(define
      (make-exponentiation b e)
      (cond
            ((=number? e 0) 1)
            ((=number? e 1) b)
            ((and (number? b) (number? e)) (expt b e))
            (else (list b '** e))
      )
)

(define
      (make-product m1 m2)
      (cond
            ((or (=number? m1 0) (=number? m2 0)) 0)
            ((=number? m1 1) m2) ((=number? m2 1) m1)
            ((and (number? m1) (number? m2)) (* m1 m2))
            (else (list m1 '* m2))
      )
)

(
      define (deriv exp var)
      (cond
            ((number? exp) 0)
            (
                  (variable? exp)
                  (if (same-variable? exp var) 1 0)
            )
            (
                  (sum? exp)
                  (make-sum
                        (deriv (addend exp) var)
                        (deriv (augend exp) var)
                  )
            )
            (
                  (product? exp)
                  (make-sum
                        (make-product
                              (multiplier exp)
                              (deriv (multiplicand exp) var)
                        )
                        (make-product
                              (deriv (multiplier exp) var)
                              (multiplicand exp)
                        )
                  )
            )
            (
                  (product? exp)
                  (make-sum
                        (make-product
                              (multiplier exp)
                              (deriv (multiplicand exp) var)
                        )
                        (make-product
                              (deriv (multiplier exp) var)
                              (multiplicand exp)
                        )
                  )
            )
            (
                  (exponentiation? exp)
                  (
                        make-product
                        (exponent exp)
                        (
                              make-product
                             (make-exponentiation (base exp) (make-sum -1 (exponent exp)))
                             (deriv (base exp) var)
                        )
                  )
            )
            (else (error "unknown expression type: DERIV" exp))
      )
)

;;; Part B: Standard algebraic notation with precedence
(define (operator-precedence op)
  (cond ((eq? op '*) 2)
        ((eq? op '+) 1)
        (else 0)))

(define (parse-infix expr)
  (if (not (pair? expr))
      expr
      (let ((left (parse-infix (car expr)))
            (op (cadr expr))
            (right (parse-infix (caddr expr))))

        (if (and (pair? right)
                 (< (operator-precedence op)
                    (operator-precedence (cadr right))))
            (list left op (parse-infix right))
            (list left op right)))))

(define (deriv-infix expr var)
  (deriv (parse-infix expr) var))
; it doesn`t work
