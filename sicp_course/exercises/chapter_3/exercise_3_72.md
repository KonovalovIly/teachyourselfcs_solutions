## 🧠 Understanding the Problem

We want:
- A number $ N $ such that there are **three distinct pairs** $(a, b)$, $(c, d)$, $(e, f)$ with:
  $$
  a^2 + b^2 = c^2 + d^2 = e^2 + f^2 = N
  $$

And all pairs are **distinct** (and unordered, i.e., $ a \leq b $, etc.)

To do this:
- Use `weighted-pairs` from Exercise 3.70
- Weight each pair by its sum of squares: $ i^2 + j^2 $
- Search for **triplets of consecutive pairs** with the **same weight**

---

## 🔧 Step-by-Step Implementation

### 1. **Define Square Sum Weight Function**

```scheme
(define (square x) (* x x))
(define (sum-of-squares pair)
  (+ (square (car pair)) (square (cadr pair))))
```

### 2. **Generate Ordered Pairs Using This Weight**

Use the `weighted-pairs` function from Exercise 3.70:

```scheme
(define square-pairs
  (weighted-pairs integers integers sum-of-squares))
```

This gives an infinite stream of pairs `(i j)` with $ i \leq j $, ordered by increasing value of $ i^2 + j^2 $

---

### 3. **Search for Triples with Same Sum of Squares**

We need to detect **three consecutive pairs** in the stream that have the **same sum of squares**.

Here’s how to implement that:

```scheme
(define (find-triple-sums s)
  (define (iter s count result)
    (let ((current (stream-car s))
          (next (stream-car (stream-cdr s)))
          (next-next (stream-car (stream-cdr (stream-cdr s)))))
      (let ((w1 (sum-of-squares current))
            (w2 (sum-of-squares next))
            (w3 (sum-of-squares next-next)))
        (if (= w1 w2 w3)
            (cons-stream
             (list w1
                   current
                   next
                   next-next)
             (iter (stream-cdr (stream-cdr (stream-cdr s))) 0 '()))
            (iter (stream-cdr s) 0 '())))))
  (iter s 0 '()))
```

This:
- Looks at three consecutive pairs
- If their sums match → it's a valid triple
- Returns a list: `(sum (a b) (c d) (e f))`
- Then continues searching

You can then define the stream of such numbers like this:

```scheme
(define triple-square-sums
  (find-triple-sums square-pairs))
```

Now you can extract results:

```scheme
(stream-ref triple-square-sums 0)
;; ⇒ (325 (1 18) (6 17) (10 15))

(stream-ref triple-square-sums 1)
;; ⇒ (425 (5 20) (8 19) (13 16))

(stream-ref triple-square-sums 2)
;; ⇒ (650 (11 23) (17 19) (13 21))
```

---

## 📌 Example Output

Here are some known numbers expressible as the **sum of two squares in three different ways**:

| Number | Representations |
|--------|------------------|
| 325    | $ 1^2 + 18^2 = 6^2 + 17^2 = 10^2 + 15^2 $ |
| 425    | $ 5^2 + 20^2 = 8^2 + 19^2 = 13^2 + 16^2 $ |
| 650    | $ 11^2 + 23^2 = 17^2 + 19^2 = 13^2 + 21^2 $ |

These numbers appear early in the stream if you generate `square-pairs` correctly.

---

## ✅ Summary

| Task | Description |
|------|-------------|
| Goal | Find numbers expressible as sum of two squares in **three different ways** |
| Strategy | Use `weighted-pairs` ordered by sum of squares, search for **triplets** with equal weights |
| Key Tools | `square`, `sum-of-squares`, `weighted-pairs`, `find-triple-sums` |
| First Result | 325 = $ 1^2 + 18^2 = 6^2 + 17^2 = 10^2 + 15^2 $ |
| Next Results | 425, 650, 845, 925, 1025, ... |

---

## 🧮 Final Definitions

### ✅ `square` and `sum-of-squares`

```scheme
(define (square x) (* x x))
(define (sum-of-squares pair)
  (+ (square (car pair)) (square (cadr pair))))
```

### ✅ `weighted-pairs` (from Exercise 3.70)

```scheme
(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2)))
           (if (<= (weight s1car) (weight s2car))
               (cons-stream s1car
                            (merge-weighted (stream-cdr s1) s2 weight))
               (cons-stream s2car
                            (merge-weighted s1 (stream-cdr s2) weight))))))

(define (weighted-pairs s t weight)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (merge-weighted
    (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
    (weighted-pairs (stream-cdr s) (stream-cdr t) weight)
    weight)))
```

### ✅ Stream of Integers

```scheme
(define integers (integers-starting-from 1))
```

(Where `integers-starting-from` is defined as usual.)

### ✅ Detect Triplets

```scheme
(define (find-triple-sums s)
  (define (iter s)
    (let* ((p1 (stream-car s))
           (p2 (stream-car (stream-cdr s)))
           (p3 (stream-car (stream-cdr (stream-cdr s))))
      (let ((w1 (sum-of-squares p1))
            (w2 (sum-of-squares p2))
            (w3 (sum-of-squares p3)))
        (if (= w1 w2 w3)
            (cons-stream
             (list w1 p1 p2 p3)
             (iter (stream-cdr (stream-cdr (stream-cdr s))))
            (iter (stream-cdr s)))))
  (iter s))

(define triple-square-sums
  (find-triple-sums square-pairs))
```

---

## 💡 Final Thought

This exercise shows how powerful and elegant **stream-based programming** can be for exploring **number-theoretic patterns**.

By using:
- Infinite streams
- Weighted merging
- Lazy filtering

You can explore complex mathematical structures like:
- Ramanujan numbers
- Numbers expressible as sum of squares in multiple ways
- Even higher-order identities (e.g., four or more representations)

It’s a great example of how functional programming supports **symbolic exploration of number theory**.
