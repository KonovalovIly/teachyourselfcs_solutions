## 🧠 Understanding the Fibonacci Register Machine

Here is the original **Fibonacci machine controller**:

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
 (assign a (reg val)) ; save result of fib(n-1)

 ;; Recursive call to fib(n-2)
 (restore n)          ; restore original n
 (restore continue)   ; restore return label
 (save a)             ; save a before next recursive call
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

fib-done
 )
```

This machine computes `fib(n)` recursively using a stack.

But Ben notices something: there's a `save n` and `save continue` before the first recursive call, and then later we do `restore n`, `restore continue`, and **then immediately push `a` again**

That seems redundant!

---

## 🔍 Where Are the Redundant Instructions?

Let’s walk through the execution for `n = 3`:

### Initial Setup

```scheme
(set-register-contents! fib-machine 'n 3)
(start fib-machine)
```

#### Step-by-step Controller Flow

| Step | Action | Registers | Stack |
|------|--------|-----------|-------|
| 1 | Enter `fib-loop` with `n=3` | `n=3`, `continue=fib-done` | – |
| 2 | Save `continue` and `n` | `n=3`, `continue=after-fib-n-1` | `[n=3] [continue=fib-done]` |
| 3 | Decrement `n` → `n=2` | `n=2` | `[n=3] [continue=fib-done]` |
| 4 | Goto `fib-loop` again | `n=2` ≥ 2 → recurse again | More pushes... |

Eventually, when returning from `fib(n-1)`:

| Step | Action | Registers | Stack |
|------|--------|-----------|-------|
| ... | ... | ... | ... |
| x | Restore `n`, `continue` | `n=2`, `continue=after-fib-n-1` | `[a=1] [n=3] [continue=fib-done]` |
| y | Save `a` | `a=val` | `[a=1] [n=3] [continue=fib-done]` |
| z | Call `fib(n-2)` | `n=n-2=1` | Push new values |

So here’s what happens:
- After restoring `n` and `continue` at `after-fib-n-1`
- We immediately **push `a`** onto the stack
- Then go back into `fib-loop` to compute `fib(n-2)`

Ben says:
> ❗ There's an unnecessary pair of `restore` and `save` around this point

Let’s find them.

---

## 🔁 The Unnecessary `restore` / `save` Pair

At **`after-fib-n-1`**, we have:

```scheme
after-fib-n-1
 (assign a (reg val)) ; store fib(n-1)
 (restore n)
 (restore continue)
 (save a)
 (assign continue (label after-fib-n-2))
 (assign n (op -) (reg n) (const 2))
 (goto (label fib-loop))
```

The issue is here:
- You just restored `n` and `continue`
- But then you immediately do:

```scheme
(save a)
```

Then later in `after-fib-n-2`:

```scheme
after-fib-n-2
 (assign b (reg val))
 (assign val (op +) (reg a) (reg b))
 (goto (reg continue))
```

### 💡 Why It’s Inefficient

The two instructions:

```scheme
(restore n)
(save a)
```

Are effectively doing:
- Popping `n` off the stack
- Then pushing `a` on instead

So you're:
- Removing `n` from the top of the stack
- Replacing it with `a`

These steps can be combined.

---

## ✅ Optimized Version

We can remove the `restore n` and `restore continue` right after `after-fib-n-1`, and use a single `pop`/`push` step.

Here’s the **optimized controller**:

```scheme
after-fib-n-1
 (assign a (reg val))
 (save a) ; ← Keep this
 (assign continue (label after-fib-n-2))
 (assign n (op -) (reg n) (const 2))
 (goto (label fib-loop))
```

### 📌 Changes Made

| Original | Optimized |
|----------|------------|
| `restore n`<br>`restore continue`<br>`save a` | Combine into a single `save a`<br>before calling second branch |

Now:
- We don't need to restore `n` and `continue` just to overwrite them
- Instead, keep `a` on the stack and proceed directly to `fib(n-2)`
- This avoids one `restore` and one `save`

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Optimize the Fibonacci machine |
| Problem | Extra `restore` and `save` instructions |
| Fix | Replace the pair with a direct `save a` |
| Benefit | Fewer stack operations → faster execution |
| Real-World Analogy | Like optimizing tail calls or removing useless pushes in assembly |

---

## 💡 Final Thought

This exercise shows how even small changes in **stack usage** can improve performance in low-level systems like interpreters and compilers.

By observing the flow of data and control:
- Ben finds a redundancy
- And removes it by restructuring the order of stack access

This mirrors real-world compiler optimizations:
- Common subexpression elimination
- Dead code removal
- Tail call optimization

And highlights how understanding **control flow** and **stack behavior** leads to better-performing machines.
