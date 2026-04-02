(define (attach-tag type-tag contents)
  (if (eq? type-tag 'scheme-number)
      contents  ; Don't tag ordinary numbers
      (cons type-tag contents)))

(define (type-tag datum)
  (cond ((number? datum) 'scheme-number)  ; Untagged numbers are scheme-numbers
        ((pair? datum) (car datum))
        (else (error "Bad tagged datum -- TYPE-TAG" datum))))

(define (contents datum)
  (cond ((number? datum) datum)  ; Contents of a number is the number itself
        ((pair? datum) (cdr datum))
        (else (error "Bad tagged datum -- CONTENTS" datum))))
