; From Exercise 1.42
(define (compose f g)
    (lambda (x) (f (g x))))

; Recursive version
(define (repeated-rec f n)
    (if (= n 1)
        f
        (compose f (repeated-rec f (- n 1)))))

; Iterative version
(define (repeated-iter f n)
    (define (iter count result)
        (if (= count n)
            result
            (iter (+ count 1) (compose f result))))
    (iter 1 f))

; Example usage
(define (square x) (* x x))
((repeated-rec square 2) 5) ; 625
((repeated-iter square 3) 2) ; 256
