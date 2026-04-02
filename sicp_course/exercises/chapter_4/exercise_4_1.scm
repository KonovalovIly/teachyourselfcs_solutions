(define (list-of-values-ltr exps env)
  (if (no-operands? exps)
      '()
      (let ((first (eval (first-operand exps) env)))
        (cons first
              (list-of-values-ltr (rest-operands exps) env)))))

(define (list-of-values-rtl exps env)
  (if (no-operands? exps)
      '()
      (let ((rest (list-of-values-rtl (rest-operands exps) env)))
        (cons (eval (first-operand exps) env)
              rest))))

(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

(list-of-values-ltr '((a) (b) (c)) 'fake)
;; Should evaluate a, then b, then c

(list-of-values-rtl '((a) (b) (c)) 'fake)
;; Should evaluate c, then b, then a
