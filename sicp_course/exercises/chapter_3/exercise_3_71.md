## 🔧 Step-by-Step Solution

### 1. **Define a Cube Sum Weight Function**

```scheme
(define (cube x) (* x x x))
(define (cube-sum pair) (+ (cube (car pair)) (cube (cadr pair))))
```

This computes the weight of a pair `(i j)` as $ i^3 + j^3 $

---

### 2. **Generate Ordered Pairs Using This Weight**

Use the `weighted-pairs` procedure from Exercise 3.70:

```scheme
(define ramanujan-stream
  (weighted-pairs integers integers cube-sum))
```

Now we have an infinite stream of all pairs `(i j)` where $ i \leq j $, ordered by increasing cube-sum.

---

### 3. **Search for Consecutive Equal Weights**

We define a helper function `find-duplicates`:

```scheme
(define (find-duplicates s)
  (define (iter s1 s2)
    (let ((weight1 (cube-sum s1))
          (weight2 (cube-sum s2)))
      (cond ((= weight1 weight2)
             (cons-stream weight1
                          (iter (stream-cdr s2) (stream-cdr s2))))
            (else
             (iter s2 (stream-cdr s)))))
  (iter (stream-cdr s) (stream-cdr (stream-cdr s)))))
```

Wait — better version below!

Here’s a cleaner implementation:

```scheme
(define (ramanujan-numbers)
  (define (equal-weight? p q)
    (= (cube-sum p) (cube-sum q)))

  (define (iter s)
    (let ((first (stream-car s))
          (second (stream-car (stream-cdr s))))
      (if (equal-weight? first second)
          (cons-stream (cube-sum first)
                       (iter (stream-cdr (stream-cdr s))))
          (iter (stream-cdr s))))
  (iter ramanujan-stream)))
```

This:
- Goes through the stream of pairs
- Checks if **two consecutive pairs** have the same cube-sum
- If so, it's a Ramanujan number — return it
- Skip ahead by 2 to avoid rechecking the same pair

---

## 📦 Example Output

You can now extract Ramanujan numbers like this:

```scheme
(define ramanujan-numbers-stream (ramanujan-numbers))

(stream-ref ramanujan-numbers-stream 0) ; ⇒ 1729
(stream-ref ramanujan-numbers-stream 1) ; ⇒ ?
(stream-ref ramanujan-numbers-stream 2) ; ⇒ ?
...
```

Let’s compute the next few Ramanujan numbers manually or with code.

---

## 🧮 First Few Ramanujan Numbers

| Number | Expression |
|--------|------------|
| 1729   | $ 1^3 + 12^3 = 9^3 + 10^3 $ |
| 4104   | $ 2^3 + 16^3 = 9^3 + 15^3 $ |
| 13832  | $ 2^3 + 24^3 = 18^3 + 20^3 $ |
| 20683  | $ 10^3 + 27^3 = 19^3 + 24^3 $ |
| 32832  | $ 4^3 + 32^3 = 18^3 + 30^3 $ |
| 39312  | $ 2^3 + 34^3 = 15^3 + 33^3 $ |

So the first Ramanujan number is **1729**, and the next five are:

> ✅ **4104, 13832, 20683, 32832, 39312**

---

## ✅ Summary

| Task | Description |
|------|-------------|
| Goal | Find numbers expressible as sum of two cubes in more than one way |
| Strategy | Use weighted-pairs ordered by cube-sum, search for duplicates |
| Key Tools | `cube`, `cube-sum`, `weighted-pairs`, `ramanujan-numbers` |
| First Result | 1729 = $1^3 + 12^3 = 9^3 + 10^3$ |
| Next Five | 4104, 13832, 20683, 32832, 39312 |

---

## 💡 Final Notes

This exercise shows how elegant solutions can arise when combining:
- **Infinite streams**
- **Lazy evaluation**
- **Ordered merging via weighting functions**

By using `weighted-pairs` and filtering for **duplicates**, you can efficiently explore a vast space of mathematical identities.
