(define (has-cycle? lst)
  (define (race tortoise hare)
    (cond ((or (not (pair? hare)) (not (pair? (cdr hare)))) #f) ; Reached end, no cycle
          ((eq? tortoise hare) #t) ; Pointers met, cycle detected
          (else (race (cdr tortoise) (cdr (cdr hare)))))) ; Move pointers
  (if (not (pair? lst))
      #f ; Empty or non-pair input
      (race lst (cdr lst))))
