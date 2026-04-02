## 🧠 Why Ben's Scheme Fails

Ben’s idea seems solid:
- Feed the query pattern to `qeval`
- Get a stream of matches
- Map over the stream to extract values
- Apply the accumulator

But in logic systems like this one:
- The same logical fact can appear **multiple times**
- Even if it's logically equivalent, it may come from **different rules or recursive paths**

So for example:

```scheme
(wheel (Warbucks Oliver))
```

Appears **four times** in Exercise 4.65 — because there are four ways to prove that Warbucks is a wheel.

If you use `(sum ?amount (wheel ?person))` and Warbucks appears 4 times, his salary would be counted **four times**, which is wrong.

---

## 🔍 What Ben Realizes

Ben now understands:
> ❌ Accumulating over raw query results leads to **incorrect totals**, because the system returns **duplicate answers**.

In other words:
- Logic engines return **all derivations**, not just unique results
- Accumulators like `sum` must process only **distinct matches**

This is a common issue in declarative logic programming.

---

## ✅ How Ben Can Salvage the Situation

To fix this, Ben needs a way to **deduplicate** the stream of frames before applying the accumulator.

Here’s how he could do it:

### Step 1: Deduplicate by Key Variable

Define a helper that removes duplicates based on the value of a variable (e.g., `?person`):

```scheme
(define (remove-duplicates var-name frame-stream)
  (let ((seen '()))
    (stream-filter
     (lambda (frame)
       (let ((val (get-binding var-name frame)))
         (if (member val seen)
             #f
             (begin
               (set! seen (cons val seen))
               #t)))
     frame-stream)))
```

### Step 2: Modify Accumulation Function

Instead of feeding all frames into the accumulator, first deduplicate them:

```scheme
(define (sum var query-pattern frame-stream)
  (define (extract var frame)
    (get-binding var frame))

  (apply +
         (map (lambda (frame) (extract var frame))
              (stream->list
               (remove-duplicates var frame-stream))))
```

Where:
- `stream->list` converts the stream to a list for accumulation
- `remove-duplicates` ensures each person is only counted once
- `get-binding` gets the value of a variable from a frame

---

## 📦 Example: Fixing the Programmer Salary Query

Original query:

```scheme
(sum ?amount (and (job ?x (computer programmer)) (salary ?x ?amount)))
```

Suppose two programmers:
- Ben Bitdiddle → $90k
- Louis Reasoner → $60k

And suppose Ben is listed twice in the database via different rule paths.

Then without deduplication:

```scheme
→ 90000 + 60000 + 90000 = 240000 ❌ (Ben counted twice)
```

With deduplication:

```scheme
→ 90000 + 60000 = 150000 ✅
```

---

## 🎯 Summary

| Concept | Description |
|--------|-------------|
| Goal | Implement accumulation functions like `sum` |
| Problem | Duplicate results cause overcounting |
| Root Cause | Logic engine returns all derivation paths |
| Solution | Deduplicate results before accumulation |
| Deduplication Strategy | Filter out repeated values of a key variable (`?person`) |

---

## 💡 Final Thought

This exercise reveals a subtle but critical difference between:
- **Logical truth**: A fact holds
- **Derivation count**: It may hold in multiple ways

Accumulations like `sum`, `average`, or `count` must consider **logical identity**, not just syntactic match.

Without careful handling, logic engines can produce **correct results** that lead to **wrong conclusions** when used with aggregations.

Ben’s realization shows how even small oversights in data representation can lead to big errors in statistical queries.
