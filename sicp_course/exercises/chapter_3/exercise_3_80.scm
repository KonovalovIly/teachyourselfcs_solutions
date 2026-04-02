(define (integral delayed-integrand initial-value dt)
  (cons-stream
   initial-value
   (let ((integrand (force delayed-integrand)))
     (if (stream-null? integrand)
         the-empty-stream
         (integral (delay (stream-cdr integrand))
                   (+ (* dt (stream-car integrand))
                   initial-value)
                   dt)))))

(define (RLC R L C dt)
  (lambda (vC0 iL0)
    (define (dvC iL) (/ (- iL) C))
    (define (diL vC iL) (/ (- vC (* R iL)) L))

    (define vC (integral (delay dvC-stream) vC0 dt))
    (define iL (integral (delay diL-stream) iL0 dt))

    (define dvC-stream (stream-map dvC iL))
    (define diL-stream (stream-map diL vC iL))

    (cons vC iL)))


(define circuit ((RLC 1 1 0.2 0.1) 10 0))

(define vC (car circuit))
(define iL (cdr circuit))

; First few values:
(stream-ref vC 0)  ; 10 (initial voltage)
(stream-ref iL 0)  ; 0 (initial current)

(stream-ref vC 1)  ; ≈ 10 (since iL=0 initially)
(stream-ref iL 1)  ; ≈ 1 (vC/R = 10/1 = 10, but integrated)
