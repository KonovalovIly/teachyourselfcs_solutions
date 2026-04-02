## 🧠 Overview

We represent power series as infinite streams of their coefficients:

- `a0 + a1 x + a2 x² + a3 x³ + ...` → stream: `(a0 a1 a2 a3 ...)`

We’ll implement:
- A procedure `integrate-series` that integrates a power series
- The exponential series `exp-series`
- The sine and cosine series using the relationships between their derivatives

---

## ✅ Part (a): Define `integrate-series`

Given a stream of coefficients `a0, a1, a2, a3, ...`, we want to produce the stream:

```
a0, (1/1)a1, (1/2)a2, (1/3)a3, ...
```

Note: This excludes the constant term in the integral (we'll add it separately).

```scheme
(define (integrate-series s)
  (define (integrate-iter stream n)
    (if (stream-null? stream)
        the-empty-stream
        (stream-cons (/ (stream-car stream) n)
                     (integrate-iter (stream-cdr stream) (+ n 1)))))
  (integrate-iter s 1))
```

This starts dividing by `1`, then `2`, etc., skipping the first coefficient (`a0`) from being divided — because the integral of `a0` is `a0 x`.

So:
```scheme
(integrate-series (stream a0 a1 a2 a3 ...))
→ (stream a0 (/ a1 1) (/ a2 2) (/ a3 3) ...)
```

---

## ✅ Part (b): Define `exp-series` Using Integration

We know:
- The derivative of `e^x` is itself.
- Therefore, `e^x` is equal to the integral of itself, plus a constant (the constant term).

We define:

```scheme
(define exp-series
  (stream-cons 1 (integrate-series exp-series)))
```

Explanation:
- Start with constant term `1`
- The rest of the terms are the integral of the whole series

This recursive definition works because each new term is computed lazily.

---

## ✅ Define `sine-series` and `cosine-series`

From calculus:
- Derivative of `sin(x)` is `cos(x)`
- Derivative of `cos(x)` is `-sin(x)`

Therefore:
- `cos(x)` is the integral of `-sin(x)`
- `sin(x)` is the integral of `cos(x)`

We define them recursively:

```scheme
(define cosine-series
  (stream-cons 1 (integrate-series (scale-stream sine-series -1))))

(define sine-series
  (stream-cons 0 (integrate-series cosine-series)))
```

Where `scale-stream` multiplies every element in a stream by a constant:

```scheme
(define (scale-stream s factor)
  (stream-map (lambda (x) (* x factor)) s))
```

And `stream-map` is defined as:

```scheme
(define (stream-map proc s)
  (if (stream-null? s)
      the-empty-stream
      (stream-cons
       (proc (stream-car s))
       (stream-map proc (stream-cdr s)))))
```

---

## 📌 Summary of Series Definitions

| Series | Definition |
|--------|------------|
| `exp-series` | ```(define exp-series (stream-cons 1 (integrate-series exp-series)))``` |
| `cosine-series` | ```(define cosine-series (stream-cons 1 (integrate-series (scale-stream sine-series -1))))``` |
| `sine-series` | ```(define sine-series (stream-cons 0 (integrate-series cosine-series)))``` |

These definitions capture the **recursive nature of Taylor series expansions**, using only basic operations on streams.

---

## 🧮 Example Coefficients

Let’s look at the first few elements of each series:

### `exp-series`: eˣ = 1 + x + x²/2! + x³/3! + ...

```scheme
(stream-ref exp-series 0) ; ⇒ 1
(stream-ref exp-series 1) ; ⇒ 1
(stream-ref exp-series 2) ; ⇒ 1/2
(stream-ref exp-series 3) ; ⇒ 1/6
(stream-ref exp-series 4) ; ⇒ 1/24
```

### `sine-series`: sin(x) = x - x³/3! + x⁵/5! - ...

```scheme
(stream-ref sine-series 0) ; ⇒ 0
(stream-ref sine-series 1) ; ⇒ 1
(stream-ref sine-series 2) ; ⇒ 0
(stream-ref sine-series 3) ; ⇒ -1/6
(stream-ref sine-series 4) ; ⇒ 0
(stream-ref sine-series 5) ; ⇒ 1/120
```

### `cosine-series`: cos(x) = 1 - x²/2! + x⁴/4! - ...

```scheme
(stream-ref cosine-series 0) ; ⇒ 1
(stream-ref cosine-series 1) ; ⇒ 0
(stream-ref cosine-series 2) ; ⇒ -1/2
(stream-ref cosine-series 3) ; ⇒ 0
(stream-ref cosine-series 4) ; ⇒ 1/24
(stream-ref cosine-series 5) ; ⇒ 0
```

---

## ✅ Summary

| Task | Description |
|------|-------------|
| Goal | Represent power series as infinite streams |
| Key Idea | Use recursion and integration to build series |
| `integrate-series` | Integrates a stream of coefficients |
| `exp-series` | Defined recursively via its own integral |
| `sine-series`, `cosine-series` | Defined based on their mutual derivatives |
| Required Helper | `scale-stream` for negation in cosine definition |

---

## 💡 Final Notes

This exercise shows how powerful **stream-based programming** can be for symbolic mathematics.

By defining just a few primitives:
- Stream operations
- Integration
- Scaling

You can derive complex mathematical functions like `e^x`, `sin(x)`, and `cos(x)` using **simple recursive definitions**.
