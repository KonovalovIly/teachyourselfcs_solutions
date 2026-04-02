## 🧠 Understanding the Goal

In *SICP* Section 5.5.6, you learned that instead of using variable names at runtime, we can assign each variable a **lexical address** like:

```scheme
(lexical ⟨frame-index⟩ ⟨var-index⟩)
```

To compute these during **compilation**, the compiler must track the structure of **lambda expressions** and their bound variables.

Thus, the compiler needs a **compile-time environment** — just like the evaluator uses a run-time environment.

This environment maps variable names to their **lexical addresses**.

---

## 🔁 Step-by-Step Plan

We’ll extend the compiler by:
1. Adding a new argument: `compile-time-env`
2. Passing it through all compiler functions
3. Updating it when compiling lambda bodies

This will allow us to generate lexical addresses for free variables.

---

## 🛠️ Part 1: Update the Compiler's Entry Point

Start with the main `compile` function.

Change its signature from:

```scheme
(define (compile exp target linkage)
```

To:

```scheme
(define (compile exp target linkage compile-time-env)
```

Now every call to `compile` must pass along the current compile-time environment.

Example base case:

```scheme
(compile-lambda exp target linkage (extend compile-time-env '()))
```

Where `extend` adds new frame bindings for lambda parameters.

---

## 📌 Part 2: Maintain Compile-Time Environment

Each time we enter a lambda body, we add a new frame to the compile-time environment containing its formal parameters.

Define helper functions:

```scheme
(define (empty-compile-env) '())

(define (extend-env vars vals env)
  (cons (cons vars vals) env))

(define (lookup-variable var compile-env)
  (define (env-loop env offset)
    (if (null? env)
        (error "Unbound variable" var)
        (let ((frame (car env)))
          (let ((pos (list-index var (car frame))))
            (if pos
                (make-lexical-address offset pos)
                (env-loop (cdr env) (+ offset 1))))))
  (env-loop compile-env 0))
```

Where:
- `compile-env` is a list of frames: `'(((x y z) . (arg1 arg2 arg3)) ... )`
- Each frame contains variable names and their positions

---

## 🎯 Part 3: Extend the Environment When Compiling Lambdas

Update `compile-lambda-body` to build a new compile-time environment based on the lambda’s parameters.

```scheme
(define (compile-lambda-body exp params compile-time-env)
  (let ((new-frame (map make-lexical-binding params)))
    (append-instruction-sequences
     (make-entry-labels new-frame)
     (compile-sequence (body-of exp) 'val 'return new-frame))))
```

Where:
- `params` are the lambda arguments
- We create a new frame binding them to positions 0, 1, ...
- Then compile the body in that extended environment

This ensures that:
- Variables defined in lambda scope are accessed directly
- Free variables are resolved correctly

---

## 🧮 Part 4: Modify All Compiler Functions

You must update:
- `compile`, `compile-lambda`, etc.
- To take and pass `compile-time-env` as appropriate

For example, change:

```scheme
(compile-if exp target linkage)
→ (compile-if exp target linkage compile-time-env)
```

And similarly for `compile-application`, `compile-definition`, `compile-assignment`, and so on.

This affects:
- The entire **compiler pipeline**
- Every procedure involved in code generation

But once done, the system will be able to:
- Generate **correct lexical addresses**
- Avoid unnecessary runtime lookups
- Handle **nested lambdas and closures** efficiently

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Track variable bindings at compile time |
| Strategy | Pass a compile-time environment through the compiler |
| Key Function | `lookup-variable` → returns `(lexical n m)` |
| Real-World Use | Like stack slot allocation in real compilers |
| Benefit | Faster access to local variables |
| Required Changes | Add `compile-time-env` to all compiler procedures |

---

## 💡 Final Thought

This exercise shows how to implement one of the most powerful optimizations in the compiler:
> ⚙️ **Lexical addressing** – replacing symbolic lookup with direct memory access

By passing a compile-time environment:
- You gain full control over variable scoping
- And enable efficient, safe compilation of nested procedures

It mirrors modern language design where:
- Closures are compiled into structures with known offsets
- Variable access is optimized to use stack slots or registers

Implementing this gives deep insight into how compilers manage **local state** and **free variables**.
