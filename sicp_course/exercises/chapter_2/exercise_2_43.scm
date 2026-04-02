(flatmap
  (lambda (rest-of-queens)
    (map (lambda (new-row)
           (adjoin-position new-row k rest-of-queens))
         (enumerate-interval 1 board-size)))
  (queen-cols (- k 1)))
