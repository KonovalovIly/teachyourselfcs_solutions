(define (subsets s)
  (if (null? s)
      (list '())  ; Base case: the empty set has one subset, the empty list
      (let ((rest (subsets (cdr s))))  ; Recursively compute subsets without (car s)
        (append rest
                (map (lambda (subset) (cons (car s) subset)) rest)))))
