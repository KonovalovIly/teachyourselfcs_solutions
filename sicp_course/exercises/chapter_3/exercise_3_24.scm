(define (make-table same-key?)
  (let ((local-table '()))

    (define (assoc key records)
      (cond ((null? records) #f)
            ((same-key? key (caar records)) (car records))
            (else (assoc key (cdr records)))))

    (define (lookup key)
      (let ((record (assoc key local-table)))
        (if record
            (cdr record)
            #f)))

    (define (insert! key value)
      (let ((record (assoc key local-table)))
        (if record
            (set-cdr! record value)
            (set! local-table (cons (cons key value) local-table))))
      'ok)

    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            ((eq? m 'print) local-table)
            (else (error "Unknown operation -- TABLE" m))))

    dispatch))
