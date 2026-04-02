## 🧠 Understanding Lazy Evaluation with Memoization

In a **lazy evaluator**, unevaluated expressions are wrapped in **thunks**.

- With **memoization**: A thunk is evaluated only once; its result is remembered.
- Without memoization: Each time you force a thunk, it re-evaluates the expression from scratch.

This difference can lead to **massive performance differences** for certain recursive or repeated computations.

---

## 🔁 Example Program That Is Slower Without Memoization

Here's a classic example:

```scheme
(define (fib n)
  (if (<= n 1)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))
```

Now define:

```scheme
(define x (fib 30))
```

Then evaluate `x` **twice**:

```scheme
x
x
```

### 💡 What Happens?

| Case | Behavior |
|------|----------|
| **With memoization** | First evaluation computes `x`, second one returns cached value instantly |
| **Without memoization** | Both evaluations recompute `fib(30)` from scratch — **dramatically slower**

So:
> ✅ This program runs **exponentially slower** without memoization.

Memoization ensures laziness doesn't come at the cost of performance.

---

## 📊 Part 2: Analyze `(square (id 10))` Interaction

Assume:

```scheme
(define count 0)

(define (id x)
  (set! count (+ count 1))
  x)
```

And:

```scheme
(define (square x) (* x x))
```

Let’s walk through what happens when we evaluate:

```scheme
(square (id 10))
```

We’ll consider two versions of the interpreter:
- One that **memoizes thunks**
- One that **does not memoize**

---

### 🟩 Case 1: **Memoized Lazy Evaluator**

#### Step-by-step:

1. Evaluate `(id 10)`:
   - It is passed as a **delayed argument** to `square`
   - So it's wrapped in a **memoized thunk**

2. Inside `square`:
   ```scheme
   (* x x)
   ```
   - `x` is forced the **first time**
     - `count` becomes `1`
   - Second use of `x` is just the **cached value**
     - `count` does **not** increase again

#### Final Results:

```scheme
;;; L-Eval input:
(square (id 10))
;;; L-Eval value: 100

;;; L-Eval input:
count
;;; L-Eval value: 1
```

✅ **With memoization**, `id` is called **once**

---

### 🟥 Case 2: **Non-Memoized Lazy Evaluator**

#### Step-by-step:

1. Evaluate `(id 10)`:
   - Passed as a delayed argument → stored as an **unmemoized thunk**

2. Inside `square`:
   ```scheme
   (* x x)
   ```
   - First `x`: Force the thunk → `count = 1`
   - Second `x`: Force the same thunk again → `count = 2`

Each access forces the thunk again!

#### Final Results:

```scheme
;;; L-Eval input:
(square (id 10))
;;; L-Eval value: 100

;;; L-Eval input:
count
;;; L-Eval value: 2
```

❌ **Without memoization**, `id` is called **twice**

---

## 📌 Summary Table

| Feature | Memoized Evaluator | Non-Memoized Evaluator |
|--------|---------------------|------------------------|
| Thunk behavior | Evaluated once, then remembered | Reevaluated every time |
| `square (id 10)` | Evaluates `id` once | Evaluates `id` twice |
| Result of `square` | 100 | 100 |
| Value of `count` after evaluation | 1 | 2 |

---

## 💡 Final Thought

This exercise shows the **critical importance of memoization** in lazy evaluation systems.

Even a simple operation like squaring a value that increments a counter can behave very differently depending on whether the system **remembers** the result of a thunk.

- With memoization: You get predictable, efficient behavior.
- Without memoization: Every access to a delayed value triggers recomputation — which may be **inefficient or even incorrect** if there are side effects.
