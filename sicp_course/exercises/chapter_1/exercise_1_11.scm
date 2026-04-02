;recursive
(
    define
    (f n)
    (
        if (< n 3)
        n
        (+
            (f (- n 1))
            (* 2 f (- n 2))
            (* 3 f (- n 3))
        )
    )
)
;iterative
(define (f-iterative n)
  (define (iter a b c count)
    (if (= count n)
        a
        (iter (+ a (* 2 b) (* 3 c))   ; New a = f(count+1)
              a                       ; New b = f(count)
              b                       ; New c = f(count-1)
              (+ count 1))))          ; Increment count
    (if (< n 3)
      n
      (iter 2 1 0 2)
    )
)  ; Start with f(2)=2, f(1)=1, f(0)=0, count=2
