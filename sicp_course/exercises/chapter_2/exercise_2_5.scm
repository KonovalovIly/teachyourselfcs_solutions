(define (cons a b)
  (* (expt 2 a) (expt 3 b)))

(define (car n)
  (if (= (remainder n 2) 0)
      (+ 1 (car (/ n 2)))
      0))

(define (cdr n)
  (if (= (remainder n 3) 0)
      (+ 1 (cdr (/ n 3)))
      0))

(define p (cons 3 2))  ; => 2³ * 3² = 8 * 9 = 72
(car p)                ; => 3 (since 72 / 2 / 2 / 2 = 9, 3 divisions)
(cdr p)                ; => 2 (since 72 / 3 / 3 = 8, 2 divisions)
