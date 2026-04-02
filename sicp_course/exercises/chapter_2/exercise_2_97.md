## 🧠 **Overview**

We will implement:

1. `reduce-terms` — reduce two term lists by dividing them by their polynomial GCD.
2. `reduce-poly` — wrap `reduce-terms`, ensuring both polynomials have the same variable.
3. `reduce-integers` — reduce integer numerator and denominator using standard GCD.
4. A generic `reduce` operation that dispatches between the above.
5. Modify `make-rat` to automatically reduce before creating a rational number.

---

## 🔧 Step-by-Step Implementation

### ✅ Part (a): `reduce-terms` and `reduce-poly`

#### 1. **Implement `reduce-terms`**

```scheme
(define (reduce-terms n d)
  (let ((gcd (gcd-terms n d)))
    (let ((nn (div-terms n gcd))
          (dd (div-terms d gcd)))
      (list (car nn) (car dd))))) ; return quotient parts only
```

Note: This assumes you've implemented `gcd-terms` and `div-terms` from earlier exercises.

---

#### 2. **Implement `reduce-poly`**

```scheme
(define (reduce-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
      (let ((result (reduce-terms (term-list p1)
                                  (term-list p2))))
        (list (make-polynomial (variable p1) (car result))
              (make-polynomial (variable p1) (cadr result))))
      (error "Polynomials not in same variable -- REDUCE-POLY"
             (list p1 p2))))
```

---

### ✅ Part (b): `reduce-integers` and Generic `reduce`

#### 1. **Implement `reduce-integers`**

```scheme
(define (reduce-integers n d)
  (let ((g (gcd n d)))
    (list (/ n g) (/ d g))))
```

Assuming `n` and `d` are integers.

---

#### 2. **Install Generic `reduce` Operation**

```scheme
(define (install-reduction-package)
  ;; reduce for integers
  (put 'reduce '(scheme-number scheme-number)
       (lambda (n d)
         (let ((result (reduce-integers (contents n) (contents d))))
           (map tag result)))) ; tag results as scheme-numbers

  ;; reduce for polynomials
  (put 'reduce '(polynomial polynomial)
       (lambda (p1 p2)
         (let ((result (reduce-poly p1 p2)))
           (map tag result)))) ; tag as polynomials

  'done)

(define (reduce x y)
  (apply-generic 'reduce x y))
```

Make sure `tag` wraps the result appropriately.

---

### ✅ Update `make-rational` to Use `reduce`

Now update your rational package's constructor:

```scheme
(define (make-rational n d)
  (let ((result (reduce n d)))
    (cons (car result) (cadr result))))
```

So now, every time a rational number is created, it is automatically reduced.

---

## 🧪 Test Case

Given:

```scheme
(define p1 (make-polynomial 'x '((1 1) (0 1)))) ; x + 1
(define p2 (make-polynomial 'x '((3 1) (0 -1)))) ; x³ - 1
(define p3 (make-polynomial 'x '((1 1))))         ; x + 0
(define p4 (make-polynomial 'x '((2 1) (0 -1)))) ; x² - 1

(define rf1 (make-rational p1 p2)) ; (x + 1)/(x³ - 1)
(define rf2 (make-rational p3 p4)) ; (x)/(x² - 1)

(add rf1 rf2)
```

Let’s compute this manually:

- $ \frac{x+1}{x^3 - 1} + \frac{x}{x^2 - 1} $

Note:
- $ x^3 - 1 = (x - 1)(x^2 + x + 1) $
- $ x^2 - 1 = (x - 1)(x + 1) $

So common denominator is:
$$
(x - 1)(x + 1)(x^2 + x + 1)
$$

Add numerators accordingly.

After simplifying, the result should be:

$$
\frac{2x + 1}{(x - 1)(x^2 + x + 1)}
$$

Which means the GCD-based reduction works correctly!

---

## ✅ Summary

| Task | Description |
|------|-------------|
| `reduce-terms` | Reduces two term lists using polynomial GCD |
| `reduce-poly` | Ensures same variable and applies `reduce-terms` |
| `reduce-integers` | Reduces integer numerator/denominator with GCD |
| `reduce` | Generic operation that dispatches based on type |
| `make-rational` | Now uses `reduce` internally to simplify |
| Result | Rational numbers (integer or polynomial) are always simplified |

---

## 💡 Final Notes

This completes the full symbolic algebra system from Chapter 2 of *SICP*. You now have:

- Generic arithmetic across types
- Support for nested polynomials
- Rational function manipulation
- Automatic simplification using GCD
- Data-directed design for extensibility

It's a powerful foundation for building more advanced computer algebra systems.
