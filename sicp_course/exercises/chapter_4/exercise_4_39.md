## 🧠 Understanding the Problem

In the **non-deterministic `amb` evaluator**, the system explores possible values using **backtracking**.

The `multiple-dwelling` procedure defines five people and their floor assignments:

```scheme
(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5))
        (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5))
        (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 1)))
    (require (not (= fletcher 5)))
    (require (> miller cooper))
    (require (not (= (abs (- smith fletcher)) 1))) ; Smith not adjacent to Fletcher
    (require (distinct? (list baker cooper fletcher miller smith)))
    (list (list 'baker baker)
          (list 'cooper cooper)
          (list 'fletcher fletcher)
          (list 'miller miller)
          (list 'smith smith))))
```

This program uses `amb` to generate all possible floor assignments, then filters them with `require`.

Now we ask:

> ❓ Does changing the **order** of these `require` statements change anything?

---

## ✅ Part 1: Does Constraint Order Affect the Answer?

### 🔍 Short Answer: No

All constraints are **logical conditions** that must be satisfied for a valid assignment.

No matter the order in which you apply them, the final set of solutions will be the same.

So:

> ✅ **Constraint order does NOT affect correctness**

The program still returns the **same unique solution**:

```scheme
((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))
```

---

## ✅ Part 2: Does Constraint Order Affect Performance?

### 🔍 Short Answer: Yes — it can make a huge difference!

The `amb` evaluator explores combinations by trying values one at a time and backtracking when a `require` fails.

If you place **tight constraints early**, you **prune the search tree faster**, avoiding unnecessary exploration.

---

## 🚀 Example: Reordering Constraints for Better Performance

Here's the original order:

```scheme
(require (not (= baker 5)))
(require (not (= cooper 1)))
(require (not (= fletcher 1)))
(require (not (= fletcher 5)))
(require (> miller cooper))
(require (not (= (abs (- smith fletcher)) 1)))
(require (distinct? ...))
```

We can reorder to move **cheap and restrictive constraints first**:

```scheme
(define (multiple-dwelling-fast)
  (let ((baker (amb 1 2 3 4 5))
        (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5))
        (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    ;; Place tightest constraints first
    (require (distinct? (list baker cooper fletcher miller smith)))

    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 1)))
    (require (not (= fletcher 5)))

    (require (> miller cooper))
    (require (not (= (abs (- smith fletcher)) 1)))

    (list (list 'baker baker)
          (list 'cooper cooper)
          (list 'fletcher fletcher)
          (list 'miller miller)
          (list 'smith smith))))
```

---

## 📊 Why This Works Faster

| Constraint | Cost | Early or Late? | Reason |
|-----------|------|----------------|--------|
| `(distinct? ...)` | High | ✅ First | Prunes most branches early |
| `(not (= baker 5))` | Low | ✅ Second | Eliminates invalid Baker positions fast |
| `(> miller cooper)` | Medium | ⬆ Middle | Involves two variables; better later |
| `(not (= (abs (- smith fletcher)) 1))` | High | ⬇ Last | Involves computation and only applies after both are assigned |

By placing **expensive checks like `distinct?` early**, we eliminate many impossible assignments **early in the process**, rather than after deep recursion.

---

## 🧪 Performance Difference

To measure this, define a helper:

```scheme
(define (count-solutions proc)
  (define count 0)
  (define (try)
    (let ((result (proc)))
      (if result
          (begin (set! count (+ count 1))
                 (try))
          count)))
  (try))
```

Then compare:

```scheme
(count-solutions multiple-dwelling)       ; Original version
(count-solutions multiple-dwelling-fast)   ; Optimized version
```

You’ll find that:
- Both return **1 solution**
- But the reordered version finds it much faster

Because:
- It avoids exploring many **invalid paths**
- It **fails fast** on impossible configurations

---

## 💡 Final Thought

This exercise shows a core idea from **constraint satisfaction**:

> ⚠️ **Order of constraints matters for performance**, but not for correctness.

This is true in:
- Logic programming
- Prolog-style systems
- SAT solvers
- Search algorithms like DFS or backtracking

By ordering constraints smartly:
- You prune the search space earlier
- Avoid unnecessary work
- Improve performance significantly

This mirrors real-world applications like:
- Sudoku solvers
- Planning systems
- Combinatorial optimization

---

## ✅ Summary

| Feature | Description |
|--------|-------------|
| Goal | Explore impact of constraint order in non-deterministic programs |
| Key Insight | All valid solutions remain valid regardless of order |
| Performance Impact | Yes — reordering constraints can speed up search dramatically |
| Best Practice | Put **restrictive constraints first** |
| Optimization Strategy | Fail early, fail fast |
| Real-World Analogy | Like pruning a search tree before going too deep |
