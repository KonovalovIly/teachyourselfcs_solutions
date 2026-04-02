;; Generic zero-test predicate
(define (=zero? x) (apply-generic '=zero? x))

;; Install methods for each type

;; Ordinary numbers
(put '=zero? '(scheme-number)
     (lambda (x) (= x 0)))

;; Rational numbers
(put '=zero? '(rational)
     (lambda (x) (= (numer x) 0)))

;; Complex numbers (rectangular comparison)
(put '=zero? '(complex)
     (lambda (x)
       (and (= (real-part x) 0)
            (= (imag-part x) 0))))
