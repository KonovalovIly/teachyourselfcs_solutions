## 🧠 Understanding the Problem

Power series are represented as infinite streams:

- `a0 + a1 x + a2 x² + a3 x³ + ...` → stream: `(a0 a1 a2 a3 ...)`

We already have:
- `add-streams s1 s2` — adds two series term-by-term
- `integrate-series s` — integrates a series
- `scale-stream s factor` — scales each term by a constant

Now we want to define:

```scheme
(define (mul-series s1 s2)
  (cons-stream ⟨??⟩
               (add-streams ⟨??⟩ ⟨??⟩)))
```

Let’s understand how to multiply two series.

---

## 🔢 Multiplying Two Power Series

Suppose:

- `s1 = a0 + a1 x + a2 x² + a3 x³ + ...`
- `s2 = b0 + b1 x + b2 x² + b3 x³ + ...`

Then their product is:

$$
s1 \cdot s2 = c_0 + c_1 x + c_2 x^2 + c_3 x^3 + \ldots
$$

Where:
- $ c_0 = a_0 b_0 $
- $ c_1 = a_0 b_1 + a_1 b_0 $
- $ c_2 = a_0 b_2 + a_1 b_1 + a_2 b_0 $
- etc.

So, the coefficient of $ x^n $ in the product is:

$$
c_n = \sum_{i=0}^{n} a_i b_{n-i}
$$

But we need to implement this **lazily**, using only stream operations.

---

## ✅ Step-by-Step Implementation

Here's the completed definition:

```scheme
(define (mul-series s1 s2)
  (cons-stream
   (* (stream-car s1) (stream-car s2)) ; c₀ = a₀·b₀
   (add-streams
    (scale-stream (stream-cdr s2) (stream-car s1)) ; a₀·(b₁ + b₂x + ...)
    (mul-series (stream-cdr s1) s2)))) ; rest of terms recursively
```

### 📌 Explanation:

- The first term is just the product of the leading terms: `a0 * b0`
- The rest of the terms come from:
  - `a0 * (b1 x + b2 x² + ...)` → `scale-stream (stream-cdr s2) a0`
  - `(a1 x + a2 x² + ...) * (b0 + b1 x + ...)` → `mul-series (stream-cdr s1) s2`

This recursive structure ensures we compute all cross-terms correctly.

---

## ✅ Test Case: Verify Identity $\sin^2(x) + \cos^2(x) = 1$

From Exercise 3.59:

```scheme
(define cosine-series
  (stream-cons 1 (integrate-series (scale-stream sine-series -1))))

(define sine-series
  (stream-cons 0 (integrate-series cosine-series)))
```

Now define:

```scheme
(define (add-streams s1 s2)
  (stream-cons (+ (stream-car s1) (stream-car s2))
               (add-streams (stream-cdr s1) (stream-cdr s2))))

(define (square-series s)
  (mul-series s s))

(define sin-squared (square-series sine-series))
(define cos-squared (square-series cosine-series))
(define sum-of-squares (add-streams sin-squared cos-squared))
```

Now evaluate:

```scheme
(stream-ref sum-of-squares 0) ; ⇒ 1
(stream-ref sum-of-squares 1) ; ⇒ 0
(stream-ref sum-of-squares 2) ; ⇒ 0
(stream-ref sum-of-squares 3) ; ⇒ 0
; and so on...
```

The result should be:

```
1, 0, 0, 0, 0, ...
```

Which represents the constant function **1**, confirming the identity:

$$
\sin^2(x) + \cos^2(x) = 1
$$

---

## ✅ Summary

| Task | Description |
|------|-------------|
| Goal | Multiply two power series represented as streams |
| Key Idea | Use recursion and scaling to compute all pairwise products |
| Resulting Stream | Coefficients of the resulting power series |
| Final Definition | ```(define (mul-series s1 s2) (cons-stream (* (stream-car s1) (stream-car s2)) (add-streams (scale-stream (stream-cdr s2) (stream-car s1)) (mul-series (stream-cdr s1) s2))))``` |
| Test | Verify `sin²(x) + cos²(x) = 1` using stream arithmetic |

---

## 💡 Final Notes

This exercise shows how powerful and elegant **symbolic mathematics with streams** can be.

You're not just computing numbers — you're computing entire functions!

By defining basic operations like:
- Addition (`add-streams`)
- Multiplication (`mul-series`)
- Integration (`integrate-series`)
- Scaling (`scale-stream`)

You can represent and manipulate **infinite mathematical objects** in a clean, modular way.
