(define (make-table)
  (let ((local-table (list '*table*)))

    (define (assoc key records)
      (cond ((null? records) #f)
            ((equal? key (caar records)) (car records))
            (else (assoc key (cdr records)))))

    (define (lookup keys)
      (define (iter keys table)
        (let ((subtable (assoc (car keys) (cdr table))))
          (if subtable
              (if (null? (cdr keys))
                  (cdr subtable)
                  (iter (cdr keys) subtable))
              #f)))
      (iter keys local-table))

    (define (insert! keys value)
      (define (iter keys table)
        (let ((subtable (assoc (car keys) (cdr table))))
          (if subtable
              (if (null? (cdr keys))
                  (set-cdr! subtable value)
                  (iter (cdr keys) subtable))
              (let ((new-subtable
                     (if (null? (cdr keys))
                         (cons (car keys) value)
                         (list (car keys)))))
                (set-cdr! table
                          (cons new-subtable (cdr table)))
                (if (not (null? (cdr keys)))
                    (iter (cdr keys) new-subtable)))))
      (iter keys local-table)
      'ok)

    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation -- TABLE" m))))

    dispatch))
