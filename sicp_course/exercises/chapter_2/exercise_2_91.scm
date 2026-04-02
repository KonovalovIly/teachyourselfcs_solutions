(define (div-terms L1 L2)
  (if (empty-termlist? L1)
      (list (the-empty-termlist) ; quotient
            (the-empty-termlist)) ; remainder
      (let ((t1 (first-term L1))
            (t2 (first-term L2)))
        (if (> (order t2) (order t1))
            (list (the-empty-termlist) L1) ; quotient = 0, remainder = L1
            (let ((new-c (div (coeff t1) (coeff t2)))
                  (new-o (- (order t1) (order t2))))
              (let ((term (make-term new-o new-c)))
                (let ((rest-of-result
                       (div-terms
                        (sub L1 (mul-terms (list term) L2)) ; subtract term * divisor
                        L2)))
                  (list
                   (adjoin-term new-o new-c (car rest-of-result)) ; add term to quotient
                   (cadr rest-of-result))))))))) ; remainder is second part

(define (div-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
      (let ((result (div-terms (term-list p1) (term-list p2))))
        (list
         (make-polynomial (variable p1) (car result))     ; quotient
         (make-polynomial (variable p1) (cadr result))))   ; remainder
      (error "Polynomials not in same variable -- DIV-POLY"
             (list p1 p2))))

(put 'div '(polynomial polynomial)
     (lambda (p1 p2)
       (let ((result (div-poly p1 p2)))
         (list (car result) (cadr result)))))

(define p1 (make-polynomial 'x '((5 1) (4 0) (3 -1) (2 -2) (1 1) (0 -1)) 'sparse))
; x^5 - x^3 - 2x^2 + x - 1

(define p2 (make-polynomial 'x '((2 1) (0 -1)) 'sparse))
; x^2 - 1

(div-poly p1 p2)
;; ⇒ ( (x^3 + x) , (x - 1) )
