## 🧠 **Background: Why This Is Needed**

In Exercise 2.95, we saw that computing the GCD of two integer-coefficient polynomials using regular division leads to:

- Intermediate terms with **rational coefficients**
- A final result that is not an integer multiple of the true GCD

To fix this, we use **pseudo-division**, which multiplies the dividend by a **scaling factor** before division to ensure all intermediate values remain integers.

---

## 🔧 Step-by-Step Solution

### ✅ Part (a): Implement `pseudoremainder-terms`

We define a helper function to compute the **integerizing factor**:

```scheme
(define (integerizing-factor t1 t2)
  (let ((c1 (coeff t1)) ; leading coefficient of dividend
        (c2 (coeff t2)) ; leading coefficient of divisor
        (o1 (order t1))
        (o2 (order t2)))
    (expt c2 (+ o1 (- o2) 1))))
```

Now implement `pseudoremainder-terms`:

```scheme
(define (pseudoremainder-terms L1 L2)
  (let ((t1 (first-term L1))
        (t2 (first-term L2)))
    (let ((factor (integerizing-factor t1 t2)))
      (let ((scaled-L1 (mul-term-by-all-terms (make-term 0 factor) L1)))
        (cadr (div-terms scaled-L1 L2))))))
```

You'll need a helper:

```scheme
(define (mul-term-by-all-terms t term-list)
  (if (empty-termlist? term-list)
      (the-empty-termlist)
      (let ((first (first-term term-list)))
        (adjoin-term
         (+ (order t) (order first))
         (mul (coeff t) (coeff first))
         (mul-term-by-all-terms t (rest-terms term-list))))))
```

---

### ✅ Part (b): Modify `gcd-terms` to Use Pseudo-Division and Remove Common Factors

Update `gcd-terms` to use `pseudoremainder-terms`, and then reduce the result by dividing out any common integer factor from the coefficients:

```scheme
(define (gcd-terms a b)
  (if (empty-termlist? b)
      (reduce-termlist a)
      (gcd-terms b (pseudoremainder-terms a b))))

(define (reduce-termlist term-list)
  (if (empty-termlist? term-list)
      term-list
      (let ((coeffs (map coeff (termlist->term-list term-list))))
        (let ((g (gcd-coefficients coeffs)))
          (if (= g 1)
              term-list
              (map-termlist-coefficients (lambda (c) (div c g)) term-list))))))

;; Helpers
(define (termlist->term-list tl)
  ;; Convert internal representation (e.g., vector or list) to list of terms
  ...)

(define (map-termlist-coefficients f term-list)
  ;; Apply f to each coefficient in term-list
  ...)

(define (gcd-coefficients coeffs)
  (define (iter g rest)
    (if (null? rest)
        g
        (iter (gcd g (car rest)) (cdr rest))))
  (if (null? coeffs)
      0
      (iter (abs (car coeffs)) (cdr coeffs))))
```

(Implement `termlist->term-list` and `map-termlist-coefficients` based on your term list structure.)

---

## 🧪 Test Case from Exercise 2.95

Given:

```scheme
(define p1 (make-polynomial 'x '((2 1) (1 2) (0 1)))) ; x² + 2x + 1
(define p2 (make-polynomial 'x '((2 11) (0 7))))       ; 11x² + 7
(define p3 (make-polynomial 'x '((1 13) (0 5))))       ; 13x + 5

(define q1 (mul p1 p2)) ; Q1 = P1 * P2
(define q2 (mul p1 p3)) ; Q2 = P1 * P3
```

Now call:

```scheme
(greatest-common-divisor q1 q2)
```

With pseudo-division and reduction, you should now get:

```scheme
(polynomial x ((2 1) (1 2) (0 1)))
```

Which is exactly $ x^2 + 2x + 1 $, i.e., **equal to P1**!

---

## ✅ Summary

| Task | Description |
|------|-------------|
| `integerizing-factor` | Computes scaling factor to avoid fractions |
| `pseudoremainder-terms` | Multiplies dividend before calling `div-terms` |
| `gcd-terms` | Modified to use pseudo-remainder |
| `reduce-termlist` | Divides all coefficients by their GCD |
| Result | Now `greatest-common-divisor` returns correct GCD even for integer-coefficient polynomials |

---

## 💡 Final Notes

This version of the GCD algorithm is called the **primitive Euclidean algorithm**, and it ensures:

- All operations stay within the domain of **integer polynomials**
- The GCD returned has **no unnecessary common factor** among its coefficients
- It works robustly even when standard division would introduce rational numbers
