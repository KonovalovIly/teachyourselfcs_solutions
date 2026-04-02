(
    define (make-mobile left right)
    (list left right)
)

(
    define (make-branch length structure)
    (list length structure)
)

; a
(
    define (left-branch x)
    (car x)
)

(
    define (right-branch x)
    (cadr x)
)

(
    define (branch-length x)
    (car x)
)

(
    define (branch-structure x)
    (cadr x)
)

;b
(
    define (total-weight mobile)
    (
        if (not (pair? mobile))
            mobile
            (+ (branch-weight (left-branch mobile))
                (branch-weight (right-branch mobile)))
    )
)

(
    define (branch-weight branch)
    (
        (let ((structure (branch-structure branch)))
        (if (number? structure)
            structure
            (total-weight structure)))
    )
)

;c
(define (balanced? mobile)
  (if (not (pair? mobile))
      #t
      (let ((left (left-branch mobile))
            (right (right-branch mobile)))
        (and (= (torque left) (torque right))
             (branch-balanced? left)
             (branch-balanced? right)))))

(define (torque branch)
  (* (branch-length branch)
     (branch-weight branch)))

(define (branch-balanced? branch)
  (let ((structure (branch-structure branch)))
    (if (number? structure)
        #t
        (balanced? structure))))
;d

;(define (right-branch mobile) (cdr mobile))
;(define (branch-structure branch) (cdr branch))
