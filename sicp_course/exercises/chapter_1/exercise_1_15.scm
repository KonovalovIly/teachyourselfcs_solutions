(define (cube x)
    (* x x x)
)

(define (p x)
    (- (* 3 x) (* 4 (cube x)))
)

(define (sine angle)
    (if (not (> (abs angle) 0.1))
    angle
    (p (sine (/ angle 3.0))))
)

; a - Total p calls: 5 (one per recursive step except the last).
; b - Time O(log n), Space O(log n)
