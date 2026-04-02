## 🧠 Understanding the Problem

In *SICP* Section 4.1.6, you learned that **internal `define`s** (e.g., inside a lambda body) should be transformed into:

```scheme
(lambda ⟨vars⟩
  (let ((⟨var1⟩ '*unassigned*)
        (⟨var2⟩ '*unassigned*)
        ...)
    (set! ⟨var1⟩ ⟨val1⟩)
    (set! ⟨var2⟩ ⟨val2⟩)
    ...))
```

So instead of treating them as top-level defines:
- They’re treated more like **simultaneous recursive bindings**, using `set!` after allocation

You were asked in Exercise 4.16 to implement this transformation in the **metacircular evaluator**

Now you must do the same in the **explicit-control compiler**

---

## 🔁 Step-by-Step Plan

We’ll modify the compiler so that when it encounters a procedure body with internal `define`s:
- It transforms them into:
  - Variable declarations in lambda
  - Then `set!` assignments at the beginning of the body
- This is called **scanning out internal definitions**

Let’s define a helper function: `scan-out-defines`, which does this transformation before compilation.

---

## 🛠️ Part 1: Define `scan-out-defines`

Here’s a version of `scan-out-defines` adapted for use in the compiler pipeline:

```scheme
(define (scan-out-defines body)
  (define (collect-defines exps vars vals)
    (if (null? exps)
        (cons vars vals)
        (let ((first (car exps)))
          (if (definition? first)
              (collect-defines
               (cdr exps)
               (cons (definition-variable first) vars)
               (cons (definition-value first) vals))
              (cons (reverse vars)
                    (append (reverse vals)
                            (map scan-out-defines-body exps)))))))

  (define (scan-out-defines-body exp)
    (if (definition? exp)
        exp ; skip already handled
        (if (lambda? exp)
            (let* ((body (caddr exp))
                   (collected (collect-defines body)))
              (make-lambda (cadr exp) ; parameters
                           (append
                            (map make-let-binding (car collected))
                            (map make-set! (car collected) (cdr collected))
                            (cdr collected))))
            exp)))

  (map scan-out-defines-body body))
```

This assumes you have helpers like:

- `definition?`: checks if an expression is a `define`
- `definition-variable`: gets the variable name from a define
- `definition-value`: gets the value
- `make-lambda`, `make-let-binding`, `make-set!`: construct new Scheme expressions

The idea is:
- Convert all internal `define`s into `let` bindings followed by `set!` assignments
- These are inserted at the start of the procedure body
- Remaining expressions are kept as-is

---

## 📌 Part 2: Integrate Into Compiler

We want to apply `scan-out-defines` **before compiling** a lambda body.

Modify `compile-lambda-body` so that it applies this transformation first.

### 🔁 Original Code Snippet (from Section 5.5)

```scheme
(define (compile-lambda-body exp compile-time-env)
  (let ((params (lambda-parameters exp)))
    (let ((new-env (extend compile-time-env params)))
      (compile-sequence (lambda-body exp) 'val 'return new-env))))
```

### 🛠️ Updated Version with Scanning

```scheme
(define (compile-lambda-body exp compile-time-env)
  (let ((body (lambda-body exp)))
    (let ((scanned-body (scan-out-defines body)))
      (let ((params (lambda-parameters exp)))
        (let ((new-env (extend compile-time-env params)))
          (compile-sequence scanned-body 'val 'return new-env)))))
```

Now internal `define`s are converted into simultaneous recursive bindings via `set!`.

---

## 🎯 Example: Procedure with Internal Definitions

Original code:

```scheme
(lambda (x)
  (define u (+ x 1))
  (define v (- x 1))
  (* u v))
```

After scanning out:

```scheme
(lambda (x)
  (let ((u '*unassigned*) ((v '*unassigned*))
    (set! u (+ x 1))
    (set! v (- x 1))
    (* u v)))
```

This matches the behavior described in *Section 4.1.6*

Now, when the compiler processes this:
- It treats `u` and `v` as **local variables**
- Not as global definitions
- And initializes them with `set!` after allocating space

---

## 🧪 Part 3: Compile Resulting Code

Now we compile the scanned body:

### Generated Instruction Snippet (simplified)

```scheme
(assign val (op lexical-address-lookup) (const (lexical 0 0)) (reg env)) ; get x
(assign arg1 (reg val))
(assign val (const 1))
(assign arg2 (reg val))
(assign val (op +) (reg arg1) (reg arg2))
(perform lexical-address-set! (const (lexical 0 1)) (reg val) (reg env)) ; set u

(assign val (op lexical-address-lookup) (const (lexical 0 0)) (reg env)) ; get x
(assign arg1 (reg val))
(assign val (const 1))
(assign arg2 (reg val))
(assign val (op -) (reg arg1) (reg arg2))
(perform lexical-address-set! (const (lexical 0 2)) (reg val) (reg env)) ; set v

; continue evaluating (* u v)
```

✅ So the compiled code now uses:
- Lexical addresses for local variables
- No unnecessary `define` logic
- Just standard assignment

This matches how variables should behave in **block structure**

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Handle internal `define`s like `letrec` |
| Strategy | Scan internal definitions and transform to `let` + `set!` |
| Key Function | `scan-out-defines` – converts defines to assignments |
| Integration | Apply before compiling lambda bodies |
| Real-World Use | Like transforming `letrec` into low-level initialization |
| Benefit | Avoids mutation of environment structure during execution |

---

## 💡 Final Thought

This exercise shows how to build a full **lexical scoping model** into a register-machine compiler.

By transforming internal `define`s into proper `let` and `set!` expressions:
- You ensure correct handling of **mutually recursive bindings**
- You avoid confusion between runtime and compile-time environments
- And maintain consistent semantics across interpreters and compilers

It mirrors modern language design:
- Where `letrec` and similar constructs are compiled into initialization blocks

And gives insight into how **compilers manage nested scope** and **free variables**
