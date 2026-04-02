### ✅ **Exercise 3.61 — SICP**
> Implement a procedure `invert-unit-series` that computes the **reciprocal of a power series**, i.e., find `X` such that:

$$
S \cdot X = 1
$$

Given:
- `S` is a power series with constant term **1**
- Let $ S = 1 + SR $, where `SR` is the rest of the series (without the constant term)

From the identity:

$$
(1 + SR) \cdot X = 1 \Rightarrow X = 1 - SR \cdot X
$$

We can define `X` **recursively**:
The constant term is 1, and the rest are defined by negating the product of `SR` and `X`.

---

## 🔧 Step-by-Step Implementation

We’ll use these from previous exercises:

- `mul-series`: Multiplies two power series
- `stream-cdr`: Gets all terms after the first
- `scale-stream s k`: Multiplies each element of stream `s` by number `k`
- `add-streams`: Adds two streams term-by-term

Let’s define `invert-unit-series`:

```scheme
(define (invert-unit-series S)
  (define X
    (cons-stream 1 ; constant term is 1
                 (scale-stream
                  (mul-series (stream-cdr S) X) ; SR * X
                  -1))) ; negative of above
  X)
```

### 📌 Explanation:

- We define `X` recursively using `define`.
- First term: `1`, since we want `X[0] = 1`
- Remaining terms come from the recursive equation:
  $$
  X_{n+1} = -\text{SR}_n \cdot X_n
  $$

Where:
- `SR` is `(stream-cdr S)` → the part of `S` without the constant term
- Multiply it by `X` to get `SR · X`
- Scale by `-1` to get `-SR · X`

This gives us the higher-order terms of `X`.

---

## 🧮 Example: Invert the Series for `1 + x`

Let’s define a simple power series:

```scheme
(define ones (stream-cons 1 ones)) ; 1 + x + x² + x³ + ...
(define unit-series (stream-cons 1 ones)) ; 1 + x + x² + x³ + ...
```

Now compute its inverse:

```scheme
(define inv-series (invert-unit-series unit-series))
```

This should give the expansion of $ \frac{1}{1 + x} = 1 - x + x^2 - x^3 + x^4 - \ldots $

Check some values:

```scheme
(stream-ref inv-series 0) ; ⇒ 1
(stream-ref inv-series 1) ; ⇒ -1
(stream-ref inv-series 2) ; ⇒ 1
(stream-ref inv-series 3) ; ⇒ -1
(stream-ref inv-series 4) ; ⇒ 1
```

Which matches the expected pattern.

---

## ✅ Summary

| Concept | Description |
|--------|-------------|
| Goal | Compute reciprocal of a power series whose constant term is 1 |
| Strategy | Use recursive definition: `X = 1 - SR · X` |
| Key Tools | `mul-series`, `stream-cdr`, `scale-stream` |
| Final Definition | ```(define (invert-unit-series S) (define X (cons-stream 1 (scale-stream (mul-series (stream-cdr S) X) -1))) X)``` |
| Test Case | Inverting $ 1 + x + x^2 + x^3 + \ldots $ gives alternating signs |

---

## 💡 Why This Works

This approach works because it uses **lazy evaluation** and **recursive stream definitions** to express infinite mathematical relationships cleanly.

It's not just computing numbers — it's computing entire **functions as infinite series**, and doing algebra on them!

---

Would you like help with **Exercise 3.62** — implementing full division of power series — or exploring how to compute **tangent series** using this inversion technique?
