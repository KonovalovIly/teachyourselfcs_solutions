(define (double x) (+ x x))                    ; Doubles a number
(define (halve x) (/ x 2))                     ; Halves a number (assumes even input)


(define (fast-mult-iter a b)
  (define (iter result a b)
    (cond ((= b 0) result)                     ; Base case: return result
          ((even? b) (iter result (double a) (halve b)))  ; Halve b, double a
          (else (iter (+ result a) a (- b 1)))))          ; Decrement b, add a to result
  (iter 0 a b))                                ; Initialize result=0
