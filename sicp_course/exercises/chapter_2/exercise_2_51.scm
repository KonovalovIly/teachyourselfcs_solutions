(define (below painter1 painter2)
  (let ((split-point (make-vect 0.0 0.5))) ; Split at y = 0.5
    (let ((paint-bottom
           (transform-painter painter1
                              (make-vect 0.0 0.0)      ; New origin (bottom-left)
                              (make-vect 1.0 0.0)      ; New edge1 (right)
                              (make-vect 0.0 split-point))) ; New edge2 (halfway up)
          (paint-top
           (transform-painter painter2
                              (make-vect 0.0 split-point)  ; New origin (middle-left)
                              (make-vect 1.0 split-point)  ; New edge1 (middle-right)
                              (make-vect 0.0 1.0))))       ; New edge2 (top)
      (lambda (frame)
        (paint-bottom frame)
        (paint-top frame)))))

(define (below painter1 painter2)
  (rotate270 (beside (rotate90 painter1) (rotate90 painter2))))

(define (rotate90 painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)    ; New origin (bottom-right)
                     (make-vect 1.0 1.0)    ; New edge1 (top-right)
                     (make-vect 0.0 0.0)))  ; New edge2 (bottom-left)

(define (rotate270 painter)
  (transform-painter painter
                     (make-vect 0.0 1.0)    ; New origin (top-left)
                     (make-vect 0.0 0.0)    ; New edge1 (bottom-left)
                     (make-vect 1.0 1.0)))  ; New edge2 (top-right)
