; while implementation
(define (while->combination exp)
  (let ((test (cadr exp))
        (body (cddr exp)))
    (list 'let 'loop '()
          (list 'if test
                (append (list 'begin) body
                        (list (list 'loop)))
                #f))))

; for implementation
(define (for->combination exp)
  (let ((init (caadr exp))
        (test (cadadr exp))
        (update (car (cddadr exp)))
        (body (cddr exp)))
    (append (list 'let init)
            (list (list 'let 'loop '()
                  (list 'if test
                        (append (list 'begin) body
                                (list (list 'loop update)))
                        #f))))))

; until implementation
(define (until->combination exp)
  (let ((test (cadr exp))
        (body (cddr exp)))
    (list 'let 'loop '()
          (list 'if (list 'not test)
                (append (list 'begin) body
                        (list (list 'loop)))
                #t))))


(define (while? exp) (tagged-list? exp 'while))
(define (for? exp) (tagged-list? exp 'for))
(define (until? exp) (tagged-list? exp 'until))
