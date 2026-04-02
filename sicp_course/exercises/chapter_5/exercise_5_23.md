## 🧠 Understanding Derived Expressions

In *SICP* Section 4.1.2, you learned that some special forms are implemented as **syntactic transformations** of other forms:

| Expression | Transforms To |
|------------|----------------|
| `cond`     | nested `if`s   |
| `let`      | lambda + apply |
| `begin`    | sequence of expressions |
| `and`, `or` | nested `if`s |

So instead of implementing each directly in the evaluator, we can **transform them** before evaluation.

This is the idea behind the `eval-dispatch` loop: evaluate only a small core language, and expand derived forms at **compile time** or during evaluation.

---

## 🔁 Step-by-Step Extension Plan

We’ll extend the **explicit-control evaluator** from Section 5.4 to support these derived expressions by:
- Adding new **primitive operations** for transforming them (like `cond->if`)
- Modifying the `eval-dispatch` logic to recognize and transform them
- Ensuring transformed expressions are evaluated correctly

---

## 🛠️ Part 1: Define Syntax Transformers as Machine Operations

Assume the following syntax transformation procedures are available:

```scheme
(list (list 'cond->if cond->if)
      (list 'let->combination let->combination)
      (list 'expand-clauses expand-clauses)
      ...)
```

These will be passed into the machine via the `operations` list.

Example usage in `make-machine`:

```scheme
(define eval-machine
  (make-machine
   '(exp env val continue proc argl unev)
   (list (list 'cond->if cond->if)
         (list 'let->combination let->combination)
         (list 'pair? pair?)
         (list 'car car)
         (list 'cdr cdr)
         (list 'tagged-list? tagged-list?)
         ...)
   eval-controller))
```

Now in the controller, you can call:

```scheme
(assign exp (op cond->if) (reg exp)) ; expands cond to if
(goto (label ev-application))       ; then proceed with eval
```

---

## 📌 Part 2: Modify `eval-dispatch` to Handle Derived Expressions

Recall that in the evaluator controller, you have a section like this:

```scheme
eval-dispatch
  (test (op self-evaluating?) (reg exp))
  (branch (label ev-self-eval))

  (test (op variable?) (reg exp))
  (branch (label ev-variable))

  (test (op quoted?) (reg exp))
  (branch (label ev-quoted))

  ;; Add derived expression checks here
  (test (op tagged-list?) (reg exp) (const cond))
  (branch (label ev-cond))

  (test (op tagged-list?) (reg exp) (const let))
  (branch (label ev-let))

  ;; Else fall back to core cases
  (test (op application?) (reg exp))
  (branch (label ev-application))
```

Then define labels for expanding them:

```scheme
ev-cond
  (assign exp (op cond->if) (reg exp))
  (goto (label eval-dispatch))

ev-let
  (assign exp (op let->combination) (reg exp))
  (goto (label eval-dispatch))
```

This means:
- When `eval-dispatch` sees a `cond`, it transforms it into an `if`
- Then re-enters `eval-dispatch` to evaluate the result

✅ So you don’t need to add any new instructions — just expand the input and reuse existing code.

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Support derived expressions like `cond`, `let` |
| Strategy | Use syntax transformers as primitive operations |
| Key Change | Add dispatch logic for recognizing derived expressions |
| New Controller Labels | `ev-cond`, `ev-let`, etc. |
| Real-World Use | Like preprocessing before execution |
| Benefit | Keeps core evaluator minimal while supporting richer syntax |

---

## 💡 Final Thought

This exercise shows how to build **extensible interpreters** using register machines.

By adding only a few primitives (`cond->if`, `let->combination`, etc.) and modifying the `eval-dispatch` logic:
- You gain full support for derived expressions
- Without increasing the complexity of the core evaluator

It mirrors real-world interpreters and compilers:
- Where higher-level constructs are expanded into lower-level ones
- And only a small core is implemented directly

This is the essence of **macro expansion**, **desugaring**, and **compilation pipelines**.
