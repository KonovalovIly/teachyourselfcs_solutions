## 🧠 Understanding the Current Behavior

Currently, when you define a machine:

```scheme
(define fib-machine
  (make-machine
   '(n val continue)
   (list (list '< <) (list '- -) (list '+ +))
   '(
     (assign continue (label fib-done))
     fib-loop
     (test (op <) (reg n) (const 2))
     (branch (label immediate-answer))

     (save continue)
     (save n)
     (assign n (op -) (reg n) (const 1))
     (goto (label fib-loop))

     ...)))
```

You must list all registers: `'n`, `'val`, `'continue`
→ This can be **error-prone** and **verbose**

We want to eliminate that requirement.

---

## 🔁 Step-by-Step Plan

### Goal:
Make `make-machine` accept just:

```scheme
(make-machine operations controller)
```

And automatically detect and create registers as they appear in controller instructions.

---

## 🛠️ Part 1: Parse Controller Instructions to Collect Register Names

We’ll modify the **assembler** to collect register names from expressions like:

- `(reg ⟨name⟩)`
- `(assign ⟨name⟩ ...)`
- `(save ⟨name⟩)`
- `(restore ⟨name⟩)`
- `(goto (reg ⟨name⟩))`

These tell us which registers are used.

We'll write a procedure `find-registers-in-controller` that traverses the controller instructions and collects all register names.

---

### Helper: Extract Registers from Expressions

Define helper functions:

```scheme
(define (extract-reg-names exp)
  (cond ((not (pair? exp)) '())
        ((eq? (car exp) 'reg)
         (cons (cadr exp) '()))
        ((eq? (car exp) 'assign)
         (let ((reg (cadr exp)))
           (cons reg (extract-reg-names (caddr exp))))
        ((memq (car exp) '(save restore))
         (list (cadr exp)))
        ((eq? (car exp) 'goto)
         (if (label-exp? (cadr exp))
             '()
             (extract-reg-names (cadr exp)))) ; e.g., (goto (reg x))
        (else
         (apply append (map extract-reg-names exp)))))
```

This recursively extracts all register names used in an expression.

---

### Use It in Assembler

Now we update `extract-labels` or wherever controller instructions are processed:

```scheme
(define (assemble controller machine)
  (define (process insts labels)
    (for-each
     (lambda (inst)
       (let ((regs-used (extract-reg-names inst)))
         (for-each (lambda (r) (allocate-register machine r)) regs-used)))
     insts)
  ...)
```

Where `allocate-register` adds a new register to the machine if not already present.

---

## 📌 Part 2: Automatically Allocate Registers

We modify `make-machine` to build its own register set.

Here's the original structure:

```scheme
(define (make-machine register-names ops controller)
  (let ((machine (make-base-machine register-names ops controller)))
    ...
    ))
```

Now redefine it to:

```scheme
(define (make-machine ops controller-text)
  (let ((controller (assemble controller-text)))
    (let ((register-names (collect-registers controller)))
      (make-base-machine register-names ops controller))))
```

Where `collect-registers` scans the controller instructions for all register references.

---

### Implement `collect-registers`

```scheme
(define (collect-registers controller)
  (define (scan insts seen)
    (if (null? insts)
        (reverse seen)
        (let ((new-regs (extract-reg-names (car insts))))
          (scan (cdr insts)
                (fold-right (lambda (r s)
                              (if (member r s) s (cons r s)))
                            seen
                            new-regs))))
  (scan controller '()))
```

This builds a list of all registers referenced in the controller.

---

## 🧪 Example: Fibonacci Machine Without Explicit Registers

Original call:

```scheme
(define fib-machine
  (make-machine
   '(n val continue)
   (list (list '< <) (list '- -) (list '+ +))
   fib-controller))
```

New version:

```scheme
(define fib-machine
  (make-machine
   (list (list '< <) (list '- -) (list '+ +))
   fib-controller))
```

The machine will now **automatically detect**:
- `n`
- `val`
- `continue`
- Any other registers used in the controller

And allocate them **on the fly** during assembly.

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Detect register usage automatically |
| Strategy | Scan controller for `(reg x)` expressions |
| Key Procedure | `extract-reg-names`, `collect-registers` |
| Benefit | Cleaner interface; fewer errors |
| Real-World Analogy | Like automatic variable declaration in scripting languages |

---

## 💡 Final Thought

This exercise shows how to **remove redundancy** from low-level system definitions.

By scanning controller instructions for register usage:
- You avoid manual specification
- You reduce risk of mismatched register lists
- You make the system more robust

This mirrors modern language design:
- Where variables don't need to be declared
- And types are inferred automatically

It also prepares you for building **more complex simulators** where register sets may change dynamically or grow large.
