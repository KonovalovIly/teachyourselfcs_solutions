## 🧠 Understanding the Problem

We are working with **infinite streams** and want to generate **ordered combinations**:

- Each triple is made from one element from each stream
- The indices must satisfy $ i \leq j \leq k $
- We want the stream to be generated **lazily**, so we can process it indefinitely

Then, apply this to find **Pythagorean triples**, which are integer solutions to:
$$
i^2 + j^2 = k^2
$$

We'll assume all three streams are the same: `(integers 1)` → `1, 2, 3, ...`

---

## 🔧 Step-by-Step Solution

### 1. **Define `triples`**

We build on the `pairs` function from earlier exercises.

We interleave:
- All triples with fixed first two elements
- Diagonal recursion over all three streams

Here's how to define `triples`:

```scheme
(define (triples s t u)
  (cons-stream
   (list (stream-car s) (stream-car t) (stream-car u))
   (interleave
    (stream-map (lambda (x) (cons (stream-car s) x))
                (pairs (stream-cdr t) (stream-cdr u)))
    (triples (stream-cdr s)
             (stream-cdr t)
             (stream-cdr u)))))
```

This ensures:
- First triple is `(s₀ t₀ u₀)`
- Then interleave:
  - All triples starting with `s₀`
  - Recursive diagonal triples `(s₁ t₁ u₁), (s₂ t₂ u₂), ...`

You’ll need the `interleave` function from earlier:

```scheme
(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream
       (stream-car s1)
       (interleave s2 (stream-cdr s1)))))
```

And also the `pairs` function from Exercise 3.66 or 3.67.

---

### 2. **Generate Pythagorean Triples**

Now use `triples` with three copies of the integers stream:

```scheme
(define integers (integers-starting-from 1))
```

Then filter for the condition $ i^2 + j^2 = k^2 $:

```scheme
(define (pythagorean? triple)
  (let ((i (car triple))
        (j (cadr triple))
        (k (caddr triple)))
    (= (+ (* i i) (* j j)) (* k k))))

(define pythagorean-triples
  (stream-filter pythagorean? (triples integers integers integers)))
```

Where `stream-filter` is defined as:

```scheme
(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter pred (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))
```

---

## 📦 Example Output

Evaluate:

```scheme
(stream-ref pythagorean-triples 0) ; ⇒ (3 4 5)
(stream-ref pythagorean-triples 1) ; ⇒ (5 12 13)
(stream-ref pythagorean-triples 2) ; ⇒ (6 8 10)
(stream-ref pythagorean-triples 3) ; ⇒ (7 24 25)
(stream-ref pythagorean-triples 4) ; ⇒ (9 12 15)
...
```

These are the classic **Pythagorean triples**, ordered by increasing values of $ i \leq j \leq k $

---

## ✅ Summary

| Task | Description |
|------|-------------|
| Goal | Generate infinite stream of triples `(i j k)` such that $ i \leq j \leq k $ |
| Key Idea | Recursively interleave fixed-value pairs and diagonal recursion |
| Final Definition | ```(define (triples s t u) (cons-stream (list (stream-car s) (stream-car t) (stream-car u)) (interleave (stream-map (lambda (x) (cons (stream-car s) x)) (pairs (stream-cdr t) (stream-cdr u))) (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))``` |
| Application | Filter to get Pythagorean triples using `stream-filter` |

---

## 💡 Final Notes

This exercise demonstrates how powerful recursive stream definitions can be:
- You can represent **infinite sets of structured data**
- With lazy evaluation, you only compute what you need
- Filtering lets you extract meaningful subsets like **mathematical identities**

It’s a beautiful example of how functional programming and infinite data structures work together to model complex mathematical patterns.
