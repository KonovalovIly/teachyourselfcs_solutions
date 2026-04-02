(rule (can-replace ?person1 ?person2)
      (and (not (same ?person1 ?person2))
           (or (same-job ?person1 ?person2)
               (can-do-job (job ?person1) (job ?person2)))))

(rule (same-job ?p1 ?p2)
      (and (job ?p1 ?job)
           (job ?p2 ?job)))

(rule (can-do-job ?job1 ?job2)
      (can-perform ?job1 ?job2))


(can-replace ?who (Cy D. Fect))

(and (can-replace ?replacer ?replaced)
     (salary ?replacer ?s-replacer)
     (salary ?replaced ?s-replaced)
     (lisp-value < ?s-replacer ?s-replaced))
