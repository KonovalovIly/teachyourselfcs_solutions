(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m)) m))
        (else
         (remainder (* base (expmod base (- exp 1) m)) m)))
)

(define (carmichael-test n)
  (define (iter a)
    (cond ((= a n) #t)                      ; Все a проверены — это Кармайкла
          ((not (= (expmod a n n) (remainder a n))) #f)  ; Не прошёл тест — не Кармайкла
          (else (iter (+ a 1)))))           ; Проверяем следующее a
  (iter 1))                                 ; Начинаем с a=1
