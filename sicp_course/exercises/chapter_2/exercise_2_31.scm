(define (square-tree func tree)
  (cond ((null? tree) '())
        ((not (pair? tree)) (func tree))
        (else
          (cons (square-tree func (car tree))
                (square-tree func (cdr tree))))))
