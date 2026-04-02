(define (outline-painter frame)
  (let ((origin (origin-frame frame))
        (edge1 (edge1-frame frame))
        (edge2 (edge2-frame frame)))
    (segments->painter
      (list
        (make-segment origin (add-vect origin edge1))
        (make-segment origin (add-vect origin edge2))
        (make-segment (add-vect origin edge1)
                     (add-vect origin edge1 edge2))
        (make-segment (add-vect origin edge2)
                     (add-vect origin edge1 edge2))))))

(define (x-painter frame)
  (let ((origin (origin-frame frame))
        (edge1 (edge1-frame frame))
        (edge2 (edge2-frame frame)))
    (segments->painter
      (list
        (make-segment origin
                     (add-vect origin edge1 edge2))
        (make-segment (add-vect origin edge1)
                     (add-vect origin edge2))))))

(define (diamond-painter frame)
  (let ((origin (origin-frame frame))
        (edge1 (edge1-frame frame))
        (edge2 (edge2-frame frame))
        (half-edge1 (scale-vect 0.5 edge1))
        (half-edge2 (scale-vect 0.5 edge2)))
    (segments->painter
      (list
        (make-segment (add-vect origin half-edge1)
                     (add-vect origin half-edge2))
        (make-segment (add-vect origin half-edge2)
                     (add-vect origin edge1 half-edge2))
        (make-segment (add-vect origin edge1 half-edge2)
                     (add-vect origin half-edge1 edge2))
        (make-segment (add-vect origin half-edge1 edge2)
                     (add-vect origin half-edge1))))))

(define (wave-painter frame)
  (let ((p1 (make-vect 0.2 0.4))
        (p2 (make-vect 0.4 0.6))
        (p3 (make-vect 0.6 0.4))
        (p4 (make-vect 0.8 0.8))
        (p5 (make-vect 1.0 0.6)))
    (segments->painter
      (list
        (make-segment (make-vect 0.0 0.6) p1)
        (make-segment p1 p2)
        (make-segment p2 p3)
        (make-segment p3 p4)
        (make-segment p4 p5)))))
