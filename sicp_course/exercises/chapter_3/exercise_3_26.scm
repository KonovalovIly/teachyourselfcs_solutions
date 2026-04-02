(define (make-tree-table compare)
  (let ((root '()))

    ;; Tree node constructor and selectors
    (define (make-entry key value) (list key value '() '()))
    (define (entry-key entry) (car entry))
    (define (entry-value entry) (cadr entry))
    (define (left-branch entry) (caddr entry))
    (define (right-branch entry) (cadddr entry))
    (define (set-left-branch! entry left) (set-car! (cddr entry) left))
    (define (set-right-branch! entry right) (set-car! (cdddr entry) right))
    (define (set-value! entry value) (set-car! (cdr entry) value))

    (define (lookup keys)
      (define (iter keys tree)
        (if (null? tree)
            #f
            (let ((current-key (entry-key tree)))
              (cond (((compare keys current-key) < 0)
                     (iter keys (left-branch tree)))
                    (((compare keys current-key) > 0)
                     (iter keys (right-branch tree)))
                    (else
                     (entry-value tree)))
      (iter keys root)))))

    (define (insert! keys value)
      (define (iter tree parent set-child!)
        (cond ((null? tree)
               (let ((new-entry (make-entry keys value)))
                 (set-child! parent new-entry)
                 'ok))
              (((compare keys (entry-key tree)) < 0)
               (iter (left-branch tree) tree set-left-branch!))
              (((compare keys (entry-key tree)) > 0)
               (iter (right-branch tree) tree set-right-branch!))
              (else
               (set-value! tree value)
               'ok))
      (if (null? root)
          (begin (set! root (make-entry keys value)) 'ok)
          (iter root #f (lambda (x y) (set! root y))))))


    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation -- TREE-TABLE" m))))


  dispatch
))

(define (numeric-compare a b)
  (cond ((< a b) -1)
        ((> a b) 1)
        (else 0)))

(define table (make-tree-table numeric-compare))
(define lookup (table 'lookup-proc))
(define insert! (table 'insert-proc!))

(insert! 10 'a)
(insert! 5 'b)
(insert! 15 'c)
(insert! 3 'd)
(insert! 7 'e)
