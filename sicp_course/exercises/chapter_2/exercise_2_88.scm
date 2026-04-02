(define (negate x) (apply-generic 'negate x))

(define (negate-term term)
  (make-term (order term) (negate (coeff term))))

(define (negate-poly p)
  (make-polynomial (variable p)
                   (map negate-term (term-list p))))

(put 'negate '(polynomial) (lambda (p) (tag (negate-poly p))))

(define (sub x y)
  (add x (negate y)))

(put 'sub '(polynomial polynomial)
     (lambda (x y) (tag (sub-poly x y))))

(define (sub-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
      (make-polynomial (variable p1)
                       (sub-terms (term-list p1)
                                  (term-list p2)))
      (error "Polynomials not in same variable -- SUB-POLY"
             (list p1 p2))))

(define (sub-terms L1 L2)
  (add-terms L1 (map negate-term L2)))


(define p1 (make-polynomial 'x '((2 4) (1 3) (0 2)))) ; 4x² + 3x + 2
(define p2 (make-polynomial 'x '((2 1) (1 1) (0 1)))) ; x² + x + 1
(define p3 (sub p1 p2)) ; ⇒ 3x² + 2x + 1
