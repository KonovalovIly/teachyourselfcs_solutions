(define (make-term order coeff) (list order coeff))
(define (order term) (car term))
(define (coeff term) (cadr term))

;; Term list operations for DENSE polynomials
(define (the-empty-termlist) '())
(define (empty-termlist? term-list) (null? term-list))

;; Represent term lists as vectors: index = order, value = coefficient
(define (adjoin-term term term-list)
  (let ((order (order term))
        (coeff (coeff term)))
    (if (=zero? coeff)
        term-list
        (let ((current-length (vector-length term-list)))
          (if (> order current-length)
              ;; Extend vector with zeros up to order - 1
              (let ((new-vector (make-vector (+ order 1) (make-integer 0))))
                (let copy ((i 0))
                  (if (< i current-length)
                      (begin
                        (vector-set! new-vector i (vector-ref term-list i))
                        (copy (+ i 1)))))
                (vector-set! new-vector order coeff)
                new-vector)
              ;; Otherwise, just update at position order
              (let ((new-vector (vector-copy term-list)))
                (vector-set! new-vector order coeff)
                new-vector)))))))

;; Get the highest-order non-zero term
(define (first-term term-list)
  (define (iter i)
    (if (< i 0)
        (error "Empty term list -- FIRST-TERM")
        (let ((coeff (vector-ref term-list i)))
          (if (not (=zero? coeff))
              (make-term i coeff)
              (iter (- i 1))))))
  (iter (- (vector-length term-list) 1)))

;; Remove the highest-order term
(define (rest-terms term-list)
  (let ((last (first-term term-list)))
    (let ((order (order last)))
      (let ((new-vector (vector-copy term-list 0 order)))
        new-vector))))

;; Tag system (optional, depends on your generic system)
(define (tag x) (attach-tag 'dense x))
