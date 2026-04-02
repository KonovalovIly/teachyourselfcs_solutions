## 🧠 Understanding the Problem

In Section 5.1 of *SICP*, you built iterative and recursive versions of `factorial`. We’ll use the **recursive version** here.

Likewise, the **Fibonacci machine** is typically implemented recursively:

```scheme
(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))
```

Both machines use a **stack** to handle recursion.

Let’s define both machines in the register-machine language, then hand-simulate them with real data.

---

# ✅ Part 1: Recursive Factorial Machine

## 🔁 Machine Definition

Registers:
- `n`: current value of `n`
- `val`: result of computation
- `continue`: return address
- `temp`: temporary storage
- `one`: constant 1

Stack used to save registers before recursive calls.

Controller:
```scheme
fact
  (assign continue (label fact-done))
  (goto (label fact-loop))

fact-loop
  (test (op =) (reg n) (const 0))
  (branch (label base-case))

  ;; Recursive call setup
  (save n)
  (save continue)
  (assign continue (label after-fact))
  (assign n (op -) (reg n) (const 1))
  (goto (label fact-loop))

after-fact
  (restore continue)
  (restore n)
  (assign val (op *) (reg n) (reg val))
  (goto (reg continue))

base-case
  (assign val (const 1))
  (goto (reg continue))

fact-done
```

---

## 📌 Simulation for `(factorial 3)`

Initial state:
- `n = 3`
- `continue = fact-done`

Now trace execution:

| Step | Action | Registers | Stack |
|------|--------|-----------|-------|
| 1 | Start | `n=3`, `continue=fact-done` | Empty |
| 2 | Enter `fact-loop` | `n=3` ≠ 0 → branch not taken |  |
| 3 | Save `n` and `continue` | `n=3`, `continue=after-fact` | `[n=3] [continue=after-fact]` |
| 4 | Decrement `n` → `n=2` | `n=2`, `continue=after-fact` | `[n=3] [continue=after-fact]` |
| 5 | Goto `fact-loop` again | `n=2` ≠ 0 → recurse again |  |

Continue this process:

| Step | n | val | continue | Stack |
|------|---|-----|----------|-------|
| 1 | 3 | ? | fact-done | – |
| 2 | 3 → save | – | after-fact | push `n=3`, `continue=after-fact` |
| 3 | n ← 2 | – | after-fact | stack: `[n=3] [continue=after-fact]` |
| 4 | n=2 ≠ 0 → save | – | after-fact | stack: `[n=2] [n=3] [continue=after-fact] [continue=after-fact]` |
| 5 | n ← 1 | – | after-fact | stack grows |
| 6 | n=1 ≠ 0 → save | – | after-fact | stack: `[n=1] [n=2] [n=3] ...` |
| 7 | n ← 0 | – | after-fact | stack keeps growing |
| 8 | n=0 → base case | `val=1` | pop `continue` |
| 9 | Multiply: `1 × 1 = 1` | `val=1` | restore `n=1` |
|10 | Multiply: `1 × 2 = 2` | `val=2` | restore `n=2` |
|11 | Multiply: `2 × 3 = 6` | `val=6` | restore `n=3` |
|12 | Done | `val=6` | empty |

✅ Final result: `6`

---

# ✅ Part 2: Fibonacci Register Machine

## 🔁 Machine Definition

Registers:
- `n`: input number
- `val`: result
- `continue`: return label
- `a`, `b`: hold results of `fib(n-1)` and `fib(n-2)`
- `one`: constant 1

Controller:
```scheme
fib
  (assign continue (label fib-done))
  (goto (label fib-loop))

fib-loop
  (test (op <) (reg n) (const 2))
  (branch (label immediate-answer))

  ;; First recursive call: fib(n-1)
  (save n)
  (save continue)
  (assign continue (label after-fib-n-1))
  (assign n (op -) (reg n) (const 1))
  (goto (label fib-loop))

after-fib-n-1
  (assign a (reg val)) ; store fib(n-1)

  ;; Second recursive call: fib(n-2)
  (restore continue)
  (restore n)
  (assign continue (label after-fib-n-2))
  (assign n (op -) (reg n) (const 2))
  (goto (label fib-loop))

after-fib-n-2
  (assign b (reg val)) ; store fib(n-2)
  (assign val (op +) (reg a) (reg b)) ; fib(n) = fib(n-1) + fib(n-2)
  (goto (reg continue))

immediate-answer
  (assign val (reg n)) ; if n < 2, return n
  (goto (reg continue))

fib-done
```

---

## 📌 Simulation for `(fib 4)`

We’re computing `fib(4) = fib(3) + fib(2)`
Which leads to multiple recursive calls.

Start:
- `n = 4`
- `continue = fib-done`

Trace steps:

| Step | n | val | continue | Stack |
|------|---|-----|----------|-------|
| 1 | 4 | ? | fib-done | – |
| 2 | Test: 4 ≥ 2 → true | – | – | Push `n=4`, `continue=fib-done` |
| 3 | Assign `continue = after-fib-n-1` | – | – | Push `n=4`, `continue=after-fib-n-1` |
| 4 | n ← 3 | – | – | stack: `[n=4] [continue=after-fib-n-1]` |
| 5 | Loop again → n=3 ≥ 2 | – | – | New frame pushed |
| 6 | n ← 2 | – | – | More frames added |
| 7 | Eventually reach base case | val=1 | – | stack unwinds |
| 8 | Compute `fib(2)` = 1 | val=1 | – | – |
| 9 | Add `a = 1`, `b = 1` → val = 2 | val=2 | – | – |
|10 | Return up through stack | val=3, then 5 | stack pops values |

Final result: `fib(4) = 3`

---

## 🧪 Stack Evolution During Execution

Here's how the stack looks during the simulation:

```
Initial Call:
[ n=4 ] [ continue=fib-done ]

After first fib(3):
[ n=4 ] [ continue=after-fib-n-1 ]
[ n=3 ] [ continue=after-fib-n-1 ]
[ n=2 ] [ continue=after-fib-n-1 ]
[ n=1 ] → base case, returns 1

Stack after returning from fib(1):
→ Pop to compute fib(2), add 1+1=2

Then fib(3) computes 2+1=3

Finally, fib(4) computes 3+2=5

Result: 3
```

✅ Final result: `fib(4) = 3`

---

## 📊 Summary Table

| Feature | Recursive Factorial | Fibonacci |
|--------|---------------------|-----------|
| Uses Stack? | ✅ Yes | ✅ Yes |
| Number of Recursive Calls | n times | exponential |
| Stack Depth | Linear in n | Exponential in n |
| Registers | `n`, `val`, `continue` | `n`, `val`, `a`, `b`, `continue` |
| Performance | O(n) time | O(2ⁿ) time |
| Real-World Analogy | Like recursive function calls in C | Classic example of inefficient recursion |

---

## 💡 Final Thought

This exercise gives hands-on experience with:
- **Register machines**
- **Stack management**
- **Recursive control flow**

By simulating these machines by hand, you see how:
- Recursion builds up on the stack
- Each return must be matched with a restore
- Even simple algorithms can generate deep stacks

It also shows why **tail recursion** matters:
- In the iterative factorial, no stack needed
- But recursive algorithms require careful stack handling

These insights form the foundation for understanding:
- How compilers manage recursion
- How interpreters implement function calls
- How real CPUs use the call stack
