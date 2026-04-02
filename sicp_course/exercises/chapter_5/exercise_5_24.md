## 🧠 Understanding the Problem

Currently, `cond` is handled via **syntactic transformation**, e.g., by converting it into nested `if`s.

But now you are asked to implement it directly as a primitive form.

This requires:
- A way to parse and process `cond` expressions
- Support for evaluating clause predicates
- Support for evaluating clause actions (like `=>`, `else`)
- Integration with existing evaluator machinery like `eval-dispatch`, `apply-dispatch`, and `ev-sequence`

---

## 🔁 Step-by-Step Plan

We’ll define:

```scheme
(cond ⟨pred1⟩ ⟨action1⟩
      ⟨pred2⟩ ⟨action2⟩
      ...
      (else ⟨actionN⟩))
```

And implement support for it in the evaluator controller.

---

## 📌 Part 1: Define Register Usage

| Register | Purpose |
|--------|---------|
| `exp` | Holds the entire `cond` expression |
| `clauses` | List of `(⟨pred⟩ ⟨action⟩)` pairs |
| `clause` | Current clause being tested |
| `pred` | Predicate part of current clause |
| `actions` | Actions part of current clause |

We’ll assume we have helper operations like:

- `(op cond-clauses)`: gets the list of clauses from a `cond` expression
- `(op first-clause)`: returns the first clause
- `(op rest-clauses)`: returns remaining clauses
- `(op cond-predicate)`: gets predicate from clause
- `(op cond-actions)`: gets action list from clause
- `(op true?)`: tests if a value is not `#f`

---

## ⚙️ Part 2: Controller Instructions

Here's how to implement the `cond` logic in the evaluator:

```scheme
;; Entry point for cond expressions
ev-cond
  (assign clauses (op cond-clauses) (reg exp))

cond-loop
  (test (op null?) (reg clauses))
  (branch (label cond-false)) ; no else clause → return #f

  (assign clause (op first-clause) (reg clauses))
  (assign pred (op cond-predicate) (reg clause))
  (test (op eq?) (reg pred) (const else))
  (branch (label eval-actions))

  ;; Evaluate predicate
  (save continue)
  (save clauses)
  (assign continue (label cond-pred-result))
  (assign exp (reg pred))
  (goto (label eval-dispatch))

cond-pred-result
  (restore clauses)
  (restore continue)

  (test (op true?) (reg val)) ; val = result of predicate
  (branch (label eval-actions))

  ;; Else: go to next clause
  (assign clauses (op rest-clauses) (reg clauses))
  (goto (label cond-loop))

cond-false
  (assign val (const #f))
  (goto (reg continue))

eval-actions
  (assign actions (op cond-actions) (reg clause))
  (assign unev (reg actions))
  (assign continue (label cond-done))
  (goto (label ev-sequence))

cond-done
  (goto (reg continue))
```

---

## 🛠️ Part 3: Integrate Into Evaluator

Add to your `eval-dispatch` section:

```scheme
(test (op tagged-list?) (reg exp) (const cond))
(branch (label ev-cond))
```

Now the evaluator will recognize `cond` expressions and handle them directly, without translating to `if`.

---

## 📌 Example Evaluation

Given:

```scheme
(cond ((null? x) 'empty)
      ((pair? x) 'non-empty)
      (else 'unknown))
```

The evaluator:
1. Extracts clauses → `'(((null? x) 'empty) ((pair? x) 'non-empty) (else 'unknown))`
2. Loops through each clause:
   - Evaluates `(null? x)`
   - If true → evaluates `'empty`
   - Else → tries `(pair? x)`
3. Uses `ev-sequence` to run multiple expressions in a clause

---

## 🎯 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Implement `cond` directly in the evaluator |
| Strategy | Loop over clauses; test predicate; evaluate actions |
| Key Registers | `clauses`, `clause`, `pred`, `actions` |
| Helper Operations | `cond-clauses`, `cond-predicate`, `cond-actions` |
| Real-World Use | Like implementing control structures in interpreters |
| Benefit | More direct execution path than syntactic expansion |
| Comparison | Slower than `if` but more readable |

---

## 💡 Final Thought

This exercise shows how to add **new control structures** to a low-level evaluator.

By defining a new dispatch label (`ev-cond`) and integrating with `ev-sequence`, you:
- Gain full control over evaluation order
- Avoid syntactic transformations that can obscure program meaning

It mirrors real-world interpreter design:
- Where conditionals are implemented as core constructs
- Not just syntactic sugar on top of `if`

This gives you a deeper understanding of:
- How evaluators manage control flow
- How derived forms relate to their expanded versions
- And how to build richer languages on top of minimal cores
