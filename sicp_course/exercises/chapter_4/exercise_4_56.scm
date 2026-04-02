; 1 - (and (supervisor ?person (Ben Bitdiddle)) (address ?person ?addr))
; 2 - (and (salary ?person ?amount) (salary (Ben Bitdiddle) ?ben-salary) (not (same ?person (Ben Bitdiddle))) (lisp-value < ?amount ?ben-salary))
; 3 - (and (supervisor ?person ?boss) (job ?boss (?boss-job . ?rest)) (not (eq ?boss-job computer)))
