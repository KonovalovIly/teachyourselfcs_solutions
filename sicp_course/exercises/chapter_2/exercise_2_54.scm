(define (equal? a b)
  (cond ((and (not (pair? a)) (not (pair? b))) (eq? a b)) ; Both are non-pairs (symbols or empty lists)
        ((and (pair? a) (pair? b))           ; Both are lists
         (and (equal? (car a) (car b))
              (equal? (cdr a) (cdr b)))
        (else #f))))                          ; One is a list, the other isn't
