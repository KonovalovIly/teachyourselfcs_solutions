### ✅ **Exercise 2.87** — *SICP*

## 🧠 **Goal**
Implement a generic predicate `=zero?` for **polynomials**, so that:

- A polynomial is considered zero if **all its terms have zero coefficients**.
- This supports nested polynomials (e.g., coefficients can also be polynomials).
- Integrates with the existing **generic system**, allowing `adjoin-term` and other operations to work properly.

---

## 🔧 Step-by-Step Solution

### 1. **Define `=zero?` for a Polynomial**

A polynomial is zero if all of its **terms** have **coefficients** that are zero (recursively).

```scheme
(define (=zero? x) (apply-generic 'zero? x))
```

### 2. **Add Implementation for Polynomials**

We define a helper function that checks whether all terms in a polynomial are zero:

```scheme
(define (zero-poly? poly)
  (define (all-zero? terms)
    (or (null? terms)
        (and (=zero? (coeff (first-term terms)))
             (all-zero? (rest-terms terms)))))
  (all-zero? (term-list poly)))
```

### 3. **Install in the Generic System**

In the polynomial package, add this line:

```scheme
(put 'zero? '(polynomial) (lambda (x) (zero-poly? x)))
```

This makes `=zero?` work on any `polynomial`.

---

## 📦 Example Usage

Suppose we have:
```scheme
(define p1 (make-polynomial 'x '((2 1) (1 0) (0 0)))) ; x²
(define p2 (make-polynomial 'x '((2 0) (1 0) (0 0)))) ; 0 polynomial
```

Then:
```scheme
(=zero? p1) ; ⇒ #f (not all terms zero)
(=zero? p2) ; ⇒ #t (all terms are zero)
```

If a coefficient is itself a polynomial:
```scheme
(define inner-p (make-polynomial 'y '((1 1) (0 -1)))) ; y - 1
(define outer-p (make-polynomial 'x `((1 ,inner-p) (0 0))))
(=zero? outer-p) ; ⇒ depends on whether inner-p is zero
```

So long as `=zero?` is defined recursively, it works!

---

## ✅ Summary

| Task | Description |
|------|-------------|
| Goal | Implement `=zero?` for polynomials |
| Method | Recursively check if all term coefficients are zero |
| Integration | Add `(put 'zero? '(polynomial) ...)` to generic table |
| Use Case | Supports nested polynomials and proper behavior of `adjoin-term` |
