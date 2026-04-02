;; Generic equality predicate
(define (equ? x y) (apply-generic 'equ? x y))

;; Install methods for each type

;; For ordinary numbers
(put 'equ? '(scheme-number scheme-number)
     (lambda (x y) (= x y)))

;; For rational numbers
(put 'equ? '(rational rational)
     (lambda (x y)
       (= (* (numer x) (denom y))
          (* (numer y) (denom x)))))

;; For complex numbers
(put 'equ? '(complex complex)
     (lambda (x y)
       (and (= (real-part x) (real-part y))
            (= (imag-part x) (imag-part y)))))
