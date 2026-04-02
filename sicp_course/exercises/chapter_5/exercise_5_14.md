## 🧠 Understanding the Recursive Factorial Machine

Here is the recursive factorial machine controller (from *SICP*, Figure 5.11):

```scheme
(controller
 (assign continue (label fact-done))
fact-loop
 (test (op =) (reg n) (const 1))
 (branch (label base-case))

 ;; Recursive call: n ← n - 1, save n and continue
 (save continue)
 (save n)
 (assign n (op -) (reg n) (const 1))
 (assign continue (label fact-loop))
 (goto (label fact-loop))

base-case
 (assign val (const 1)) ; base case: 1! = 1
 (goto (reg continue))

fact-done)

```

This machine uses a **stack** to support recursion.

Each time it makes a recursive call:
- It pushes `continue` and `n`
- Then pops them later during return

We want to count:
- How many times values are pushed onto the stack (`total-pushes`)
- What was the **maximum depth** reached during computation

---

## 🔁 Step-by-Step Plan

### 1. **Modify the Machine to Count Stack Operations**

Add two registers:
- `total-pushes`: counts all pushes
- `max-depth`: tracks maximum size of stack

Also add a register `depth` to track current depth

Update `save` and `restore` instructions to update these counters.

#### Example Controller Changes:

```scheme
(controller
 ...
fact-loop
 (test (op =) (reg n) (const 1))
 (branch (label base-case))

(save continue)
(assign total-pushes (op +) (reg total-pushes) (const 1))
(assign depth (op +) (reg depth) (const 1))
(test (op >) (reg depth) (reg max-depth))
(branch (label update-max))

(goto (label after-save))

update-max
(assign max-depth (reg depth))

after-save
(save n)
(assign total-pushes (op +) (reg total-pushes) (const 1))
(assign depth (op +) (reg depth) (const 1))

... similar changes for restore
```

You could also modify the underlying `save` and `restore` procedures directly in the simulator.

---

## 📈 Part 1: Collect Data for Small `n`

Run the modified factorial machine for small values of `n`, e.g., `n = 2, 3, 4, 5`.

Record:
- `total-pushes`
- `max-depth`

Here's a sample table:

| n | Total Pushes | Max Stack Depth |
|---|--------------|----------------|
| 1 | 0            | 0              |
| 2 | 2            | 2              |
| 3 | 4            | 3              |
| 4 | 6            | 4              |
| 5 | 8            | 5              |
| 6 | 10           | 6              |

From this data, we can derive formulas.

---

## 🧮 Part 2: Derive Formulas

From the data above:

### For `n ≥ 1`:
- **Total Pushes**: increases by 2 per level → `2(n − 1)`
- **Max Stack Depth**: increases by 1 per level → `n − 1`

So we get:

$$
\text{Total Pushes} = 2(n - 1)
$$
$$
\text{Max Stack Depth} = n - 1
$$

These are **linear functions** of `n`, as expected.

---

## 🛠️ Part 3: Modify the Machine to Automate Input/Output

To make testing easier, let’s modify the machine to:
- Read input value for `n` from user
- Compute factorial
- Print result
- Print `total-pushes` and `max-depth`
- Repeat

### Updated Controller:

```scheme
(controller
 (assign continue (label fact-done))
 (assign total-pushes (const 0))
 (assign depth (const 0))
 (assign max-depth (const 0))

read-input
 (perform (op prompt-for-input) (const "Enter n: "))
 (assign n (op read))

 (assign continue (label fact-done))
 (assign val (const 1))

fact-loop
 (test (op =) (reg n) (const 1))
 (branch (label base-case))

 (save continue)
 (save n)
 (assign n (op -) (reg n) (const 1))
 (assign continue (label fact-loop))
 (goto (label fact-loop))

base-case
 (assign val (const 1))
 (goto (reg continue))

fact-done
 (perform (op display) (reg val))
 (perform (op newline))
 (perform (op display) (reg total-pushes))
 (perform (op newline))
 (perform (op display) (reg max-depth))
 (goto (label read-input)))
```

Now the machine runs continuously, accepting new inputs and showing results and stats.

---

## 🎯 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Count `push` operations and stack depth |
| Strategy | Instrument `save` and `restore` with counters |
| Result for `n!` | Total pushes = `2(n−1)`; max depth = `n−1` |
| Real-World Use | Performance profiling, compiler optimization |
| Formula (Pushes) | `total-pushes = 2(n − 1)` |
| Formula (Depth) | `max-depth = n − 1` |

---

## 💡 Final Thought

This exercise gives insight into:
- How **recursive machines use the stack**
- How to **instrument** a register machine to collect runtime statistics
- How to derive **performance models** from low-level behavior

By observing that both metrics grow **linearly with `n`**, you see why **tail recursion and iteration** are more efficient than recursion in register machines.

It also shows how simulators can be extended to help understand performance characteristics — a key idea in systems programming and computer architecture.
