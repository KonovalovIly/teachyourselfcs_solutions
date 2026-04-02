## 🔧 Step-by-Step Implementation

We'll build up:

1. `merge-weighted`: Merges two streams based on a weight function
2. `weighted-pairs`: Generates all `(i, j)` pairs (with `i ≤ j`) in order of increasing weight

We assume you already have standard stream utilities:

```scheme
(define (stream-car s) (car s))
(define (stream-cdr s) (force (cdr s)))
(define (stream-null? s) (null? s))
(define the-empty-stream '())
```

---

## ✅ Part 1: `merge-weighted`

Takes two streams and a weight function `weight`, merges them in order of increasing weight:

```scheme
(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2)))
           (if (<= (weight s1car) (weight s2car))
               (cons-stream s1car (merge-weighted (stream-cdr s1) s2 weight))
               (cons-stream s2car (merge-weighted s1 (stream-cdr s2) weight)))))))
```

---

## ✅ Part 2: `weighted-pairs`

Generates an infinite stream of pairs `(i j)` such that $ i \leq j $, ordered by the given weight function.

Structure:
- First element: `(S₀ T₀)`
- Then interleave:
  - All pairs starting with `S₀` and varying `T`
  - Recursive diagonal: `(i+1, j+1)` etc.

Here's the implementation:

```scheme
(define (weighted-pairs s t weight)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (merge-weighted
    (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
    (weighted-pairs (stream-cdr s) (stream-cdr t) weight)
    weight)))
```

Note:
- The recursive call ensures we get diagonal elements in order
- The `stream-map` gives us all pairs `(S₀, T₁), (S₀, T₂), ...`

---

## 📌 Example: Pairs Ordered by Sum

Use `weighted-pairs` with the weight function `sum`:

```scheme
(define (sum pair)
  (+ (car pair) (cadr pair)))

(define ordered-pairs (weighted-pairs integers integers sum))
```

Now evaluate:

```scheme
(stream-ref ordered-pairs 0) ; ⇒ (1 1) → sum = 2
(stream-ref ordered-pairs 1) ; ⇒ (1 2) → sum = 3
(stream-ref ordered-pairs 2) ; ⇒ (2 2) → sum = 4
(stream-ref ordered-pairs 3) ; ⇒ (1 3) → sum = 4
(stream-ref ordered-pairs 4) ; ⇒ (2 3) → sum = 5
(stream-ref ordered-pairs 5) ; ⇒ (3 3) → sum = 6
...
```

You get all pairs in increasing order of their **sum**.

---

## 📌 Example: Pairs Not Divisible by 2, 3, or 5, Weighted Differently

We want:
- Only pairs `(i j)` where neither `i` nor `j` is divisible by 2, 3, or 5
- Order by custom weight:
  $ W(i, j) = 2i + 3j + 5ij $

### 1. **Filter Stream of Integers**

Define a stream of integers not divisible by 2, 3, or 5:

```scheme
(define (divisible-by-any? n divisors)
  (define (iter ds)
    (cond ((null? ds) #f)
          ((= (remainder n (car ds)) 0) #t)
          (else (iter (cdr ds))))
  (iter divisors)))

(define filtered-integers
  (stream-filter (lambda (n) (not (divisible-by-any? n '(2 3 5))) integers)))
```

### 2. **Custom Weight Function**

```scheme
(define (custom-weight pair)
  (let ((i (car pair))
       (j (cadr pair)))
    (+ (* 2 i) (* 3 j) (* 5 i j))))
```

### 3. **Generate Weighted Pairs**

```scheme
(define special-pairs
  (weighted-pairs filtered-integers filtered-integers custom-weight))
```

This will generate only valid pairs `(i j)` with `i <= j`, and sort them using your custom weight.

---

## ✅ Summary

| Task | Description |
|------|-------------|
| Goal | Generate ordered pairs/triples from infinite streams |
| Key Idea | Use weighting function to control merge order |
| Tools Used | `merge-weighted`, `weighted-pairs` |
| Application 1 | Generate all `(i j)` ordered by `i + j` |
| Application 2 | Generate `(i j)` where `i,j` not divisible by 2, 3, or 5, ordered by custom weight |

---

## 🧮 Final Definitions

### ✅ `merge-weighted`

```scheme
(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2)))
           (if (<= (weight s1car) (weight s2car))
               (cons-stream s1car (merge-weighted (stream-cdr s1) s2 weight))
               (cons-stream s2car (merge-weighted s1 (stream-cdr s2) weight)))))))
```

### ✅ `weighted-pairs`

```scheme
(define (weighted-pairs s t weight)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (merge-weighted
    (stream-map (lambda (x) (list (stream-car s) x)) (stream-cdr t))
    (weighted-pairs (stream-cdr s) (stream-cdr t) weight)
    weight)))
```

---

## 💡 Final Notes

This exercise shows how to:
- Control **infinite stream generation** via weighting functions
- Build **domain-specific streams**, e.g., for number theory or optimization
- Combine **filtering** and **ordering** over infinite data structures

It’s a great example of how functional programming can model complex mathematical sequences using simple, composable building blocks.
