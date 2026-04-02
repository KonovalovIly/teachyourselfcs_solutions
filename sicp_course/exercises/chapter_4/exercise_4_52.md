## 🔧 Step-by-Step Implementation

We’ll implement this in the context of the **amb evaluator** from *SICP* Section 4.3.

### 1. **Define Syntax Predicates**

```scheme
(define (if-fail? exp) (tagged-list? exp 'if-fail))

(define (if-fail-success-expr exp) (cadr exp))
(define (if-fail-failure-expr exp) (caddr exp))
```

Where:

```scheme
(define (tagged-list? exp tag)
  (and (pair? exp) (eq? (car exp) tag)))
```

---

### 2. **Modify Evaluator to Handle `if-fail`**

Update your main `eval` function with:

```scheme
((if-fail? exp)
 (analyze-if-fail exp env))

(define (analyze-if-fail exp env)
  (let ((success-expr (if-fail-success-expr exp))
        (failure-expr (if-fail-failure-expr exp)))
    (lambda (env succeed fail)
      (define (fail-branch)
        ((analyze failure-expr env) env succeed fail))
      ((analyze success-expr env)
       env
       succeed
       fail-branch))))
```

This means:
- Try evaluating `success-expr`
- If it succeeds, use `succeed` to return the result
- If it fails, fall back to evaluating `failure-expr`

You can also write it more simply as:

```scheme
(define (eval-if-fail exp env)
  (let ((result (eval (if-fail-success-expr exp) env)))
    result
    ;; If we reach here, success-expr succeeded
    (eval (if-fail-failure-expr exp) env))) ; else, try failure branch
```

But the version using `succeed/fail` ensures proper integration with `amb`'s **non-deterministic control flow**.

---

## 🧪 Example Usage

### Example 1: Failing Case

```scheme
(if-fail
 (let ((x (an-element-of '(1 3 5))))
   (require (even? x))
   x)
 'all-odd)
→ 'all-odd
```

Explanation:
- `(an-element-of '(1 3 5))` tries 1, 3, 5 — all odd
- `(require (even? x))` fails for all of them
- So `if-fail` returns `'all-odd`

---

### Example 2: Successful Case

```scheme
(if-fail
 (let ((x (an-element-of '(1 3 5 8))))
   (require (even? x))
   x)
 'all-odd)
→ 8
```

Explanation:
- `x` can be 1, 3, 5, or 8
- Only 8 is even → so only that path succeeds
- So `if-fail` returns `8`, not `'all-odd`

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Catch failures in non-deterministic evaluation |
| Behavior | Evaluate expression; if no result, return fallback |
| Real-World Use | Default values, error handling, debugging |
| Core Idea | Like exception handling in logic programming |
| Comparison to `try-again` | `if-fail` handles total failure; `try-again` explores other branches |

---

## 💡 Final Thought

This exercise shows how to **extend the power of logic-based evaluation** by adding constructs for **failure recovery**.

By implementing `if-fail`, you gain tools to:
- Provide default behavior
- Log failed attempts
- Control exploration space
- Build robust non-deterministic programs

It’s a powerful step toward building full **logic engines** like Prolog.
