(define (random-stream requests initial-seed)
  (define (rand-update seed)
    ; A simple pseudo-random number generator (e.g., linear congruential)
    (modulo (+ (* seed 1103515245) 12345) 2147483648)))

  (define (process requests seed)
    (if (stream-null? requests)
        the-empty-stream
        (let ((request (stream-car requests)))
          (cond
            ((eq? request 'generate)
                 (let ((new-seed (rand-update seed)))
                   (cons-stream
                    new-seed
                    (process (stream-cdr requests) new-seed))))
            ((pair? request)  ; reset command assumed to be (reset new-seed)
                 (process (stream-cdr requests) (cadr request)))
            (else (error "Unknown request"))
          
            )
            ))

  (process requests initial-seed))

(define requests
  (list->stream '(generate generate (reset 42) generate)))

(define random-numbers (random-stream requests 123))
