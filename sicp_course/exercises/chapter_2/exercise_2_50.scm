(define (flip-horiz painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)    ; new origin
                     (make-vect 0.0 0.0)    ; new edge1 (left)
                     (make-vect 1.0 1.0)))  ; new edge2 (top)

(define (rotate180 painter)
  (transform-painter painter
                     (make-vect 1.0 1.0)    ; new origin
                     (make-vect -1.0 0.0)   ; new edge1
                     (make-vect 0.0 -1.0))) ; new edge2

(define (rotate270 painter)
  (transform-painter painter
                     (make-vect 0.0 1.0)    ; new origin
                     (make-vect 0.0 -1.0)   ; new edge1
                     (make-vect 1.0 0.0))) ; new edge2
