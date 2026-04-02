(define wave-with-smile
  (segments->painter
   (append
    wave-segments
    (list
     (make-segment (make-vect 0.4 0.6) (make-vect 0.5 0.7))     ; Left side of smile
     (make-segment (make-vect 0.5 0.7) (make-vect 0.6 0.6)))))  ; Right side of smile
)

(define (simpler-corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1)))
            (corner (simpler-corner-split painter (- n 1))))
        (beside (below painter up)
                (below right corner)))))

(define (outward-square-limit painter n)
  (let ((top-left (corner-split painter n))
        (top-right (flip-horiz (corner-split painter n)))
        (bottom-left (flip-vert (corner-split painter n)))
        (bottom-right (rotate180 (corner-split painter n))))
    (beside (below top-left top-right)
            (below bottom-left bottom-right))))
