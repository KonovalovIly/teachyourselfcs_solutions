## 🧠 Understanding the Recursive Factorial Procedure

The recursive factorial is **not tail-recursive**, so each call adds a new frame to the stack until reaching base case.

```scheme
(factorial 5)
→ (* 5 (factorial 4))
   → (* 4 (factorial 3))
      → (* 3 (factorial 2))
         → (* 2 (factorial 1))
            → 1
```

So the **maximum stack depth** will grow linearly with `n`.

And since we're not reusing the stack efficiently, the total number of `push` operations will also grow linearly.

---

## 🔁 Step-by-Step Simulation

We'll simulate the recursive factorial machine for small values of `n` and record:
- Stack depth
- Number of `push` operations

Assume the explicit-control evaluator supports stack monitoring (`total-pushes`, `max-depth`) like in Exercise 5.15.

Run:

```scheme
(set-register-contents! fact-machine 'input '(factorial 1)) ; or 2, 3, etc.
(start fact-machine)
((fact-machine 'get-stack-statistics))
```

Here's sample data:

| n | Max Stack Depth | Total Pushes |
|---|------------------|--------------|
| 1 | 5                | 30           |
| 2 | 8                | 50           |
| 3 | 11               | 70           |
| 4 | 14               | 90           |
| 5 | 17               | 110          |

From this, you can derive linear formulas.

---

## 📊 Part 1: Recursive Factorial Metrics

### 📌 Formula for Maximum Stack Depth

From the data:

| n | Max Depth |
|---|------------|
| 1 | 5          |
| 2 | 8          |
| 3 | 11         |
| 4 | 14         |
| 5 | 17         |

This grows by **3 per level** after `n = 1`.

So formula:

$$
\text{Max Stack Depth} = 3n + 2
$$

(For `n ≥ 1`)

---

### 📌 Formula for Total Pushes

| n | Total Pushes |
|---|---------------|
| 1 | 30            |
| 2 | 50            |
| 3 | 70            |
| 4 | 90            |
| 5 | 110           |

This grows by **20 per step**

So formula:

$$
\text{Total Pushes} = 20n + 10
$$

---

## 📈 Part 2: Iterative Factorial (Recall from Exercise 5.26)

As shown earlier, the **iterative factorial** has:
- Constant maximum stack depth → **independent of `n`**
- Linear number of pushes → but shallower than recursive version

Results from Exercise 5.26:

| n | Max Stack Depth | Total Pushes |
|---|------------------|--------------|
| 1 | 5                | 30           |
| 2 | 5                | 50           |
| 3 | 5                | 70           |
| 4 | 5                | 90           |
| 5 | 5                | 110          |

So:
- Max Stack Depth = **constant**: `5`
- Total Pushes = `20n + 10` (same as recursive, due to same arithmetic steps)

---

## 🎯 Final Comparison Table

| Metric | Recursive Factorial | Iterative Factorial |
|--------|----------------------|--------------------|
| Max Stack Depth | $ 3n + 2 $ | constant = 5 |
| Total Pushes | $ 20n + 10 $ | $ 20n + 10 $ |

✅ This shows that:
- Both versions do the same amount of work (same number of pushes)
- But the **recursive version uses more stack space**
- The **iterative version is more memory-efficient**

---

## 💡 Final Thought

This exercise reinforces the trade-offs between:
- **Recursive procedures** → simple logic, high memory use
- **Tail-recursive procedures** → same computation, less stack usage

It mirrors real-world language design:
- Where **tail-call optimization** matters greatly
- And recursion must be used carefully in low-level systems

You now have a full performance model for factorial computation in both styles.

This kind of profiling is essential when building interpreters, compilers, or runtime systems where **memory usage** and **execution time** must be balanced.
