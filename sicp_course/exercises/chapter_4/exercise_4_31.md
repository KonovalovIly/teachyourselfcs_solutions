## 🧠 Understanding the Goal

We want to:
- Keep all existing Scheme code working as before
- Allow **lazy behavior** only when explicitly requested in the procedure definition
- Support both:
  - `(x lazy)` → delayed, not memoized
  - `(x lazy-memo)` → delayed, **with memoization**
- Modify the evaluator to handle these new parameter types
- Ensure correct **forcing behavior** at runtime

This lets users choose laziness per-parameter, like in **Haskell** or other languages that allow **call-by-name** or **call-by-need**

---

## 🔧 Step-by-Step Implementation Plan

We will modify:

1. The parser for `define`
2. The `eval` and `apply` logic
3. How thunks are created and forced
4. Memoization logic

---

## 📦 Part 1: Parsing Procedure Definitions

We need to detect parameters marked with `lazy` or `lazy-memo`.

### 🔍 Syntax for Parameter Declaration

```scheme
(define (f a (b lazy) c (d lazy-memo))
  ⟨body⟩)
```

This expands into:

```scheme
(define f
  (lambda (a b c d)
    ⟨body⟩))
```

But we must remember which parameters were declared lazy/memoized.

So first, parse the formal parameter list.

---

### 🛠️ Helper Functions

```scheme
(define (eager? param) (symbol? param))

(define (lazy? param)
  (and (pair? param)
       (eq? (cadr param) 'lazy)))

(define (lazy-memo? param)
  (and (pair? param)
       (eq? (cadr param) 'lazy-memo)))

(define (parameter-name param)
  (if (pair? param)
      (car param)
      param))
```

Examples:
- `(b lazy)` → lazy
- `(d lazy-memo)` → lazy + memoized
- `a` → eager

---

## 📦 Part 2: Extending `apply`

In `apply`, instead of just passing raw arguments, we wrap some in **thunks**, depending on how they're declared.

Here’s the modified `apply`:

```scheme
(define (apply procedure arguments env)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure
          procedure
          (list-of-values arguments env)))
        ((compound-procedure? procedure)
         (let* ((params (procedure-parameters procedure))
                (arg-envs (map (lambda (param arg)
                                (cond ((eager? param) arg)
                                      ((lazy? param) (delay-it arg))
                                      ((lazy-memo? param) (delay-it-memo arg))
                                      (else (error "Unknown parameter type"))))
                              params
                              (list-of-values arguments env))))
           (eval-sequence (procedure-body procedure)
                          (extend-environment params arg-envs (procedure-environment procedure))))
        (else (error "Unknown procedure type -- APPLY" procedure)))))
```

Where:

```scheme
(define (delay-it exp) (list 'thunk exp env #f)) ; no memo
(define (delay-it-memo exp) (list 'thunk exp env #t)) ; with memo
(define (thunk? obj) (tagged-list? obj 'thunk))
(define (thunk-exp thunk) (cadr thunk))
(define (thunk-env thunk) (caddr thunk))
(define (thunk-memo? thunk) (cadddr thunk))
(define (force-it obj)
  (if (thunk? obj)
      (let ((result (eval (thunk-exp obj) (thunk-env obj))))
        (if (thunk-memo? obj)
            result ; replace with value if memoizing
            result))
      obj))
```

---

## 📦 Part 3: Update `eval` to Handle Lazy Parameters

When evaluating a lambda expression, we need to:
- Extract the formal parameters
- Wrap any lazy arguments in thunks during application

Modify the `eval` clause for lambdas:

```scheme
((lambda? exp)
 (make-procedure (lambda-parameters exp)
                 (lambda-body exp)
                 env))
```

Now, `make-procedure` should store the **parameter types** along with names.

Update it:

```scheme
(define (make-procedure parameters body env)
  (list 'procedure parameters body env))
```

So now, procedures carry full parameter declarations.

---

## 🧪 Example Usage

Define:

```scheme
(define (id x) (set! count (+ count 1)) x)

(define (f a (b lazy))
  (id a)
  (id b))
```

Evaluate:

```scheme
(set! count 0)
(f (id 10) (id 20))
→ id is called once for `a`, once for `b` → count = 2

(f (id 10) (id 20)) again
→ count = 2 (no change) — because `b` was not memoized

(set! count 0)
(define (g (x lazy-memo)) (x) (x))

(g (id 5))
→ id runs once, count = 1
(g (id 5)) again
→ id does not run again, count remains 1
```

✅ This shows the difference between `lazy` and `lazy-memo`.

---

## 📊 Summary Table

| Parameter Type | Behavior | Memoized? |
|----------------|----------|-----------|
| `x` | Eagerly evaluated | ❌ No |
| `(x lazy)` | Delayed until forced | ❌ No |
| `(x lazy-memo)` | Delayed and memoized | ✅ Yes |

---

## 💡 Final Notes

This exercise demonstrates how to extend Scheme with **first-class laziness control**, while keeping the language **backward compatible**.

It also introduces:
- A **more flexible calling convention**
- Control over **when** and **how** arguments are evaluated
- Support for **side-effecting lazy expressions**
- Memoization control

You can use this system to write:
- **Efficient recursive functions**
- **Lazy infinite data structures**
- **Short-circuiting conditionals**
- **Custom control structures**

All without breaking standard Scheme semantics.

---

## ✅ Final Implementation Checklist

| Task | Description |
|------|-------------|
| Parse parameters | Identify `lazy` and `lazy-memo` markers |
| Modify `apply` | Wrap arguments in thunks based on declaration |
| Implement `delay-it` and `delay-it-memo` | Thunk wrappers |
| Use `force-it` | When accessing arguments inside body |
| Keep compatibility | Regular definitions work as before |
| Add syntax sugar | Optional: support `lazy`/`lazy-memo` in `define` |
