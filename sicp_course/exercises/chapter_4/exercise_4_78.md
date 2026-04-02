## 🧠 Understanding the Goal

In *SICP*, there are two main approaches to non-determinism:

| Approach | Mechanism | Behavior |
|---------|-----------|----------|
| **Stream-based (Section 4.4)** | Streams + pattern matching | Returns all results at once |
| **Non-deterministic (Section 4.3)** | `amb`, backtracking | Returns one result; use `try-again` for others |

You're asked to reimplement the query language using the **`amb` evaluator**, so that queries behave like logic puzzles:
- You ask `(job ?x (computer programmer))`
- It gives you one match
- Then you type `try-again` to get more

This is a major redesign — but many parts become simpler!

---

## 🔁 Step-by-Step Redesign

We’ll implement a simplified version of the query system inside the `amb` evaluator.

### 1. **Representing Facts**

Instead of a database of assertions, we define facts as Scheme expressions:

```scheme
(define (fact job '(Ben Bitdiddle) '(computer wizard)))
(define (fact job '(Alyssa P. Hacker) '(computer systems analyst)))
(define (fact job '(Louis Reasoner) '(computer programmer trainee)))
(define (fact supervisor '(Louis Reasoner) '(Ben Bitdiddle)))
```

But better yet — we'll just define a list of known people and their jobs.

```scheme
(define *people*
  '((Ben Bitdiddle computer wizard)
    (Alyssa P. Hacker computer systems analyst)
    (Louis Reasoner computer programmer trainee)
    (Cy D. Fect computer engineer)
    (Eva Lu Ator accounting chief accountant)))
```

Then write helper functions to extract data.

---

### 2. **Define Query Language Using `amb`**

Now define a basic query engine using `amb`.

#### Example: Find someone with a specific job

```scheme
(define (job x job)
  (define person (amb *people*))
  (require (equal? (cadr person) job))
  (set! x (car person)))
```

Wait — not quite right. Better:

```scheme
(define (query-job job)
  (let ((person (amb *people*)))
    (if (equal? (caddr person) job)
        (list 'job (car person) (cddr person))
        (fail))))
```

Now run:

```scheme
(query-job '(computer wizard))
→ (job (Ben Bitdiddle) (computer wizard))

try-again
→ No more values
```

Because only Ben has that job.

---

## 🛠️ Part 1: Implement Basic Queries in `amb`

Here’s how to represent the query:

```scheme
(job ?x (computer programmer))
```

As a procedure:

```scheme
(define (query-job job)
  (let ((person (amb *people*)))
    (require (equal? (cddr person) job))
    (car person)))

(query-job '(computer programmer trainee))
→ Louis Reasoner

try-again
→ Cy D. Fect

try-again
→ Eva Lu Ator ❌ Not applicable

So it finds only valid matches.

---

## 🧪 Part 2: Compare Stream-Based vs `amb` Behavior

Let’s look at key differences between the original and redesigned versions.

---

### 📌 Example 1: Multiple Matches

Original (stream-based):

```scheme
(job ?x (computer programmer trainee))
→ Louis Reasoner
→ Cy D. Fect
→ ...
```

With `amb`:

```scheme
(query-job '(computer programmer trainee))
→ Louis Reasoner

try-again
→ Cy D. Fect

try-again
→ No more values
```

✅ Same results — just returned one at a time.

---

### 📌 Example 2: Complex Queries with Unbound Variables

Suppose you ask:

```scheme
(job ?x ?y)
```

Where both variables are unbound.

Stream-based system:
- Returns all possible bindings for `?x` and `?y`

With `amb`:

```scheme
(define (query-job)
  (let ((person (amb *people*)))
    (list (car person) (cddr person))))
```

This will return each binding pair one at a time via `try-again`.

So again:
✅ Same logical results, different interface

---

### ⚠️ Where Behavior Differs

The real difference shows up when dealing with **partial information** or **filtering based on unbound variables**.

For example:

```scheme
(and (job ?x ?j) (lisp-value equal? ?j (computer . ?rest)))
```

In the stream-based system:
- This filters out any frame where `?j` doesn't start with `'computer'`
- Even if `?j` is unbound → wait until it's bound

In the `amb` version:
- If `?j` is unbound, `equal?` fails early
- Unless we delay evaluation — which we must do manually

Thus:

> ❗ In the `amb` evaluator, filtering too early leads to wrong failure

To fix this, wrap the filter in a check for variable binding:

```scheme
(define (query-computer-jobs)
  (let ((person (amb *people*)))
    (let ((job (cddr person)))
      (if (pair? job)
          (if (eq? (car job) 'computer)
              (car person)
              (fail))
          (fail)))))
```

Now only those with computer-related jobs are found.

---

## 📊 Summary Table

| Feature | Stream-Based (Section 4.4) | Non-Deterministic (`amb`) |
|--------|-----------------------------|----------------------------|
| Evaluation Strategy | All results at once via streams | One result at a time via `amb` |
| Interface | Declarative, pattern-based | Imperative, backtracking |
| Performance | Can be slow due to stream overhead | Fast for small/medium search spaces |
| Delayed Filtering | Built-in — waits for variables | Must be implemented manually |
| Real-World Analogy | Like SQL query returning all rows | Like Prolog-style querying with backtracking |

---

## 💡 Final Thought

Redesigning the query system using `amb` simplifies many aspects:
- You no longer need streams
- You don’t have to manage frame merging or filtering manually

But you lose some features:
- Stream-based operations like counting, summing, etc.
- More natural handling of partial bindings

This mirrors real-world trade-offs:
- Prolog uses backtracking (like `amb`)
- But cannot naturally express “all solutions” unless explicitly collected

It also highlights a key idea from programming language design:
> ⚠️ **Control flow affects semantics** — even when the logic is the same
