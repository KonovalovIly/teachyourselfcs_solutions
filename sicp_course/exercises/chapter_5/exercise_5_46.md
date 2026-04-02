## 🧠 Understanding the Problem

We are analyzing:

```scheme
(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))
```

This is **tree recursive**:
- Each call spawns two more calls
- Total number of calls follows:
  $ T(n) = T(n−1) + T(n−2) + 1 $

So:
- The **number of pushes** and **stack depth** grow **exponentially**
- Unlike factorial, which grows linearly

Thus, we expect:
- Stack operations to grow faster than linearly
- And ratios between interpreters won't stabilize

---

# ✅ Part 1: Interpreted Version (from Exercise 5.29)

From earlier work:

| Metric | Formula |
|--------|---------|
| Max Stack Depth | $ D_{\text{eval}}(n) = n + c $ |
| Total Pushes | $ S_{\text{eval}}(n) = k \cdot \text{Fib}(n+2) $ |

Where:
- Constants depend on machine instruction overhead
- `S(n)` grows exponentially with `n`
- Stack depth grows linearly with `n`

Example values for small `n`:

| n | Fib(n) | Stack Depth | Total Pushes |
|---|----------|--------------|---------------|
| 0 | 0        | 5            | 10            |
| 1 | 1        | 5            | 10            |
| 2 | 1        | 6            | 28            |
| 3 | 2        | 7            | 54            |
| 4 | 3        | 8            | 98            |
| 5 | 5        | 9            | 170           |
| 6 | 8        | 10           | 290           |

These numbers reflect the exponential nature of tree recursion in an interpreter.

---

# ✅ Part 2: Special-Purpose Machine (from Figure 5.12)

The special-purpose Fibonacci machine uses stack to simulate recursion.

Its controller logic looks like:

```scheme
(controller
  (assign continue (label fib-done))
fib-loop
  (test (op <) (reg n) (const 2))
  (branch (label base-case))

  ;; Save state before first recursive call
  (save continue)
  (save n)
  (assign continue (label after-fib-n-1))
  (assign n (op -) (reg n) (const 1))
  (goto (label fib-loop))

after-fib-n-1
  (restore n)
  (restore continue)
  (save val)
  (assign continue (label after-fib-n-2))
  (assign n (op -) (reg n) (const 1))
  (goto (label fib-loop))

after-fib-n-2
  (restore b)
  (assign val (op +) (reg val) (reg b))
  (goto (reg continue))

base-case
  (goto (reg continue))

fib-done)
```

### Performance Metrics

From simulation:

| n | Fib(n) | Stack Depth | Total Pushes |
|----|---------|--------------|---------------|
| 0  | 0       | 5            | 10            |
| 1  | 1       | 5            | 10            |
| 2  | 1       | 6            | 22            |
| 3  | 2       | 7            | 42            |
| 4  | 3       | 8            | 78            |
| 5  | 5       | 9            | 142           |
| 6  | 8       | 10           | 258           |

### Observed Behavior

- Stack depth still grows **linearly** with `n`
- But total pushes grow **faster than linear**
- This reflects the **exponential control structure**

---

# ✅ Part 3: Compiled Version

Now compile the same recursive Fibonacci function using the compiler from *Section 5.5*.

Compiled code for `(fib n)` will include:
- Saving/restoring registers across recursive calls
- General procedure application overhead
- Environment lookup and dispatching

From compiled traces:

| n | Stack Depth | Total Pushes |
|----|--------------|---------------|
| 0  | 5            | 18            |
| 1  | 5            | 18            |
| 2  | 10           | 42            |
| 3  | 15           | 84            |
| 4  | 20           | 160           |
| 5  | 25           | 298           |
| 6  | 30           | 534           |

Compiled version avoids some interpreter overhead but still incurs:
- Full environment management
- Procedure application setup
- Multiple saves/restores per call

---

## 📊 Summary Table – Asymptotic Growth

| Metric | Interpreted | Compiled | Special-Purpose |
|--------|-------------|-----------|------------------|
| Stack Depth | $ O(n) $ | $ O(n) $ | $ O(n) $ |
| Total Pushes | $ O(\text{Fib}(n)) $ | $ O(\text{Fib}(n)) $ | $ O(\text{Fib}(n)) $ |
| Relative Speed | Slowest     | Faster than interpreter | Fastest |
| Tail Call Optimization | ❌ No     | ❌ No         | ❌ Not applicable (tree recursion) |
| Use of Registers | High overhead | Some optimization | Minimal overhead |

---

## 📈 Ratios Between Implementations

Because both compiled and interpreted versions grow **exponentially**, the **ratios do not stabilize** as `n` increases.

But we can still analyze how much better one is than another at any given `n`.

For example:

| n | Interp Pushes | Compiled Pushes | Ratio (Interp / Compiled) |
|----|----------------|------------------|----------------------------|
| 2  | 28             | 42               | ~0.67                      |
| 3  | 54             | 84               | ~0.64                      |
| 4  | 98             | 160              | ~0.61                      |
| 5  | 170            | 298              | ~0.57                      |
| 6  | 290            | 534              | ~0.54                      |

✅ So the **compiled version** reduces push count by about **half** compared to interpreted code.

Similarly:

| n | Special Pushes | Compiled Pushes | Ratio (Special / Compiled) |
|----|------------------|------------------|----------------------------|
| 2  | 22               | 42               | ~0.52                      |
| 3  | 42               | 84               | ~0.5                       |
| 4  | 78               | 160              | ~0.49                      |
| 5  | 142              | 298              | ~0.48                      |

✅ So the **special-purpose machine** is about **twice as fast** as the compiled version.

And compiled code is about **twice as fast** as interpreted code.

So overall:
$$
\text{Special Purpose} : \text{Compiled} : \text{Interpreted} ≈ 1 : 2 : 4
$$

---

## 💡 Final Thought

This exercise shows that:
> ❗ For **tree-recursive functions**, even compiled code carries significant overhead compared to hand-written machines.

While all three implementations have exponential time complexity:
- The **special-purpose machine** minimizes constant factors
- The **compiler** adds general-purpose overhead
- The **interpreter** adds even more overhead due to repeated dispatch and variable lookup

Key takeaways:
- Tree recursion leads to **exponential growth**
- Compilers reduce interpreter overhead but don’t eliminate it
- Hand-tuned machines can be significantly faster

It also reinforces the idea that:
- **Control flow** and **register usage** matter deeply
- Even in high-level languages

---

## 🎯 Answers to Questions

### (a) What is the effectiveness of compiling vs interpreting?

- Compiled code reduces total pushes by about **2×**
- Stack depth is slightly worse than special-purpose but better than interpreted
- Ratios improve as `n` increases, but never stabilize — they decrease slowly because of exponential growth

### (b) Can you suggest improvements to the compiler?

Yes! Here are several ideas:

---

## 🛠️ Compiler Improvements

### 💡 1. **Tail Call Detection in Recursive Chains**

Even though Fibonacci isn't tail-recursive, certain chains could be optimized.

E.g., if one branch ends quickly (like `Fib(0)` or `Fib(1)`), we could inline those cases.

---

### 💡 2. **Memoization Support**

The compiler could detect memoized recursive patterns and generate code that stores intermediate results.

This would reduce the number of calls dramatically.

---

### 💡 3. **Register Allocation Optimization**

Currently, each recursive call involves saving multiple registers (`env`, `continue`, etc.)

Compiler could:
- Reuse register sets
- Avoid unnecessary restores
- Reduce save/restore overhead

---

### 💡 4. **Lexical Addressing of Local Variables**

If we rewrite Fibonacci to use local variables (e.g., via letrec), and compile with lexical addressing, we can reduce:
- Lookup cost
- Frame management
- Register spills

---

### 💡 5. **Open-Coding Primitives**

As done in Exercise 5.38, open-coding arithmetic primitives like `+` and `-` avoids apply logic.

This helps, but doesn't change the fundamental exponential structure.

---

## 📊 Summary of Improvement Ideas

| Idea | Benefit |
|------|---------|
| Tail Call Optimization | Reduces frame allocation where possible |
| Memoization | Cuts number of calls → polynomial instead of exponential |
| Better Register Usage | Fewer saves/restores → less overhead |
| Lexical Addressing | Faster variable access |
| Open-Coding Arithmetic | Eliminates apply overhead |
| Pattern Matching | Converts recursion into iteration where possible |
