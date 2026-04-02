## 🧠 Understanding the Problem

We’re to implement two versions of `expt`:

### 🔹 Recursive Version

```scheme
(define (expt b n)
  (if (= n 0)
      1
      (* b (expt b (- n 1)))))
```

This uses **recursive calls**, so we need a **stack** to manage return values and parameters.

---

### 🔹 Iterative Version

```scheme
(define (expt b n)
  (define (expt-iter counter product)
    (if (= counter 0)
        product
        (expt-iter (- counter 1) (* b product))))
  (expt-iter n 1))
```

This version is **tail-recursive**, so no stack is needed.

---

# ✅ Part (a): Recursive Exponentiation Machine

## 📌 Register Definitions

| Register | Purpose |
|---------|--------|
| `b` | Base |
| `n` | Exponent |
| `val` | Result of recursive call |
| `continue` | Stack for return address |
| `one`, `zero` | Constants used in comparison and decrement |

We also need a **stack** to support recursion.

---

## ⚙️ Controller Instructions

```scheme
expt
  (assign continue (label expt-done)) ; base case: return 1
  (goto (label expt-loop))

expt-loop
  (test (op =) (reg n) (const 0))
  (branch (label base-case))

  ;; Recursive step: compute expt(b, n - 1), then multiply by b
  (save b)
  (save n)
  (assign n (op -) (reg n) (const 1)) ; n ← n - 1
  (assign continue (label after-expt))
  (goto (label expt-loop))

after-expt
  (restore n)
  (restore b)
  (assign val (op *) (reg b) (reg val)) ; b * expt(b, n-1)
  (goto (reg continue))

base-case
  (assign val (const 1))
  (goto (reg continue))

expt-done
```

This matches the recursive behavior exactly.

Each recursive call saves `b` and `n`, decrements `n`, and multiplies the result on the way back.

---

## 📈 Data-Path Diagram (Textual Approximation)

```
Registers:
┌─────┐     ┌─────┐     ┌──────┐     ┌────────┐
│  b  │     │  n  │     │  val │     │ continue │
└─────┘     └─────┘     └──────┘     └──────────┘
              ▲             ▲
              │             │
           [decrement]   [multiply]
              │             │
              ▼             ▼
            (n - 1)     (b × val)
```

Operations:
- `=` → compare `n` with `0`
- `-` → subtract 1 from `n`
- `*` → multiply `b` and `val`
- Constants `0`, `1`

Stack:
- Used to save `b` and `n` before recursive call
- Restored after recursion returns

---

# ✅ Part (b): Iterative Exponentiation Machine

## 📌 Register Definitions

| Register | Purpose |
|---------|--------|
| `b` | Base |
| `n` | Exponent |
| `counter` | Loop variable |
| `product` | Accumulated result |
| `one`, `zero` | Constants |

No stack needed — this is **tail-recursive**

---

## ⚙️ Controller Instructions

```scheme
expt-iter-machine
  (assign counter (reg n))
  (assign product (const 1))

loop
  (test (op =) (reg counter) (const 0))
  (branch (label done))

  (assign product (op *) (reg b) (reg product))
  (assign counter (op -) (reg counter) (const 1))
  (goto (label loop))

done
  (perform (op print) (reg product))
```

This mirrors the iterative Scheme code:
- Start with `product = 1`
- Multiply `product` by `b`, `n` times
- Decrement `counter` each time

---

## 📊 Data-Path Diagram (Textual Approximation)

```
Registers:
┌──────┐     ┌────────┐     ┌──────────┐
│  b   │     │ counter │     │ product  │
└──────┘     └────────┘     └──────────┘
               ▲                ▲
               │                │
          [decrement]      [multiply by b]

Operations:
=, -, *, const 1
```

Data flows:
- `counter` starts at `n`
- Each iteration: `product = b × product`
- Then: `counter = counter - 1`
- Repeat until `counter = 0`

---

## 📌 Summary Table

| Feature | Recursive Exponentiation | Iterative Exponentiation |
|--------|--------------------------|----------------------------|
| Uses Stack? | ✅ Yes | ❌ No |
| Stack Use | Save/restore registers during recursion | Not needed |
| Registers | `b`, `n`, `val`, `continue`, constants | `b`, `n`, `counter`, `product`, constants |
| Control Flow | Goto labels, branch based on test | Simple loop with condition |
| Efficiency | Slower due to stack operations | Faster — no stack |
| Real-World Analogy | Like recursive function calls in C | Like a `for` loop in assembly |

---

## 💡 Final Thought

These two implementations show the difference between:
- **Recursive** procedures → require **stack management**
- **Iterative** procedures → can be implemented directly in registers

This distinction is critical in real-world compilers and interpreters:
- Recursive algorithms often require **call stacks**
- Iterative ones can be **optimized** into register-based loops

By defining both machines, you gain insight into how control flow and data movement work at the lowest level.
