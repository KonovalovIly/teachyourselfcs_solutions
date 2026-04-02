(rule (big-shot ?person)
      (and (job ?person (?division . ?role))
           (not (and (supervisor ?person ?boss)
                     (job ?boss (?division . ?boss-role))))))
