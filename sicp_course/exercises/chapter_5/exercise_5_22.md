## 🧠 Understanding the Procedures

### 🔹 `append`

```scheme
(define (append x y)
  (if (null? x)
      y
      (cons (car x) (append (cdr x) y))))
```

This is not tail-recursive:
- It builds up cons cells on the way back from recursion
- So we’ll need a stack to manage recursive calls

---

### 🔹 `append!`

```scheme
(define (append! x y)
  (set-cdr! (last-pair x) y)
  x)

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))
```

This version modifies the original list.
- It finds the last pair in `x`
- Then uses `set-cdr!` to link it to `y`

No deep recursion → can be implemented iteratively without stack

---

# ✅ Part (a): Implementing `append` in a Register Machine

## 📌 Registers

| Register | Purpose |
|---------|----------|
| `x` | First list |
| `y` | Second list |
| `val` | Result of recursive calls |
| `continue` | Return address for recursion |
| `temp` | Temporary storage during cons |

We'll use a **stack** to support recursion.

---

## ⚙️ Controller Instructions

```scheme
(controller
start
  (assign continue (label append-done))
  (goto (label append-loop))

append-loop
  (test (op null?) (reg x))
  (branch (label base-case))

  ;; Recursive call: append (cdr x) y
  (save continue)
  (save x)
  (save y)
  (assign continue (label after-append))
  (assign x (op cdr) (reg x))
  (goto (label append-loop))

after-append
  (restore y)
  (restore x)
  (restore continue)
  (assign val (op cons) (reg (car x)) (reg val))
  (goto (reg continue))

base-case
  (assign val (reg y))
  (goto (reg continue))

append-done)
```

### 📋 How It Works:

1. If `x` is empty → return `y`
2. Else:
   - Save current `x`, `y`, `continue`
   - Recurse on `(append (cdr x) y)`
3. After recursion returns:
   - Restore `x`, take `(car x)` and build a new `cons` cell with result

This matches the recursive structure of `append`.

---

# ✅ Part (b): Implementing `append!` in a Register Machine

This version **mutates the first list**, so no need for recursion or stack.

## 📌 Registers

| Register | Purpose |
|---------|----------|
| `x` | List to modify |
| `y` | List to append |
| `current` | Used in loop to find last pair |
| `next` | Holds `(cdr current)` during iteration |
| `temp` | For temporary values |

No stack needed – it's fully **iterative**

---

## ⚙️ Controller Instructions

```scheme
(controller
start
  (assign current (reg x))

find-last
  (assign next (op cdr) (reg current))
  (test (op null?) (reg next))
  (branch (label found-last))
  (assign current (reg next))
  (goto (label find-last))

found-last
  (perform (op set-cdr!) (reg current) (reg y))
  (assign val (reg x))
  (goto (label done))

done)
```

### 📋 How It Works:

1. Start at head of `x`
2. Loop until `(null? (cdr current))`
3. When found → mutate its `cdr` to point to `y`
4. Return original `x`

This avoids any stack operations.

---

## 🎯 Example Input

### For `append`:

```scheme
(set-register-contents! machine 'x '(a b c))
(set-register-contents! machine 'y '(d e f))
(start machine)
→ (a b c d e f)
```

### For `append!`:

```scheme
(set-register-contents! machine 'x '(a b c))
(set-register-contents! machine 'y '(d e f))
(start machine)
→ (a b c d e f)
```

But now:
- Original `x` has been modified
- Its last `cdr` now points to `y`

---

## 📊 Summary Table

| Feature | `append` | `append!` |
|--------|-----------|------------|
| Uses Stack? | ✅ Yes – recursive |
| Mutates Input? | ❌ No |
| Tail-Recursive? | ❌ No – needs to build conses on return |
| Stack Usage | High – grows with depth of `x` |
| Performance | Slower due to memory allocation |
| Real-World Analogy | Like building a new list in functional code |
| `append!` Stack Use | ❌ None – iterative |
| Mutates Input | ✅ Yes |
| Tail-Recursive | ✅ Yes – just a loop |
| Performance | Faster – modifies in place |
| Real-World Analogy | Like in-place linked list splicing |

---

## 💡 Final Thought

This exercise shows how **mutation affects performance and design** in low-level systems.

By implementing both versions:
- You see how recursion requires stack management
- And how mutation allows for more efficient updates

It mirrors real-world trade-offs between:
- Functional programming (safe, but slower)
- Imperative programming (faster, but side-effecting)

And prepares you for more advanced topics like garbage collection and heap management.
