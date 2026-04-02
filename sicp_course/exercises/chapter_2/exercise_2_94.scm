(define (remainder-terms L1 L2)
  (cadr (div-terms L1 L2))) ; second element is remainder

(define (gcd-terms a b)
  (if (empty-termlist? b)
      a
      (gcd-terms b (remainder-terms a b))))

(define (gcd-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
      (make-polynomial (variable p1)
                       (gcd-terms (term-list p1)
                                  (term-list p2)))
      (error "Polynomials not in same variable -- GCD-POLY"
             (list p1 p2))))

(define (install-gcd-package)
  ;; internal procedures
  (define (gcd-numbers a b)
    (if (= b 0)
        a
        (gcd-numbers b (remainder a b))))

  ;; interface
  (put 'greatest-common-divisor '(scheme-number scheme-number)
       (lambda (a b) (tag (gcd-numbers (contents a) (contents b)))))

  (put 'greatest-common-divisor '(polynomial polynomial)
       (lambda (p1 p2) (tag (gcd-poly p1 p2))))

  'done)

(define (greatest-common-divisor x y)
  (apply-generic 'greatest-common-divisor x y))
