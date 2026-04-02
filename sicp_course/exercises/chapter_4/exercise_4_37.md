## 🧠 Understanding Both Approaches

Let’s compare the two versions:

### ✳️ **Original Version (from Exercise 4.35)**

```scheme
(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
    (let ((j (an-integer-between i high)))
      (let ((k (an-integer-between j high)))
        (require (= (+ (* i i) (* j j)) (* k k)))
        (list i j k)))))
```

This tries all combinations `(i, j, k)` where `low ≤ i ≤ j ≤ k ≤ high`, and only returns a triple if it satisfies $ i^2 + j^2 = k^2 $

✅ Works correctly
❌ Inefficient: Tries many invalid values of `k` before finding a match

---

### ✅ Ben’s Proposed Version

```scheme
(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high))
        (hsq (* high high)))
    (let ((j (an-integer-between i high)))
      (let ((ksq (+ (* i i) (* j j))))
        (require (>= hsq ksq))
        (let ((k (sqrt ksq)))
          (require (integer? k))
          (list i j k))))))
```

Here's how this works:

1. Picks an `i` between `low` and `high`
2. Picks a `j` between `i` and `high`
3. Computes $ k^2 = i^2 + j^2 $
4. Checks if $ k^2 \leq high^2 $ → ensures `k` is within bounds
5. Computes $ k = \sqrt{k^2} $
6. Requires that `k` is an integer
7. Returns `(i j k)`

---

## 🔍 Why This Is More Efficient

| Feature | Original Method | Ben’s Method |
|--------|------------------|--------------|
| How `k` is chosen | Brute-force over possible `k` values | Computed from `i` and `j` |
| Number of choices per triple | Many — must try many `k`s | Only one — compute directly |
| Constraint checking | Must check equality after choosing `k` | Check early via `require (<= k high)` |
| Avoids unnecessary backtracking | ❌ No | ✅ Yes |
| Reduces search space | ❌ No | ✅ Yes |

Ben’s approach avoids searching through all possible `k` values.
Instead, he computes $ k^2 = i^2 + j^2 $, and checks:
- That $ k \leq high $ (via `require (>= hsq ksq)`)
- That $ k $ is an integer

So for each pair `(i j)`, we compute `k` directly — and **only test it once**, instead of trying many values of `k`.

This dramatically reduces the number of possibilities explored by the `amb` evaluator.

---

## 📊 Performance Comparison

Suppose we're searching for triples in range `[1, 20]`.

### Original Version

For each `(i, j)`:
- Try `k` from `j` to `20`
- For each `k`, compute $ i^2 + j^2 $?= k^2 $

This leads to:
- O(N³) complexity
- Lots of failed branches and backtracking

### Ben’s Version

For each `(i, j)`:
- Compute $ k^2 = i^2 + j^2 $
- Check $ k \leq high $
- Check if `k` is an integer

Only one value of `k` is tested per `(i, j)`.

So time complexity is roughly:
- O(N²), since `k` is computed directly
- No wasted backtracking on `k`

✅ **Conclusion**:
> Ben is correct — his version is **significantly more efficient**, especially as the range increases.

---

## 🧪 Example Evaluation

Try both methods with:

```scheme
(a-pythagorean-triple-between 1 20)
```

You'll get valid triples like:

```
(3 4 5)
(5 12 13)
(6 8 10)
(7 24 25) ← out of range if high < 25
(9 12 15)
(12 16 20)
```

But Ben’s version finds them much faster because:
- It doesn’t explore large numbers unnecessarily
- It avoids redundant `k` choices

---

## 📈 Efficiency Gains

| Measure | Original | Ben’s Version |
|--------|----------|----------------|
| Search Space | O(N³) | O(N²) |
| Backtracking | High | Low |
| Branching Factor | Large (`k` tries many values) | Small (`k` is computed) |
| Practical Use | Slower, less scalable | Faster, better for larger ranges |

---

## 💡 Final Thought

This exercise shows how **constraint-based generation** can improve performance in non-deterministic programming.

Instead of blindly exploring all combinations, Ben uses math:
- He derives `k` from `i` and `j`
- Then tests only that `k` is valid

This is a great example of:
- **Constraint satisfaction**
- **Optimization in logic programming**
- **Reduction of branching factor**

It also demonstrates why even in a system like `amb`, **search strategy matters**.
