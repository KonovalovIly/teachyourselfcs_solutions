## 🧠 Understanding the Problem

We have two execution models:

| Component | Description |
|----------|-------------|
| **Evaluator** | Interprets Scheme expressions using register machine |
| **Compiler** | Compiles Scheme to efficient register-machine instructions |

Currently:
- Evaluator can call compiled procedures via a special linkage
- But **compiled code cannot call interpreted procedures**

To enable full **interoperability**, we must allow compiled code to:
1. Recognize when a procedure is an **interpreted one**
2. Jump to the evaluator’s `compound-apply` logic

This enables hybrid systems where:
- Some functions are compiled for speed
- Others are interpreted for flexibility

---

## 🔁 Step-by-Step Implementation Plan

### 1. **Add a Register to Hold Evaluator Entry Point**

In the **explicit-control evaluator**, define a new register: `compapp`, which holds the label of `compound-apply`

Add at startup:

```scheme
(assign compapp (label compound-apply))
```

Now compiled code can jump to this register to enter the evaluator.

---

### 2. **Modify `compile-procedure-call` to Handle Interpreted Procedures**

Currently, the compiler assumes all procedures are either:
- Primitive (`primitive-apply`)
- Or compiled (`compiled-procedure-entry`)

We need to extend it to recognize **interpreted procedures** as well.

#### Update the dispatch logic in `compile-proc-appl`

Change from:

```scheme
(if (eq? 'compiled (car val))
    (go-to-compiled)
    (if (eq? 'primitive (car val))
        (go-to-primitive)
        ...))
```

To:

```scheme
(cond ((eq? 'compiled (car val)) (go-to-compiled))
      ((eq? 'primitive (car val)) (go-to-primitive))
      ((eq? 'procedure (car val))  ; interpreted closure
       (go-to-interpreted))
      (else (error "Unknown procedure type")))
```

---

### 3. **Implement `go-to-interpreted` Logic**

Compiled closures look like:

```scheme
(cons 'compiled ⟨entry-point⟩ ⟨env⟩)
```

Interpreted closures look like:

```scheme
(list 'procedure ⟨params⟩ ⟨body⟩ ⟨env⟩)
```

So when calling an interpreted procedure, compiled code must:
- Place the **closure** in `proc`
- Place the **arguments** in `argl`
- Save `continue`, `env`, etc.
- Then jump to `compound-apply` via the `compapp` register

Here’s how:

```scheme
(define (compile-interpreted-application target linkage)
  (preserving '(env continue)
              (make-instruction-sequence
               '(proc argl) (list target)
               '((assign val (reg proc)) ; optional check
                 (test (op compound-procedure?) (reg proc))
                 (branch (reg compapp)) ; jump to evaluator if interpreted
                 ...))))
```

Then wrap this inside `compile-procedure-call`.

---

### 4. **Update the Controller to Allow Branching to External Code**

In the evaluator controller, ensure there's a way to return control to compiled code after interpreting a function.

The evaluator already has:

```scheme
compound-apply
  (assign unev (op procedure-body) (reg proc))
  (assign env (op extend-environment) (reg args) (reg proc))
  (assign exp (reg unev))
  (goto (label eval-sequence))
```

We need to ensure that after interpretation completes:
- It returns to the correct `continue` label
- And restores the environment properly

So we preserve `continue` and `env` before entering the evaluator.

---

## 🛠️ Full Integration into Compiler

Here’s how to update `compile-procedure-call` to support interpreted procedures.

### 📌 Sample Updated Code Snippet

```scheme
(define (compile-procedure-call proc target linkage)
  (cond ((symbol? proc)
         ;; Variable lookup – could be any kind of procedure
         (compile-variable proc target linkage))

        ((tagged-list? proc 'lambda)
         ;; Inline lambda → compile as closure
         (compile-lambda proc target linkage))

        ((application? proc)
         ;; Compound application
         (compile-application proc target linkage))

        ((eq? (car proc) 'primitive)
         ;; Open-coded primitive or general apply
         (compile-primitive-call proc target linkage))

        ((eq? (car proc) 'procedure)
         ;; Interpreted closure
         (compile-interpreted-call proc target linkage))

        (else
         (error "Unknown procedure type" proc))))

(define (compile-interpreted-call proc target linkage)
  (let ((then-linkage (if (eq? linkage 'next)
                         linkage
                         (make-label 'after-interpreted))))
    (end-with-linkage
     linkage
     (append-instruction-sequences
      (make-instruction-sequence
       '(proc argl) (list target)
       `((test (op compound-procedure?) (reg proc))
         (goto (reg compapp)))
      (make-instruction-sequence
       '() (list target)
       `((assign ,target (reg val)))))))
```

This ensures that:
- If `proc` is an interpreted closure → jump to `compound-apply` via `compapp`
- Otherwise, proceed with normal compiled dispatch

---

## 📌 Part 1: Test Setup

Compile this:

```scheme
(define (f n)
  (+ (g (- n 1)) (g (- n 2))))
```

Use `compile-and-go` to install `f` into the compiled code.

Start the evaluator manually:

```scheme
(start eceval)
```

Then define `g` interactively:

```scheme
(define (g x) (if (= x 0) 1 (* x 2)))
```

Now call:

```scheme
(f 4)
```

✅ This should work:
- Compiled `f` calls interpreted `g`
- Evaluated results passed back to compiled code
- Final result computed correctly

---

## 🎯 Part 2: Summary of Changes

| Feature | Description |
|--------|-------------|
| Goal | Allow compiled code to call interpreted procedures |
| Key Idea | Treat interpreted closures differently |
| New Register | `compapp` → points to evaluator's `compound-apply` |
| Required Change | Extend `compile-procedure-call` to detect interpreted procedures |
| Linkage Handling | Must preserve `env`, `continue`, and pass arguments |
| Real-World Use | Like mixing compiled and interpreted code in REPLs |
| Performance Cost | Higher than compiled-to-compiled calls, but flexible |

---

## 💡 Final Thought

This exercise shows how to build a **seamless bridge** between:
- **Compiled code** (fast, static, optimized)
- **Interpreted code** (flexible, dynamic)

By extending the compiler to recognize interpreted procedures:
- You enable full interoperation
- You get the best of both worlds:
  - Fast execution of known compiled code
  - Dynamic behavior for interpreted functions

It mirrors real-world systems like:
- Racket’s Chez Scheme + bytecode interpreter mix
- Java’s JIT + interpreter
- Python’s C extensions and pure Python functions

And gives deep insight into how **language runtimes** manage multiple execution models.
