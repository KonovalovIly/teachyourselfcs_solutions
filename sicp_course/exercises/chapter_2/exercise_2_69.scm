(define (successive-merge leaf-set)
  (if (null? (cdr leaf-set))  ; Only one node left
      (car leaf-set)
      (let ((first (car leaf-set))
            (second (cadr leaf-set))
            (rest (cddr leaf-set)))
        (successive-merge
          (adjoin-set (make-code-tree first second)
                      rest)))))
