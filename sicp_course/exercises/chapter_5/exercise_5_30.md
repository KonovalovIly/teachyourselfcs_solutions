## 🧠 Understanding the Problem

The explicit-control evaluator currently has only minimal error handling:
- Unknown expression types
- Unknown procedures

But other errors — like:

```scheme
(car 'a)
(/ 1 0)
```

Cause crashes in the simulator → like real machines crashing on invalid operations.

We want to make the evaluator **resilient**:
- Intercept these errors before they reach Scheme
- Return control to the evaluator
- Print a meaningful message
- Continue in the read-eval-print loop

This requires modifying:
- The way primitive operations are called
- How variables are looked up
- And adding error-handling logic in the controller

---

# ✅ Part (a): Handle Unbound Variables Gracefully

In the current setup, looking up an unbound variable calls:

```scheme
(lookup-variable-value var env)
→ if not found, returns '*unassigned*
→ which then gets used as a value → crash
```

We’ll change this so that:
- If a variable is unbound → return a special code: `'unbound`
- The evaluator checks for this code and routes to `signal-error`

---

## 🔁 Step-by-Step Plan

### 1. **Modify `lookup-variable-value` Primitive**

Update the primitive operation list to include a version of lookup that returns a special value:

```scheme
(list 'lookup-variable-value
      (lambda (var env)
        (let ((binding (env-lookup var env)))
          (if binding
              (binding-value binding)
              'unbound))) ; distinguish unbound from all others
```

Now any use of an unbound variable will result in `'unbound`, not a crash.

---

### 2. **Change Controller to Check for Unbound**

In places where variables are evaluated, check the result:

```scheme
(assign val (op eval-variable) (reg exp) (reg env))
(test (op eq?) (reg val) (const unbound))
(branch (label unbound-variable))
```

Then define:

```scheme
unbound-variable
  (assign val (const "Unbound variable"))
  (goto (label signal-error))
```

This gives you graceful handling of:

```scheme
(define x y) ; y is unbound
```

---

## 📌 Part (b): Robust Error Checking for Primitives

This part is trickier:
> ❗ You must intercept **errors raised by primitive operations** like `car`, `+`, `/`, etc.

In most cases, primitives assume their inputs are valid:
- `car` assumes argument is a pair
- `/` assumes denominator ≠ 0

But now we'll wrap each primitive with a **safety wrapper** that returns:
- A normal value, or
- A special **condition code**, e.g., `'bad-car'`, `'division-by-zero'`

---

## 🔁 Step-by-Step Plan

### 1. **Wrap Primitive Operations to Return Special Codes**

Define a wrapper function that safely applies a primitive and checks input validity:

```scheme
(define (safe-primitive-wrapper proc name)
  (lambda args
    (cond
     ((eq? name 'car)
      (if (pair? (car args))
          (caar args)
          'bad-car))

     ((eq? name 'cdr)
      (if (pair? (car args))
          (cdar args)
          'bad-cdr))

     ((eq? name '/)
      (if (= (cadr args) 0)
          'division-by-zero
          (/ (car args) (cadr args))))

     (else (apply proc args)))))
```

Use it when defining primitives:

```scheme
(list 'car (safe-primitive-wrapper car 'car))
(list 'cdr (safe-primitive-wrapper cdr 'cdr))
(list '/ (safe-primitive-wrapper / '/))
(list '+ (safe-primitive-wrapper + '+))
```

---

### 2. **Update Controller to Handle These Errors**

Wherever you call a primitive, test the result:

```scheme
(assign val (op car) (reg arg1))
(test (op eq?) (reg val) (const bad-car))
(branch (label bad-car-handler))
```

Add handlers for each kind of error:

```scheme
bad-car-handler
  (assign val (const "Bad CAR: expected a pair"))
  (goto (label signal-error))

division-by-zero-handler
  (assign val (const "Division by zero"))
  (goto (label signal-error))
```

---

### 3. **Centralized Signal-Error Label**

Define one label for all errors:

```scheme
signal-error
  (perform (op print-error-message) (reg val))
  (goto (label read-eval-print-loop))
```

And define `print-error-message` as a primitive operation:

```scheme
(list 'print-error-message
      (lambda (msg)
        (display "ERROR: ")
        (display msg)
        (newline)))
```

---

## 🎯 Example: Catching Bad `car`

Evaluate:

```scheme
(car 'not-a-pair)
```

Controller flow:

1. Evaluate `'not-a-pair` → returns symbol
2. Apply `car` → wrapped primitive detects not a pair
3. Returns `'bad-car'
4. Controller sees `'bad-car'` → branches to handler
5. Prints error and returns to top-level loop

✅ No crash!

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Add robust error handling to evaluator |
| Strategy | Return special codes instead of crashing |
| Key Change | Wrap primitives and variable lookups |
| Error Labels | `unbound-variable`, `bad-car`, etc. |
| Central Handler | `signal-error` → prints and resumes |
| Real-World Use | Like exception handling in interpreters |

---

## 💡 Final Thought

This exercise shows how to build **defensive systems** into low-level evaluators.

By wrapping primitives and extending the environment lookup:
- You gain full control over evaluation
- You avoid crashes due to malformed input
- You provide useful feedback to users

It's a major step toward building a **real-world interpreter** that can gracefully handle user mistakes.

This mirrors modern language design:
- Where runtime errors are caught and handled
- Not left to crash the entire process

And prepares you for writing **full error-reporting systems** in future exercises.
