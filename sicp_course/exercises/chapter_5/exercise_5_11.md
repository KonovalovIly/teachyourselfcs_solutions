## 🧠 Understanding the Problem

In the current simulator (as described in Section 5.2), the stack is a flat list of values saved by `save`.

Each `save` pushes a value onto the stack.

Each `restore` pops the top value and puts it into the named register.

This means:

```scheme
(save y)
(save x)
(restore y) ; gets x's last value — not y’s!
```

This behavior can lead to bugs if you're not careful with your order of `save`s and `restore`s.

Let’s explore the implications of this and the alternatives.

---

# ✅ Part (a): Use Current Behavior to Optimize Fibonacci Machine

Current behavior:
> ✅ `(restore y)` simply pops the most recent value off the stack — no matter which register it came from.

### 🔁 Original Fibonacci Machine (Section 5.1.4)

```scheme
(controller
 (assign continue (label fib-done))
 fib-loop
 (test (op <) (reg n) (const 2))
 (branch (label immediate-answer))

 ;; Recursive call to fib(n-1)
 (save continue)
 (save n)
 (assign continue (label after-fib-n-1))
 (assign n (op -) (reg n) (const 1))
 (goto (label fib-loop))

after-fib-n-1
 (restore n)
 (restore continue)
 (save a) ; save result of fib(n-1)
 (assign continue (label after-fib-n-2))
 (assign n (op -) (reg n) (const 2))
 (goto (label fib-loop))

after-fib-n-2
 (assign b (reg val))
 (assign val (op +) (reg a) (reg b))
 (goto (reg continue))

immediate-answer
 (assign val (reg n))
 (goto (reg continue))

fib-done)
```

### 💡 Optimization Insight

Ben Bitdiddle observes:
> The first `restore n` and `restore continue` in `after-fib-n-1` pop the last two items on the stack — which were pushed by `save n` and `save continue` in `fib-loop`.

But then we do:

```scheme
(save a)
```

So the stack looks like this at `after-fib-n-1`:

```
Stack before restore:
[ a ] [ n ] [ continue ]
→ restore n → restores a
→ restore continue → restores n
→ save a → pushes a again
```

So the sequence effectively does:
- Pop `a` and assign to `n`
- Pop `n` and assign to `continue`
- Push `a` back onto the stack

So instead of restoring and saving again, we could **just swap registers**.

### ✅ Optimized Version

Replace:

```scheme
after-fib-n-1
  (assign a (reg val)) ; Save result of fib(n-1)
  (restore n)
  (restore continue)
  (save a)
```

With:

```scheme
after-fib-n-1
  (restore n)
  (restore continue)
  (assign a (reg val)) ; Just store fib(n-1) result
```

Why does this work?

Because:
- Stack has `[val] [n] [continue]` pushed earlier
- We restore `n` and `continue` (which were originally `n` and `continue`)
- Then compute `a = val` directly — no need to `save a` and `restore` it later

✅ This eliminates one instruction (`save a`) — a small but valid optimization!

---

# ✅ Part (b): Modify Simulator So You Can Only Restore Values Saved from That Register

Now we want:

> ❗ A `restore` should fail unless the value being popped was originally saved **from that same register**

To do this:
- Each `save` must push both the **register name** and its value
- Each `restore` checks that the top item was saved from the same register

---

## 🛠️ Step-by-Step Implementation

### 1. **Modify `save` and `restore` Instructions**

Change how `save` works:

```scheme
(define (make-save inst machine labels operations)
  (let ((reg-name (stack-inst-reg-name inst)))
    (lambda ()
      (push (get-register machine reg-name)
            reg-name)))) ; Also store register name

(define (make-restore inst machine labels operations)
  (let ((reg-name (stack-inst-reg-name inst)))
    (lambda ()
      (let-values ((value name (pop))
        (if (eq? name reg-name)
            (set-register-contents! machine reg-name value)
            (error "Restore from wrong register" inst)))))
```

Where `push` and `pop` now track both value and register name.

---

### 2. **Example Usage**

```scheme
(save x)
(save y)
(restore x) ; ❌ Error: Top value was saved from y
```

This enforces:
- `restore` only works on values saved **from the same register**

---

## 📊 Summary Table (Part b)

| Feature | Description |
|--------|-------------|
| Goal | Prevent accidental restoration from wrong register |
| Strategy | Store register name with saved value |
| Change Needed | Modify `save` and `restore` to track origin |
| Real-World Analogy | Like type-safe memory access |

---

# ✅ Part (c): Allow Restoring Old Values Even If Other Registers Were Saved After

Now we want:

> ✅ `restore x` always returns the **last value saved from `x`**, even if other registers were saved afterward

This requires:
- A **separate stack per register**
- Instead of a global stack

---

## 🛠️ Implementation Plan

### 1. **Change Stack Structure**

Instead of a single stack:

```scheme
(define stack '()) ; Global stack
```

Use a map from register names to stacks:

```scheme
(define register-stacks (make-hash-table)) ; e.g., '((x . (3 2 1)) (y . (4 5)))
```

### 2. **Update `save` and `restore`**

```scheme
(define (save reg-name)
  (hash-update! register-stacks reg-name (cons (get-register reg-name) _)))

(define (restore reg-name)
  (let ((stack (hash-ref register-stacks reg-name '())))
    (if (null? stack)
        (error "Stack underflow on restore")
        (begin
          (set-register reg-name (car stack))
          (hash-set! register-stacks reg-name (cdr stack)))))
```

Now:
- Saving and restoring are **independent per register**
- No interference between registers

---

## 📊 Summary Table (Part c)

| Feature | Description |
|--------|-------------|
| Goal | Allow `restore` to find old values even after other saves |
| Strategy | One stack per register |
| Changes Needed | Entire stack system must be redesigned |
| Real-World Analogy | Like local variable history in a debugger |
| Benefit | More predictable control flow when multiple registers used |

---

## 📋 Final Summary Table

| Behavior | Description | Stack Type | Safety | Flexibility |
|----------|-------------|------------|--------|--------------|
| (a) Default | Any value can be restored to any register | Global stack | ❌ Low | ✅ High |
| (b) Match Reg Name | Only restore values saved from that register | Global stack | ✅ Medium | ❌ Less flexible |
| (c) Per-Register Stacks | Restore from specific register history | Separate stack per register | ✅ High | ⚠️ Complex |

---

## 💡 Final Thought

This exercise shows how subtle design decisions affect **control flow and correctness** in low-level systems.

By exploring:
- Flat stacks
- Labeled stacks
- Per-register stacks

You gain insight into:
- How real CPUs manage register state
- How assemblers and compilers handle stack discipline
- How to enforce safety while maintaining flexibility

It also demonstrates why high-level languages have scope and typing rules — they prevent these kinds of silent logic errors.
