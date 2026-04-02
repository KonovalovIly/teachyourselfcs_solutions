## 🧠 Understanding the Stream-Based Fibonacci Definition

Here's the standard stream-based definition of the Fibonacci numbers:

```scheme
(define fibs
  (stream-cons 0
               (stream-cons 1
                            (add-streams (stream-cdr fibs)
                                         fibs))))
```

This is equivalent to:
- `fibs = 0, 1, 1, 2, 3, 5, 8, ...`
- Each term after the first two is the sum of the previous two.

So:

```scheme
fibs[0] = 0
fibs[1] = 1
fibs[n] = fibs[n-1] + fibs[n-2]
```

The key part is this line:

```scheme
(add-streams (stream-cdr fibs) fibs)
```

Which means: add the stream starting at `fibs[1]` with the full `fibs` stream.

This builds the Fibonacci sequence lazily and efficiently using **streams**.

---

## 🔢 Counting Additions

Let’s define `A(n)` as the number of additions needed to compute `fibs[n]`.

We’ll assume we have a helper function like this:

```scheme
(define (fib n)
  (stream-ref fibs n))
```

Now let’s analyze how many additions are done to compute `fibs[n]`.

### Step-by-step additions:

| n | fibs[n]        | Computed As          | Additions |
|---|----------------|----------------------|-----------|
| 0 | 0              | Given                | 0         |
| 1 | 1              | Given                | 0         |
| 2 | 1              | 1 + 0                | 1         |
| 3 | 2              | 1 + 1                | 1 (from 1+1) + 1 = 2 |
| 4 | 3              | 2 + 1                | 1 (from 2+1) + 2 = 3 |
| 5 | 5              | 3 + 2                | 1 (from 3+2) + 3 = 4 |
| 6 | 8              | 5 + 3                | 1 + A(5) = 5         |

You can see a pattern forming:

```
A(n) = A(n-1) + A(n-2) + 1
```

With base cases:
- `A(0) = A(1) = 0`

This recurrence is very similar to the Fibonacci sequence itself!

---

## 📈 Growth of Additions

From the recurrence:

```
A(n) = A(n-1) + A(n-2) + 1
```

Let’s look at the values:

| n | fibs[n] | A(n) |
|----|---------|------|
| 0  | 0       | 0    |
| 1  | 1       | 0    |
| 2  | 1       | 1    |
| 3  | 2       | 2    |
| 4  | 3       | 4    |
| 5  | 5       | 7    |
| 6  | 8       | 12   |
| 7  | 13      | 20   |
| 8  | 21      | 33   |
| 9  | 34      | 54   |
|10  | 55      | 88   |

You can see the number of additions grows roughly proportional to `fibs[n]`.

In fact:

> **A(n) ≈ fibs[n+1] - 1**

So the number of additions is linear in the value of the nth Fibonacci number.

✅ **Conclusion**: With memoized `delay`, the number of additions is **linear** in the size of the result.

---

## ❌ Without Memoization: Exponential Cost

Now suppose we implement `delay` naively as:

```scheme
(define (delay exp) (lambda () exp))
```

That is, **no memoization** — every time you call `force`, you re-evaluate the expression.

Then, each time you access a stream element, it recomputes everything from scratch.

So, evaluating `fibs[n]` becomes like a tree of recomputations.

This leads to **exponential behavior**, just like the naive recursive version of `fib`.

### ⚖️ Comparison

| Approach            | Time Complexity | Explanation |
|---------------------|------------------|-------------|
| Naive Recursive     | O(Fib(n))        | Like tree recursion; exponential |
| Stream (no memo)    | O(Fib(n))        | Recomputes streams each time |
| Stream (with memo)  | O(n)             | Each addition is computed once |

Without memoization, `stream-cdr` reevaluates its argument every time, and thus all prior additions are redone.

This makes `fibs[n]` cost about as much as the **naive recursive `fib(n)`**, which takes `Fib(n)` steps.

---

## ✅ Summary

| Concept | Description |
|--------|-------------|
| Goal | Count additions in stream-based Fibonacci |
| Key Idea | Each term is built from earlier terms via one addition |
| Additions Count | A(n) = A(n−1) + A(n−2) + 1 |
| With Memoization | Number of additions = O(n) |
| Without Memoization | Each `stream-cdr` recomputes entire stream ⇒ O(Fib(n)) additions |
| Lesson | Lazy evaluation only helps if it avoids recomputation! |

---

## 💡 Final Thought

This exercise illustrates the **importance of memoization** in lazy evaluation systems.

Without it, even seemingly efficient stream-based programs can degenerate into exponential-time algorithms.
