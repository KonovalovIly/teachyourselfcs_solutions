## 🧠 Understanding the Goal

In *SICP* Section 5.2, machine instructions look like:

```scheme
(assign ⟨reg⟩ (op ⟨op-name⟩) ⟨arg1⟩ ⟨arg2⟩ ...)
(assign ⟨reg⟩ (reg ⟨reg-name⟩))
(goto (label ⟨label-name⟩))
(test (op ⟨op-name⟩) ⟨arg1⟩ ⟨arg2⟩ ...)
(branch (label ⟨label-name⟩))
```

This is essentially a **Lisp-style s-expression syntax** for control logic.

The idea in this exercise is to **design a different syntax**, such as:

| Feature | Original Syntax | New Syntax |
|--------|------------------|------------|
| Assign | `(assign a (op +) b c)` | `a <- (+ b c)` |
| Goto   | `(goto (label here))` | `jmp here` |
| Test   | `(test (op <) (reg n) (const 2))` | `test (< n 2)` |

Then update only the **syntax-processing procedures** (`make-operation-exp`, `make-assign`, etc.), without changing the core simulator.

---

## 🛠️ Step-by-Step Plan

We’ll define a new syntax that looks more like **pseudo-assembly**, then update the parser functions so the simulator accepts this new syntax.

### 🔁 Example: New Syntax

Here's a sample controller using our new syntax:

```scheme
(controller
 start
   a <- (* b c)
   test (= counter 0)
   jmp done
 loop
   a <- (+ a 1)
   counter <- (- counter 1)
   test (> counter 0)
   jmpz loop
 done
   halt)
```

This should be equivalent to:

```scheme
(controller
 (assign a (op *) (reg b) (reg c))
 (test (op =) (reg counter) (const 0))
 (branch (label done))
 (assign a (op +) (reg a) (const 1))
 (assign counter (op -) (reg counter) (const 1))
 (test (op >) (reg counter) (const 0))
 (branch (label loop))
 (goto (label done)))
```

Now we need to write the parser to support this new style.

---

## 📌 Part 1: Define New Instruction Syntax

### 1. **Assignments**

Instead of:

```scheme
(assign a (op +) (reg x) (const 1))
```

Use:

```scheme
a <- (+ x 1)
```

This is easier to read and write.

### 2. **Goto / Branching**

Replace:

```scheme
(goto (label loop))
(branch (label loop))
```

With:

```scheme
jmp loop
jmpt loop ; jump if true
jmpz loop ; jump if zero (like test-and-branch)
```

### 3. **Test Instructions**

Replace:

```scheme
(test (op <) (reg x) (const 5))
```

With:

```scheme
test (< x 5)
```

Or even:

```scheme
if x < 5 then ...
```

Depending on how expressive you want to be.

---

## 🧪 Sample Controller Using New Syntax

Here’s how a factorial machine might look:

```scheme
(controller
start
  a <- 1
  b <- n
loop
  test (> a b)
  jmpz done
  product <- (* product a)
  a <- (+ a 1)
  jmp loop
done
  halt)
```

This should behave exactly like the original Lisp-like syntax.

---

## 🛠️ Part 2: Modify Syntax Procedures

To support this, we'll update the **instruction parsers** in the simulator.

We’ll focus on three key parts:

### 1. **Assign Instructions**

Original:

```scheme
(assign a (op +) (reg x) (const 1))
```

New:

```scheme
a <- (+ x 1)
```

Parsing function:

```scheme
(define (assign-inst? inst)
  (and (pair? inst)
       (eq? (cadr inst) '<-)))

(define (assign-reg-name assign-inst)
  (car assign-inst))

(define (assign-value assign-inst)
  (caddr assign-inst))
```

Then process into the standard internal form used by the simulator.

---

### 2. **Test Instructions**

Original:

```scheme
(test (op =) (reg x) (const 1))
```

New:

```scheme
test (= x 1)
```

Parser:

```scheme
(define (test-inst? inst)
  (and (pair? inst)
       (eq? (car inst) 'test)))

(define (test-op test-inst)
  (cadr test-inst))

(define (test-args test-inst)
  (cddr test-inst))
```

Convert these into:

```scheme
(test (op =) (reg x) (const 1))
```

Inside the simulator.

---

### 3. **Branch Instructions**

Original:

```scheme
(branch (label loop))
```

New:

```scheme
jmp loop
```

For unconditional jumps:

```scheme
(jmp label-name)
→ (goto (label label-name))
```

Conditional branches:

```scheme
jmpt label-name
→ (branch (label label-name))
```

```scheme
jmpz label-name
→ (branch (label label-name)) after test
```

---

## 🧱 How to Translate New Syntax to Old

Each time the simulator reads an instruction, it parses its structure.

You can write a **translator function** that converts from your syntax to the old one.

Example:

```scheme
(define (translate inst)
  (cond ((assign-inst? inst)
         (let ((reg (assign-reg-name inst))
              (value (assign-value inst)))
           (if (operation-exp? value)
               (list 'assign reg (list 'op (car value)) (map translate-arg (cdr value)))
               (list 'assign reg (list 'reg (car value))))) ; or const
        ((test-inst? inst)
         (let ((op (test-op inst))
               (args (test-args inst)))
           (list 'test (cons 'op op) (map translate-arg args)))
        ((jump-inst? inst)
         (list 'goto (list 'label (jump-label inst))))
        ((conditional-jump-inst? inst)
         (list 'branch (list 'label (jump-label inst))))
        (else inst)))

(define (translate-arg arg)
  (cond ((symbol? arg) (list 'reg arg))
        ((number? arg) (list 'const arg))
        (else arg)))
```

This translates:

```scheme
a <- (+ x 1)
→ (assign a (op +) (reg x) (const 1))
```

And:

```scheme
test (< x 10)
→ (test (op <) (reg x) (const 10))
```

So you can now write full machines in the new syntax.

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Redesign instruction syntax for readability |
| Strategy | Use symbolic operators and infix-like syntax |
| Key Change | Update only syntax procedures |
| Supported Forms | Assignment, test, goto, conditional branch |
| Real-World Analogy | Like designing a domain-specific language (DSL) for assembly |

---

## 💡 Final Thought

This exercise shows how to design a **domain-specific language (DSL)** on top of a low-level system.

By writing a translator that maps from your new syntax to the original s-expressions:
- You keep the entire simulator intact
- You make programs more readable
- You avoid cluttered syntax
- You mimic real-world compilers and preprocessors

It's a great way to explore how programming languages can evolve while keeping their core engine unchanged.
