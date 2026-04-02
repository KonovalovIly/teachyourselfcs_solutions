## 🧠 Understanding the `expand` Procedure

This function models **long division in arbitrary base (`radix`)**.

It produces a stream where each element is a **digit in the expansion of `num/den` in base `radix`**.

### 🔁 How It Works

At each step:
1. Multiply numerator by `radix`: `(* num radix)`
2. Divide by denominator:
   - Quotient → next digit
   - Remainder → new numerator for the next recursive call

So, this simulates the process of computing the decimal (or base-anything) expansion of a fraction.

---

## ✏️ Step-by-Step: `(expand 1 7 10)`

We're computing the decimal expansion of **1/7** in base 10.

Let’s simulate:

| Step | num | den | radix | (* num radix) | quotient | remainder |
|------|-----|-----|--------|----------------|----------|-----------|
| 1    | 1   | 7   | 10     | 10             | 1        | 3         |
| 2    | 3   | 7   | 10     | 30             | 4        | 2         |
| 3    | 2   | 7   | 10     | 20             | 2        | 6         |
| 4    | 6   | 7   | 10     | 60             | 8        | 4         |
| 5    | 4   | 7   | 10     | 40             | 5        | 5         |
| 6    | 5   | 7   | 10     | 50             | 7        | 1         |
| 7    | 1   | 7   | 10     | ...            | 1        | 3         | ← repeats!

So the digits produced are:

```
1 → 4 → 2 → 8 → 5 → 7 → 1 → 4 → 2 → ...
```

That is:

```scheme
(stream-ref s 0) ; ⇒ 1
(stream-ref s 1) ; ⇒ 4
(stream-ref s 2) ; ⇒ 2
(stream-ref s 3) ; ⇒ 8
(stream-ref s 4) ; ⇒ 5
(stream-ref s 5) ; ⇒ 7
(stream-ref s 6) ; ⇒ 1  ← repeat starts here
```

### ✅ Result:
The stream `(expand 1 7 10)` produces the repeating decimal expansion of `1/7`:

```
1/7 = 0.142857142857...
→ Stream: 1, 4, 2, 8, 5, 7, 1, 4, 2, 8, 5, 7, ...
```

---

## ✏️ Step-by-Step: `(expand 3 8 10)`

Now we compute the decimal expansion of **3/8**.

| Step | num | den | radix | (* num radix) | quotient | remainder |
|------|-----|-----|--------|----------------|----------|-----------|
| 1    | 3   | 8   | 10     | 30             | 3        | 6         |
| 2    | 6   | 8   | 10     | 60             | 7        | 4         |
| 3    | 4   | 8   | 10     | 40             | 5        | 0         |
| 4    | 0   | 8   | 10     | 0              | 0        | 0         |
| 5    | 0   | 8   | 10     | 0              | 0        | 0         |

From now on, all remainders are zero.

### ✅ Result:

The stream `(expand 3 8 10)` gives:

```
(stream-ref s 0) ; ⇒ 3
(stream-ref s 1) ; ⇒ 7
(stream-ref s 2) ; ⇒ 5
(stream-ref s 3) ; ⇒ 0
(stream-ref s 4) ; ⇒ 0
(stream-ref s 5) ; ⇒ 0
...
```

So:

```
3/8 = 0.375
→ Stream: 3, 7, 5, 0, 0, 0, 0, ...
```

---

## ✅ Summary

| Input | Fraction | Decimal Expansion | Stream Output |
|-------|----------|------------------|----------------|
| `(expand 1 7 10)` | 1/7 = 0.(142857) | Repeating decimals | 1, 4, 2, 8, 5, 7, 1, 4, ... |
| `(expand 3 8 10)` | 3/8 = 0.375 | Terminating | 3, 7, 5, 0, 0, 0, ... |

---

## 💡 Final Notes

This procedure shows how to model **infinite streams** that represent **rational numbers**, and even capture **repeating patterns** like in long division.

You could generalize this to other bases:

- `(expand 1 7 2)` would give binary expansion of 1/7
- `(expand 1 3 10)` would give the repeating stream `3, 3, 3, 3, ...` for 1/3
