(define (variable<? v1 v2)
  (string<? (symbol->string v1) (symbol->string v2)))


(add (make-polynomial 'x '((2 1) (1 2)))      ; x² + 2x
     (make-polynomial 'y '((1 1) (0 3))))     ; y + 3

;; ⇒ make-polynomial 'y '((1 1) (0 (add 3 (tagged polynomial x ...)))))

(define (coerce-to-var p target-var)
  (if (variable<? (variable p) target-var)
      (list (make-term 0 p)) ; wrap entire poly as constant term
      (error "Cannot coerce to lower variable")))

(define (add-poly p1 p2)
  (cond ((same-variable? (variable p1) (variable p2))
         (make-poly (variable p1)
                    (add-terms (term-list p1)
                               (term-list p2))))
        ((variable<? (variable p1) (variable p2))
         (let ((p1-as-term (coerce-to-var p1 (variable p2))))
           (add-poly (make-poly (variable p2) p1-as-term) p2)))
        (else
         (let ((p2-as-term (coerce-to-var p2 (variable p1))))
           (add-poly p1 (make-poly (variable p1) p2-as-term))))))

(define p1 (make-polynomial 'x '((2 1) (1 -2) (0 1)))) ; x² - 2x + 1
(define p2 (make-polynomial 'y '((1 1) (0 3))))         ; y + 3

(add p1 p2)
;; ⇒ (polynomial y (1 1) (0 (polynomial x (2 1) (1 -2) (0 1))))
