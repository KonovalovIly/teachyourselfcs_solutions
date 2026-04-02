(define (for-each proc lst)
  (if (null? lst)
      'done
      (begin (proc (car lst))
             (for-each proc (cdr lst)))))
