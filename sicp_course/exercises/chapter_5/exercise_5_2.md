## 🧠 Understanding the Register-Machine Language

The syntax used is something like:

```scheme
(define factorial-machine
  (make-machine
   '(⟨registers⟩)
   ⟨operations⟩
   '(
     ⟨controller labels and instructions⟩
     )))
```

Each instruction can be:
- `assign`, `test`, `branch`, `goto`, `save`, `restore`, `perform`

We’ll use this to implement the **iterative factorial algorithm**:

```scheme
(define (factorial n)
  (define (iter product counter)
    (if (> counter n)
        product
        (iter (* counter product) (+ counter 1))))
  (iter 1 1))
```

---

## 🔧 Step-by-Step Implementation

### 1. **Define Registers**

We need these registers:
- `n`: input value
- `product`: accumulates result
- `counter`: counts up from 1
- `temp`: temporary storage for multiplication and addition
- `one`: constant register with value 1
- No stack needed (since it's iterative)

### 2. **Define Operations**

We'll use basic arithmetic operations:

```scheme
(list (list '> >)
      (list '* *)
      (list '+ +))
```

And assume we have primitive support for `>` and `*` in the machine.

---

## ✅ Final Machine Definition

Here’s how you'd define the complete machine:

```scheme
(define factorial-machine
  (make-machine
   '(n product counter temp one)
   (list (list '> >)
         (list '* *)
         (list '+ +))
   '(
     (assign one (const 1)) ; Set one = 1
     (assign product (reg one)) ; product = 1
     (assign counter (reg one)) ; counter = 1

     test-counter
     (test (op >) (reg counter) (reg n))
     (branch (label fact-done))

     ;; body of loop
     (assign temp (op *) (reg counter) (reg product)) ; temp = counter × product
     (assign product (reg temp)) ; product = temp
     (assign counter (op +) (reg counter) (reg one)) ; counter += 1
     (goto (label test-counter))

     fact-done
     )))

;; To simulate:
(set-register-contents! factorial-machine 'n 6)
(start factorial-machine)
(get-register-contents factorial-machine 'product)
→ 720
```

---

## 📋 Controller Instructions Explained

| Label | Instruction | Description |
|-------|-------------|-------------|
| Start | `(assign one (const 1))` | Initialize constants |
|       | `(assign product ...)` | Initialize product |
|       | `(assign counter ...)` | Initialize counter |
| Loop | `(test (> counter n))` | Check if done |
|       | Branch to `fact-done` if true |
| Body | Multiply `counter × product → temp` | Update product |
|       | Increment `counter` by 1 |
| Done | Exit and return `product` |

This matches the behavior of the iterative Scheme version exactly.

---

## 🎯 Example Run: Compute 6!

Set `n = 6` before running:

```scheme
(set-register-contents! factorial-machine 'n 6)
(start factorial-machine)
(get-register-contents factorial-machine 'product)
→ 720
```

Which is indeed `6! = 720`

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Implement iterative factorial as a register machine |
| Strategy | Use `assign`, `test`, `branch`, `goto` |
| Registers Used | `n`, `product`, `counter`, `temp`, `one` |
| Stack Needed? | ❌ No — it’s an iterative process |
| Key Operations | `*`, `+`, `>` |
| Result | Returns correct factorial via iteration |
| Real-World Use | Simulates low-level computation of functional algorithms |

---

## 💡 Final Thought

This exercise gives hands-on experience writing **low-level control logic** for a high-level algorithm.

It shows how even simple functions like `factorial` become complex when broken into individual register steps.

By defining a full **register machine**, you gain insight into:
- How interpreters and compilers work internally
- How variables are managed in real machines
- How conditionals, loops, and arithmetic translate to microcode

It's a great step toward understanding how programs execute at the **machine level**.
