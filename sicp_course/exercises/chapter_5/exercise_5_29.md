## 🧠 Understanding the Recursive Fibonacci Machine

The tree recursion in `fib` builds up a **deep and wide call tree**:

```
fib(4)
├── fib(3)
│   ├── fib(2)
│   │   ├── fib(1)
│   │   └── fib(0)
│   └── fib(1)
└── fib(2)
    ├── fib(1)
    └── fib(0)
```

Each recursive call adds a new frame to the stack, and since it's not tail-recursive, these frames are only popped after both branches return.

So:
- The **stack depth grows linearly**
- The **number of pushes grows exponentially**

This is because:
- Each non-base-case call spawns two more calls
- So the number of operations follows a **recurrence relation** like `S(n) = S(n−1) + S(n−2) + k`

Where `k` is the fixed overhead per call.

---

# ✅ Part (a): Maximum Stack Depth Formula

We want to find how deep the stack gets when computing `Fib(n)` recursively.

Each time we compute `Fib(n)`:
- We first compute `Fib(n−1)`
- Then compute `Fib(n−2)`

But each call increases the stack depth by some constant amount (e.g., saving registers, setting up environment).

So maximum stack depth is governed by:

$$
D(n) = D(n - 1) + 1 \quad \text{for } n ≥ 2
$$

Because:
- To compute `Fib(n)`, you call `Fib(n−1)` → this builds the deepest part of the stack
- Then `Fib(n−2)` is shallower
- So the max depth comes from the leftmost path: `n → n−1 → n−2 → ... → 1`

Base cases:

$$
D(0) = D(1) = \text{constant}
$$

Assume that each call adds **one level** to the stack.

Thus:

$$
\boxed{D(n) = n}
$$

Or more precisely:

$$
\boxed{D(n) = a \cdot n + b}
$$

For constants $ a = 1 $, $ b = \text{initial setup cost} $

If initial depth at `n=1` is, say, 5, then:

$$
\boxed{D(n) = n + 4}
$$

---

# ✅ Part (b): Total Number of Pushes

Let’s define $ S(n) $: the number of push operations needed to compute `Fib(n)`.

Each call to `Fib(n)` does:
- A test (`< n 2`)
- Two recursive calls: `Fib(n−1)` and `Fib(n−2)`
- An addition at the end

So the number of pushes required will satisfy:

$$
\boxed{S(n) = S(n - 1) + S(n - 2) + k}
$$

Where $ k $ is the **fixed overhead** for entering/exiting a procedure:
- Saving/restoring registers
- Setting up arguments
- Testing base case

Suppose $ k = 40 $ based on earlier exercises (e.g., Exercises 5.26–5.27), then:

| n | Fib(n) | S(n) |
|----|--------|------|
| 0  | 0      | 0    |
| 1  | 1      | 0    |
| 2  | 1      | 40   |
| 3  | 2      | 80   |
| 4  | 3      | 120  |
| 5  | 5      | 200  |
| 6  | 8      | 320  |
| 7  | 13     | 520  |
| 8  | 21     | 840  |

From this data, we can see the pattern matches the **Fibonacci sequence** itself.

---

## 🔁 Step-by-Step Derivation

Let’s define $ S(n) $ as:

$$
S(n) = S(n - 1) + S(n - 2) + k
$$

With base cases:

$$
S(0) = S(1) = 0
$$

This recurrence is very similar to the Fibonacci recurrence.

Now let’s try expressing $ S(n) $ in terms of $ \text{Fib}(n) $

Try fitting a model:

$$
S(n) = a \cdot \text{Fib}(n + 1) + b
$$

Try values:

| n | Fib(n+1) | S(n) | Try: `a * Fib(n+1) + b` |
|---|-----------|-------|--------------------------|
| 2 | 1         | 40    | $ a \cdot 1 + b = 40 $ |
| 3 | 2         | 80    | $ a \cdot 2 + b = 80 $ |

Subtracting the equations:

$$
a \cdot 2 + b = 80 \\
a \cdot 1 + b = 40 \\
\Rightarrow a = 40,\ b = 0
$$

So we get:

$$
\boxed{S(n) = 40 \cdot \text{Fib}(n + 1)}
$$

✅ This works well for all `n ≥ 2`

---

## 📊 Final Summary Table

| Metric | Formula |
|--------|---------|
| Max Stack Depth | $ D(n) = n + c $ (linear in `n`) |
| Total Pushes | $ S(n) = 40 \cdot \text{Fib}(n + 1) $ (exponential in `n`) |
| Overhead Constant | $ k = 40 $ |
| Real-World Insight | Exponential work hidden in recursive calls |
| Recurrence Relation | $ S(n) = S(n−1) + S(n−2) + k $ |

---

## 💡 Final Thought

This exercise shows how **recursive procedures** can quickly consume resources:
- Even though the **depth grows linearly**, the **work explodes exponentially**

It also shows the power of recurrence relations:
- You can predict performance using formulas tied to known sequences (like Fibonacci)

This mirrors real-world concerns:
- Where naive recursive algorithms become **too slow or memory-intensive**
- And motivate better designs using **memoization**, **iteration**, or **compiled code**

By understanding how many `push` operations occur, you gain insight into the **true cost** of recursion.
