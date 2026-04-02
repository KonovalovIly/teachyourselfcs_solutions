## 🧠 Understanding the Problem

We're comparing two versions of `sqrt-stream`:

### ✅ Original Version (with local variable):

```scheme
(define (sqrt-stream x)
  (define guesses
    (cons-stream 1.0
                 (stream-map (lambda (guess)
                               (sqrt-improve guess x))
                             guesses)))
  guesses)
```

This uses a local variable `guesses` that refers to itself in its own definition.

This works because:
- The stream is built **once**
- Each new element depends on the previous one
- All parts of the stream share the same underlying structure

### ❌ Louis's Version (without local variable):

```scheme
(define (sqrt-stream x)
  (cons-stream 1.0
               (stream-map
                (lambda (guess) (sqrt-improve guess x))
                (sqrt-stream x))))
```

This seems simpler, but it has a **critical flaw**.

---

## 🔍 Why Alyssa Is Right: Redundant Computation

In Louis’s version:

```scheme
(stream-map f (sqrt-stream x))
```

Every time you call `(sqrt-stream x)` inside the recursive part, it creates a **new instance of the stream**, starting from the beginning.

So when you evaluate, say:

```scheme
(stream-ref (sqrt-stream 2) 5)
```

You end up recomputing the entire stream each time, like this:

- To compute the 5th guess, it calls `(sqrt-stream 2)` again → computes the 4th guess
- To compute the 4th guess, it calls `(sqrt-stream 2)` again → computes the 3rd guess
- And so on...

This leads to **exponential growth in computation**, similar to the naive recursive Fibonacci.

---

## 💡 Key Insight: Stream Sharing

The original version avoids this by defining the stream once and referring to it recursively via a **local variable** (`guesses`).

This allows:
- Each new element to be computed based on the **same shared stream**
- Previously computed values to be reused (no re-computation)

This is only possible if `delay` is **memoized** (i.e., remembers the result after first evaluation), which is what `memo-proc` provides.

---

## 🤔 What If `delay` Was Not Memoized?

If `delay` was implemented simply as:

```scheme
(define (delay exp) (lambda () exp))
```

Then every time you force a stream element, it would recompute the expression from scratch — even if it had already been evaluated before.

In that case:
- Even the original version with a local variable would **not benefit from sharing**
- Both versions would suffer from redundant computation
- So, **the two versions would behave similarly in efficiency**

✅ **Conclusion**:
- With **memoized delay**, the original version is more efficient.
- With **non-memoized delay**, both versions are equally inefficient.

---

## ✅ Summary

| Concept | With Memoization | Without Memoization |
|--------|------------------|---------------------|
| Louis’s version | ❌ Inefficient (recomputes stream each time) | ❌ Also inefficient |
| Alyssa’s version | ✅ Efficient (shares stream) | ❌ Inefficient |

---

## 💡 Final Thought

This exercise highlights the importance of:
- **Stream sharing** — avoid recomputing the same stream multiple times
- **Memoization** — essential for making lazy evaluation efficient

Without these, even elegant stream-based programs can become **exponentially slow**.
