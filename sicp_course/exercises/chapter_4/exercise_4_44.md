## 🧠 Understanding the Eight-Queens Puzzle

We want to generate all possible placements of 8 queens such that:
- Each queen is in a different row
- Each queen is in a different column
- No two queens are on the same diagonal

The standard solution uses **backtracking** to try placing one queen per column, checking for conflicts with earlier ones.

In this version, we’ll use the `amb` operator to explore choices and `require` to filter out invalid positions.

---

## 🔍 Strategy Using `amb`

We'll build a list of queen positions where:
- The index represents the **column**
- The value at each index represents the **row**

Example: `(1 3 6 2 7 4 0 5)` means:
- Column 0 → Row 1
- Column 1 → Row 3
- etc.

We’ll define a recursive procedure that chooses a row for each column, ensuring no conflict with previous queens.

---

## ✅ Full Implementation Using `amb`

```scheme
(define (queens n)
  (define (queen-cols k)
    (if (= k 0)
        '()
        (let ((rest-of-queens (queen-cols (- k 1))))
          (let ((new-row (an-integer-between 0 (- n 1))))
          (require (safe? new-row rest-of-queens))
          (cons new-row rest-of-queens)))))
  (queen-cols n))
```

Where:

- `queen-cols` builds up the board recursively from column 0 to n−1
- `an-integer-between` generates rows from 0 to n−1
- `safe?` checks if placing a queen at `new-row` in current column is safe relative to the already placed queens

---

## 🛠️ Define `an-integer-between`

```scheme
(define (an-integer-between low high)
  (define (loop i)
    (if (> i high)
        (amb)
        (amb i (loop (+ i 1)))))
  (loop low))
```

---

## 📌 Define `safe?`

A queen is safe if it doesn't conflict with any previously placed queen in terms of:
- Same row (already ensured by distinct choice)
- Diagonal (difference in row = difference in column)

```scheme
(define (safe? row positions)
  (define (conflict? r col other-queens)
    (cond ((null? other-queens) #f)
          ((= r (car other-queens)) #t) ; same row
          ((= (abs (- r (car other-queens))) col) #t) ; same diagonal
          (else (conflict? r (+ col 1) (cdr other-queens))))
  (not (conflict? row 0 positions)))
```

Wait — better version:

```scheme
(define (safe? row positions)
  (define (check posn col)
    (if (null? posn)
        #t
        (let ((r (car posn)))
          (and (not (= r row))                     ; not same row
               (not (= (abs (- r row)) col))       ; not same diagonal
               (check (cdr posn) (+ col 1)))))     ; check rest
  (check positions 1))
```

---

## 🧪 Example Usage

To find one valid configuration:

```scheme
(queens 8)
→ (0 4 7 5 2 6 1 3) ; One valid solution
```

You can keep typing:

```scheme
try-again
```

To find more solutions.

There are **92 total solutions** for the 8-Queens problem.

But our code will return only **one at a time**, as expected in the `amb` evaluator.

---

## 📦 Summary of Key Components

| Component | Description |
|----------|-------------|
| Goal | Place 8 queens safely on a board |
| Representation | A list of row positions per column |
| Non-Determinism | Use `amb` to choose rows |
| Constraint Checking | Ensure each new queen is safe |
| Backtracking | Automatic via `amb` and `require` |
| Total Solutions | 92 for 8-Queens |

---

## 💡 Final Notes

This approach demonstrates how powerful non-deterministic evaluation can be:
- You don’t have to manage backtracking manually
- Just declare constraints
- Let the system explore possibilities

It's also a beautiful example of how logic programming works:
- You describe what a valid solution looks like
- The interpreter finds one automatically

This mirrors real-world logic solvers used in AI and constraint satisfaction.
