(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))

  ;; make-rat no longer reduces
  (define (make-rat n d)
    (cons n d))

  (define (add-rat x y)
    (make-rat (add (mul (numer x) (denom y))
                   (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))

  (define (sub-rat x y)
    (make-rat (sub (mul (numer x) (denom y))
                   (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))

  (define (mul-rat x y)
    (make-rat (mul (numer x) (numer y))
              (mul (denom x) (denom y))))

  (define (div-rat x y)
    (make-rat (mul (numer x) (denom y))
              (mul (denom x) (numer y))))

  ;; interface to rest of system
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'equ? '(rational rational)
       (lambda (x y)
         (equ? (mul (numer x) (denom y))
               (mul (numer y) (denom x)))))
  (put '=zero? '(rational)
       (lambda (x) (=zero? (numer x))))
  (put 'raise '(rational) ...) ; optional, from earlier exercises
  'done)

(define (make-polynomial var terms)
  ((get 'make-polynomial 'sparse) var terms)) ; or 'dense if preferred

(define p1 (make-polynomial 'x '((2 1) (0 1)))) ; x² + 1
(define p2 (make-polynomial 'x '((3 1) (0 1)))) ; x³ + 1

(define (make-rational n d)
  ((get 'make 'rational) n d))

(define rf (make-rational p2 p1)) ; (x³ + 1)/(x² + 1)
(add rf rf)
