;; Using fold-right (inefficient)
(define (reverse sequence)
  (fold-right (lambda (x y) (append y (list x))) '() sequence))

;; Using fold-left (efficient)
(define (reverse sequence)
  (fold-left (lambda (x y) (cons y x)) '() sequence))
