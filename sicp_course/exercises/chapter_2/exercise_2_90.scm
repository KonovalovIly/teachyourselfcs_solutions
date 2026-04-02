(define (install-sparse-termlist-package)
  ;; internal definitions
  (define (adjoin-term order coeff term-list)
    (if (=zero? coeff)
        term-list
        (cons (make-term order coeff) term-list)))

  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))

  ;; register with data-directed system
  (put 'adjoin-term '(sparse) adjoin-term)
  (put 'first-term '(sparse) first-term)
  (put 'rest-terms '(sparse) rest-terms)
  (put 'empty-termlist? '(sparse) empty-termlist?)
  'done)

(define (adjoin-term type order coeff term-list)
  ((get 'adjoin-term (list type)) order coeff term-list))

(define (first-term type term-list)
  ((get 'first-term (list type)) term-list))

(define (rest-terms type term-list)
  ((get 'rest-terms (list type)) term-list))

(define (empty-termlist? type term-list)
  ((get 'empty-termlist? (list type)) term-list))

(define (make-polynomial var terms type)
  ((get 'make-polynomial type) var terms))

(define (install-polynomial-package)
  ;; generic polynomial ops go here
  (define (make-poly var terms) (cons var terms))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))

  ;; generic add, mul, etc., use term-list ops generically

  ;; register generic make
  (put 'make-polynomial 'sparse
       (lambda (var terms)
         (tag (make-poly var terms))))
  (put 'make-polynomial 'dense
       (lambda (var terms)
         (tag (make-poly var terms))))
  'done)

(define (build-termlist terms)
  (if (dense-enough? terms)
      (convert-to-dense terms)
      (convert-to-sparse terms)))

(define p1 (make-polynomial 'x '((2 1) (1 2) (0 3)) 'sparse))
(define p2 (make-polynomial 'x '#(3 0 2 1) 'dense))

(add p1 p2) ; works regardless of internal representation
