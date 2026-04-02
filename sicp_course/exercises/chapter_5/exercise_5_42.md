## 🧠 Understanding the Goal

In *Section 5.5*, you're building a compiler that generates register-machine instructions.

Currently, the compiler emits code like:

```scheme
(assign val (op lookup-variable-value) (const x) (reg env))
```

But with lexical addressing, we can compile to:

```scheme
(assign val (op lexical-address-lookup) (const (lexical 0 1)) (reg env))
```

This avoids runtime name lookup and makes compiled code faster.

We’ll modify two procedures:
- `compile-variable` – used when compiling variable references
- `compile-assignment` – used when compiling `set!` expressions

Both will use `find-variable` to determine if a variable is **local**, **free**, or **global**

---

## 🔁 Step-by-Step Plan

### 1. **Update `compile-variable`**

Change how variable references are compiled.

Old version:

```scheme
(compile-variable exp target linkage)
→ (assign val (op lookup-variable-value) (const ⟨var⟩) (reg env))
```

New version:

```scheme
(define (compile-variable exp target linkage compile-time-env)
  (let ((var (cadr exp)))
    (let ((lexaddr (find-variable var compile-time-env)))
      (if (eq? lexaddr 'not-found)
          (compile-lambda-reference var target linkage)
          (compile-lexical-reference lexaddr target linkage))))
```

Where:

```scheme
(define (compile-lexical-reference lexaddr target linkage)
  (end-with-linkage
   linkage
   (make-instruction-sequence
    '(env) (list target)
    `((assign ,target (op lexical-address-lookup) (const ,lexaddr) (reg env)))))
```

And:

```scheme
(define (compile-lambda-reference var target linkage)
  (end-with-linkage
   linkage
   (make-instruction-sequence
    '(env) (list target)
    `((assign ,target (op lookup-variable-value) (const ,var) (reg env)))))
```

Now variable access uses **lexical addresses** where possible.

---

### 2. **Update `compile-assignment`**

Similarly, change how `set!` expressions are compiled.

Old version:

```scheme
(set! x ⟨value⟩)
→ lookup x in environment
→ assign new value
```

New version:

```scheme
(define (compile-assignment exp target linkage compile-time-env)
  (let* ((var (cadr exp))
         (val-code (compile (caddr exp) 'val 'next))
         (lexaddr (find-variable var compile-time-env)))
    (preserving
     '(continue)
     val-code
     (append-instruction-sequences
      val-code
      (if (eq? lexaddr 'not-found)
          (make-instruction-sequence
           '(env val) '()
           `((perform (op set-variable-value!) (const ,var) (reg val) (reg env)))
          (make-instruction-sequence
           '(env val) '()
           `((perform (op lexical-address-set!) (const ,lexaddr) (reg val) (reg env)))))))
```

This means:
- If the variable has a known lexical address → use `lexical-address-set!`
- Else fall back to `set-variable-value!` and search run-time environment

You also have the option to look directly in the global environment using:

```scheme
(op get-global-environment)
```

So instead of searching all frames, you could optimize global variable assignments:

```scheme
(perform (op set-global-variable-value!) (const x) (reg val) (reg global-env))
```

Where `global-env` is obtained via:

```scheme
(assign global-env (op get-global-environment) (reg env))
```

---

## 📌 Part 3: Define Low-Level Operations

Define these as machine primitives:

```scheme
(list 'lexical-address-lookup
      (lambda (lexaddr env)
        (let ((frame-index (car lexaddr))
             (var-index (cdr lexaddr)))
        (lookup-lexical frame-index var-index env)))

(list 'lexical-address-set!
      (lambda (lexaddr val env)
        (let ((frame-index (car lexaddr))
             (var-index (cdr lexaddr)))
        (set-lexical! frame-index var-index val env)))

(list 'get-global-environment
      (lambda (env)
        (get-global-environment env))) ; e.g., go to outermost frame

(list 'set-global-variable-value!
      (lambda (var val global-env)
        (set-variable-value! var val global-env)))
```

These allow compiled code to access and mutate variables based on their lexical scope.

---

## 🎯 Example: Nested Lambda Combination

Given this expression:

```scheme
(lambda (x)
  (lambda (y)
    (+ x y)))
```

Compile-time environment during body of inner lambda:

```scheme
'(((y) (x) ()) ...)
```

So:
- `'x'` is at `(1 . 0)`
- `'y'` is at `(0 . 0)`

The compiler would generate:

```scheme
; load x into arg1
(assign arg1 (op lexical-address-lookup) (const (lexical 1 0)) (reg env))

; load y into arg2
(assign arg2 (op lexical-address-lookup) (const (lexical 0 0)) (reg env))

; compute x + y
(assign val (op +) (reg arg1) (reg arg2))
```

Without lexical addressing, this would require:
- Building an argument list
- Looking up `+` as a variable
- Applying it like any other function

✅ So with lexical addressing, we save multiple steps and reduce overhead

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Replace symbolic variable lookup with lexical addressing |
| Strategy | Use `find-variable` to resolve variables at compile time |
| Key Procedures Modified | `compile-variable`, `compile-assignment` |
| Fallback Mechanism | Use evaluator ops if not found in compile-time env |
| Real-World Analogy | Like stack slot allocation in compilers |
| Benefit | Faster access to local variables |

---

## 💡 Final Thought

This exercise shows how to **optimize variable access in compiled code**.

By integrating `find-variable`:
- You enable the compiler to avoid costly name-based lookups
- And replace them with fast **lexical addressing**

This mirrors real-world language design:
- Where compilers track variable scopes and generate optimized access paths
- Instead of relying on runtime symbol tables

Implementing this gives deep insight into:
- How **closures** work under the hood
- How **environments** are structured in compiled code
- And how to **integrate compile-time analysis** into low-level execution models
