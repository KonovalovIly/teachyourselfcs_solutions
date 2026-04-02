## 🧠 Understanding the Non-Deterministic Evaluator

In this exercise, we're using the **amb evaluator**, which allows for **search with backtracking**.

Key constructs:
- `(an-integer-between low high)` → returns some integer in range `[low, high]`, trying values in order
- `(require ⟨condition⟩)` → fails if condition is false, forcing backtracking

The goal is to find **all valid Pythagorean triples** within a given range.

---

## 🔧 Step-by-Step Implementation

### 1. **Define `an-integer-between`**

This is like a bounded version of `an-integer-starting-from`, but only up to `high`.

```scheme
(define (an-integer-between low high)
  (define (loop n)
    (if (> n high)
        (amb)
        (amb n (loop (+ n 1)))))
  (loop low))
```

#### 💡 How It Works

- Uses `amb` to choose a value from `low` to `high`
- If the current choice leads to failure (e.g., no triple found), it backtracks and tries the next one

---

### 2. **Implement `a-pythagorean-triple-between`**

Now define the main function:

```scheme
(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
    (let ((j (an-integer-between i high)))
      (let ((k (an-integer-between j high)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))
```

This code uses nested `let`s to:
- Choose `i` from `[low, high]`
- Then choose `j` from `[i, high]` (ensures `i ≤ j`)
- Then choose `k` from `[j, high]` (ensures `j ≤ k`)
- Finally, require that $ i^2 + j^2 = k^2 $

If not satisfied, `require` causes backtracking.

---

## 📦 Example Usage

Run:

```scheme
(a-pythagorean-triple-between 1 20)
```

You should get triples like:

```
(3 4 5)
(5 12 13)
(6 8 10)
(7 24 25) ← out of range if high < 24
(9 12 15)
(12 16 20)
...
```

Each time you ask for another result (using `try-again`), the evaluator backtracks and finds the **next valid triple**.

---

## 🎯 Sample Session

```scheme
;;; L-Eval input:
(a-pythagorean-triple-between 1 20)
;;; L-Eval value:
(3 4 5)

;;; L-Eval input:
try-again
;;; L-Eval value:
(5 12 13)

;;; L-Eval input:
try-again
;;; L-Eval value:
(6 8 10)

;;; L-Eval input:
try-again
;;; L-Eval value:
(9 12 15)

;;; L-Eval input:
try-again
;;; L-Eval value:
(12 16 20)

;;; L-Eval input:
try-again
;;; No more values
```

---

## 🧮 Summary

| Feature | Description |
|--------|-------------|
| Goal | Generate Pythagorean triples using non-determinism |
| Strategy | Use `amb` to try all combinations |
| Key Procedure | `an-integer-between` generates integers lazily |
| Core Logic | Nested `let`s ensure increasing values |
| Constraint | Require $ i^2 + j^2 = k^2 $ |
| Backtracking | Enabled via `amb` — automatically retries other values |

---

## 💡 Final Notes

This exercise shows how powerful **non-deterministic evaluation** can be:
- You don’t have to manually iterate over combinations
- Just declare constraints, and let the evaluator explore possibilities

It's an elegant example of **constraint-based programming**, where you specify what you want, not how to compute it.

This approach scales well to other problems like:
- Solving logic puzzles
- Generating permutations or combinations
- Solving Sudoku or N-Queens

All you need is a good set of constraints and a smart search strategy.
