## 🧠 Understanding the Problem

In the `amb` evaluator:
- When you use `(set! ...)`, and then backtrack via `try-again`, the old value of the variable is restored.
- This is because the evaluator uses a **snapshot mechanism** to roll back assignments when exploring alternative paths.

But sometimes you want an assignment to **persist across backtracking**, like counting how many trials it took to find a valid result.

That’s where `permanent-set!` comes in:
> It modifies a variable **permanently**, even if the current path fails and the evaluator backtracks.

This is useful for things like:
- Logging
- Counting attempts
- Accumulating results

---

## 🔧 Step-by-Step Implementation of `permanent-set!`

We’ll implement `permanent-set!` as a special form in the evaluator.

### 1. **Define Syntax Predicates**

```scheme
(define (permanent-set!? exp)
  (tagged-list? exp 'permanent-set!))

(define (permanent-set!-var exp) (cadr exp))
(define (permanent-set!-val exp) (caddr exp))
```

Where:

```scheme
(define (tagged-list? exp tag)
  (and (pair? exp) (eq? (car exp) tag)))
```

---

### 2. **Implement Permanent Assignment**

We modify the evaluator to support this new form.

Here’s how `eval` should handle it:

```scheme
((permanent-set!? exp)
 (eval-permanent-set! exp env))

(define (eval-permanent-set! exp env)
  (let ((var (permanent-set!-var exp))
        (val (eval (permanent-set!-val exp env)))
    (set-variable-value! var val env)
    val))
```

Where:
- `set-variable-value!` updates the binding in the environment
- No need to save/restore — it's permanent!

---

## 🧪 Example: Counting Trials

Let’s run the example from the exercise:

```scheme
(define count 0)

(define (try)
  (let ((x (an-element-of '(a b c)))
        (y (an-element-of '(a b c))))
    (permanent-set! count (+ count 1))
    (require (not (eq? x y)))
    (list x y count)))
```

Now evaluate:

```scheme
(try)
→ (a b 1)

try-again
→ (a c 2)

try-again
→ (b a 3)

try-again
→ (b c 4)

try-again
→ (c a 5)

try-again
→ (c b 6)
```

Each time, `count` increases by 1 — and never resets.

---

## ❌ What Happens If You Use `set!` Instead?

If we rewrite the code using `set!`:

```scheme
(define count 0)

(define (try)
  (let ((x (an-element-of '(a b c)))
        (y (an-element-of '(a b c))))
    (set! count (+ count 1))
    (require (not (eq? x y)))
    (list x y count)))
```

Now, each time backtracking occurs:
- The `set!` on `count` will be **undone**
- So `count` stays at `1` every time

Thus:

```scheme
(try)
→ (a b 1)

try-again
→ (a c 1)

try-again
→ (b a 1)

try-again
→ (b c 1)
```

And so on.

✅ **Conclusion**:
- With `set!`: `count` doesn't increase between failed branches
- With `permanent-set!`: `count` reflects total number of attempted combinations

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Define a version of `set!` that persists after backtracking |
| Key Idea | Modify the environment directly, don’t push onto undo stack |
| Behavior of `permanent-set!` | Value remains changed even after failure |
| Behavior of `set!` | Value is rolled back after backtracking |
| Use Case | Logging, counting, profiling |

---

## 💡 Final Notes

This exercise shows how to extend the `amb` evaluator to support **side effects that survive backtracking**.

It also highlights one of the key challenges in logic programming:
> ⚠️ How to manage **state** and **mutation** in systems that support **non-determinism and backtracking**

With `permanent-set!`, you can:
- Build **random test generators**
- Profile **search performance**
- Log **backtracking behavior**

This mirrors features found in real-world logic languages like Prolog, which have both:
- Backtrackable state
- Global state (via `assert/retract` or other primitives)

---

## ✅ Final Thought

Using `permanent-set!` lets you build richer non-deterministic programs that track progress, generate unique values, or collect results across multiple branches.

This is especially useful for:
- Generating random test cases
- Exploring search space efficiency
- Debugging complex logic puzzles

You now have the tools to build more expressive logic-based programs.
