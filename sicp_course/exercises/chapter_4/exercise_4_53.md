## 🧠 Understanding the Components

### 🔁 `prime-sum-pair`
We assume it's defined as in earlier exercises:

```scheme
(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (prime-sum-pair list1 list2)
  (let ((a (an-element-of list1))
        (b (an-element-of list2)))
    (require (prime-sum? (list a b)))
    (list a b)))
```

This finds a pair `(a b)` such that `a + b` is prime.

---

### 🔄 `if-fail`
As implemented in Exercise 4.52, `if-fail` tries evaluating its first argument.
- If it **succeeds**, returns that result.
- If it **fails**, evaluates and returns the second argument.

---

### ⚙️ `permanent-set!`
From Exercise 4.51: behaves like `set!`, but **doesn't roll back** when backtracking.

So we can use it to accumulate values across multiple `amb` branches.

---

## 📌 Step-by-Step Evaluation

Let’s break down the full expression:

```scheme
(let ((pairs '()))
  (if-fail
   (let ((p (prime-sum-pair '(1 3 5 8) '(20 35 110)))
     (permanent-set! pairs (cons p pairs))
     (amb)) ; force backtracking
   'done)
  pairs)
```

### Step 1: Define Lists

We're trying to find all pairs between:
- List A: `(1 3 5 8)`
- List B: `(20 35 110)`

Where the sum of the pair is a **prime number**

### Step 2: Try All Combinations

The `prime-sum-pair` tries combinations `(a b)` where `a ∈ A`, `b ∈ B`

Each time a valid pair is found:
- It is added to the `pairs` list via `permanent-set!`
- Then `(amb)` forces backtracking to try other possibilities

Eventually, all valid pairs are collected into `pairs`.

When no more valid pairs exist:
- The `if-fail` clause returns `'done`
- But we return the accumulated `pairs` list instead

---

## 🧮 Find All Prime-Sum Pairs

List A: `(1 3 5 8)`
List B: `(20 35 110)`

All possible sums:

| Pair | Sum | Is Prime? |
|------|-----|-----------|
| (1, 20) | 21 | ❌ No |
| (1, 35) | 36 | ❌ No |
| (1, 110) | 111 | ❌ No |
| (3, 20) | 23 | ✅ Yes |
| (3, 35) | 38 | ❌ No |
| (3, 110) | 113 | ✅ Yes |
| (5, 20) | 25 | ❌ No |
| (5, 35) | 40 | ❌ No |
| (5, 110) | 115 | ❌ No |
| (8, 20) | 28 | ❌ No |
| (8, 35) | 43 | ✅ Yes |
| (8, 110) | 118 | ❌ No |

Valid pairs:
- `(3 20)` → 23
- `(3 110)` → 113
- `(8 35)` → 43

So:

```scheme
(prime-sum-pair '(1 3 5 8) '(20 35 110))
→ (3 20), then (3 110), then (8 35)
```

Thus, after backtracking and collecting all:

```scheme
(pairs = ((3 20) (3 110) (8 35)))
```

---

## ✅ Final Answer

Evaluating the whole expression:

```scheme
(let ((pairs '()))
  (if-fail
   (let ((p (prime-sum-pair '(1 3 5 8) '(20 35 110)))
     (permanent-set! pairs (cons p pairs))
     (amb))
   'done)
  pairs)
```

Will produce:

```scheme
((3 20) (3 110) (8 35))
```

Because:
- These are the only pairs where the sum is prime
- Each time one is found, it’s added to `pairs` with `permanent-set!`
- `(amb)` forces backtracking until all options are exhausted
- Finally, `if-fail` triggers and returns the final value of `pairs`

---

## 📊 Summary

| Feature | Description |
|--------|-------------|
| Goal | Collect all valid prime-sum pairs using `amb` |
| Tool 1 | `permanent-set!` – accumulates results |
| Tool 2 | `if-fail` – controls search and returns result |
| Valid Pairs | `(3 20)`, `(3 110)`, `(8 35)` |
| Result | ```((3 20) (3 110) (8 35))``` |
| Why This Works | `permanent-set!` persists across backtracking; `if-fail` catches total failure |

---

## 💡 Final Thought

This exercise demonstrates how powerful logic programming can be when combined with:
- **Non-deterministic search**
- **Accumulation of results**
- **Control over failure**

You’re not just finding one solution — you’re exploring **all paths**, collecting **every valid possibility**, and returning them in a list.

This mirrors real-world logic engines like Prolog, where:
- You explore all solutions
- You collect them using side effects
- You fail to continue search

And now, thanks to `permanent-set!`, even side effects survive backtracking!
