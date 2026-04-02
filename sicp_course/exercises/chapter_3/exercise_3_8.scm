(define f
  (let ((called #f))  ; State to track if f has been called
    (lambda (x)
      (if called
          0
          (begin (set! called #t)
                 x)))))
