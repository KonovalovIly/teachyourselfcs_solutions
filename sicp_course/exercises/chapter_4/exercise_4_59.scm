(meeting ?division (Friday ?time))

(rule (meeting-time ?person ?day-and-time)
      (or (and (meeting whole-company ?day-and-time))
          (and (job ?person (?division . ?rest))
               (meeting ?division ?day-and-time))))

(meeting-time (Alyssa P. Hacker) (Wednesday ?time))
