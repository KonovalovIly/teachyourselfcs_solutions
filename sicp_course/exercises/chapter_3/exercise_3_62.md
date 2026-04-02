## 🧠 Understanding the Problem

We're working with infinite streams representing **power series**, where:

- Each stream is a list of coefficients:
  $ a_0 + a_1 x + a_2 x^2 + a_3 x^3 + \ldots $ → `(a0 a1 a2 a3 ...)`

From previous exercises:
- `add-streams`: Adds two series term-by-term
- `mul-series`: Multiplies two series
- `invert-unit-series`: Inverts a series whose constant term is **1**

Now we want:
- `div-series s1 s2`: Divides two series, i.e., returns the series for $ s1 / s2 $

This works only if the **constant term of `s2` is not zero** — otherwise division is undefined.

---

## ✅ Step-by-Step Solution

### 1. **Define `div-series`**

We’ll normalize the denominator so its constant term is 1, then invert it using `invert-unit-series`, and multiply by the numerator.

Here’s how:

```scheme
(define (div-series s1 s2)
  (let ((denominator-const (stream-car s2)))
    (if (= denominator-const 0)
        (error "Denominator has zero constant term -- DIV-SERIES")
        (let ((normalized-s2 (scale-stream s2 (/ 1 denominator-const))))
          (mul-series s1
                      (invert-unit-series normalized-s2))))))
```

### 📌 Explanation:

- First check: if the constant term of `s2` is zero → error
- Normalize `s2` so its constant term becomes 1: scale by `1/denominator-const`
- Invert the normalized series using `invert-unit-series`
- Multiply the result with `s1` → gives `s1 / s2`

---

### 2. **Generate the Tangent Series**

From Exercise 3.59, we have:

```scheme
(define cosine-series
  (stream-cons 1 (integrate-series (scale-stream sine-series -1))))

(define sine-series
  (stream-cons 0 (integrate-series cosine-series)))
```

Now define `tan-series` as the quotient:

```scheme
(define tan-series (div-series sine-series cosine-series))
```

This computes:
$$
\tan(x) = \frac{\sin(x)}{\cos(x)}
$$

You can now inspect the resulting stream:

```scheme
(stream-ref tan-series 0) ; ⇒ 0
(stream-ref tan-series 1) ; ⇒ 1
(stream-ref tan-series 2) ; ⇒ 0
(stream-ref tan-series 3) ; ⇒ 1/3
(stream-ref tan-series 4) ; ⇒ 0
(stream-ref tan-series 5) ; ⇒ 2/15
```

Which matches the known Taylor expansion of $\tan(x)$ around 0:

$$
\tan(x) = x + \frac{1}{3}x^3 + \frac{2}{15}x^5 + \cdots
$$

---

## ✅ Summary

| Task | Description |
|------|-------------|
| Goal | Divide two power series represented as streams |
| Key Idea | Normalize denominator to have constant term 1, then invert and multiply |
| Required Tools | `mul-series`, `invert-unit-series`, `scale-stream` |
| Final Definition | ```(define (div-series s1 s2) (if (= (stream-car s2) 0) (error "Zero constant in denominator") (mul-series s1 (invert-unit-series (scale-stream s2 (/ 1 (stream-car s2))))))``` |
| Tangent Series | Defined as `(div-series sine-series cosine-series)` |

---

## 💡 Final Notes

This exercise demonstrates how to perform **symbolic division** on infinite power series using only basic stream operations and recursive definitions.

By combining:
- Scaling
- Multiplication
- Inversion

You can compute complex analytic functions like `tan(x)` purely through symbolic manipulation of their series expansions.
