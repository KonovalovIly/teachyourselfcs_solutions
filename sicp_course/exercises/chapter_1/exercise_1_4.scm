(define (a-plus-abs-b a b) ((if (> b 0) + -) a b))
;if b greater than 0 then a + b
;else a - b but b will negative and all expression transferred to a + b
