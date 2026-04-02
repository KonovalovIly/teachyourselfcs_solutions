## 🧠 Step-by-Step Implementation Plan

We’ll implement this as a new special form in the logic programming system from *SICP* Section 4.4.

There are two parts:

1. **Define the `unique` special form and its handling**
2. **Implement the procedure `uniquely-asserted`, which evaluates it**

Let’s walk through both.

---

## 🔧 Part 1: Define the Special Form

In the evaluator (`qeval`), we need to handle expressions tagged with `'unique`.

Add to your dispatch table:

```scheme
(put 'qeval 'unique uniquely-asserted)
```

Then define:

```scheme
(define (uniquely-asserted contents frame-stream)
  (simple-stream-flatmap
   (lambda (frame)
     (let ((matching-frames (qeval (contents-the-query contents) frame)))
       (if (singleton-stream? matching-frames)
           (singleton-stream frame) ; keep original frame
           the-empty-stream)))
   frame-stream))
```

Where:
- `contents-the-query` is `(cadr contents)` — the inner query
- We use `simple-stream-flatmap` to apply this check across all frames
- For each frame, we ask: Does the query return **exactly one result**?

If yes → keep the frame
If no → eliminate it

Now define helper functions.

---

## 🛠️ Helper Definitions

### 1. **Check for Singleton Stream**

```scheme
(define (singleton-stream? s)
  (and (not (stream-null? s))        ; at least one element
       (stream-null? (stream-cdr s)))) ; and no more than one
```

### 2. **Extract the Query from `unique` Expression**

```scheme
(define (contents-the-query unique-expr)
  (cadr unique-expr)) ; e.g., (unique (job ?x (computer wizard))) → (job ?x (computer wizard))
```

### 3. **Stream Filter Using `singleton-stream?`**

For each frame in the input stream:
- Run the query under that frame
- If it returns **exactly one result**, include the frame in the output
- Else, discard it

This mirrors how `not` works in the system:
- It filters out frames where the inner query returns non-empty results

Here, we filter out frames where the inner query has **more than one or zero** matches.

---

## 📌 Part 2: Example Queries

Once implemented, you can run queries like:

### ✅ Query 1: Unique Jobs

```scheme
(unique (job ?x (computer wizard)))
→ ((job (Ben Bitdiddle) (computer wizard)))
```

Because only Ben has that job.

But:

```scheme
(unique (job ?x (computer programmer)))
→ ()
```

Because multiple people have that job.

---

### ✅ Query 2: Who Supervises Exactly One Person?

```scheme
(and (supervisor ?boss ?person)
     (unique (supervisor ?boss ?someone)))
```

This asks:
- Find all bosses who supervise someone
- And ensure they supervise **only one** person

Example output:

```scheme
((supervisor (Hacker Alyssa P.) (Reasoner Louis))
 (unique (supervisor (Hacker Alyssa P.) ?someone)))
→ Only includes Alyssa if she supervises exactly one person

;; Result might be:
(((boss (Alyssa P. Hacker)) (person (Reasoner Louis))))
```

So you get a list of supervisors who manage only one subordinate.

---

## 🧪 Optional: Test Cases

| Query | Behavior |
|-------|----------|
| `(unique (job ?x (computer wizard)))` | Returns frame where `?x = (Ben Bitdiddle)` |
| `(unique (job ?x (computer programmer)))` | Returns empty stream |
| `(and (job ?x ?j) (unique (job ?y ?j)))` | Lists all jobs held by only one person, and who holds them |

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Implement a special form `unique` that succeeds only when exactly one match exists |
| Strategy | Use `qeval` to get stream of results; check if it's singleton |
| Key Tools | `stream-flatmap`, `qeval`, `singleton-stream?` |
| Real-World Analogy | Like SQL’s `HAVING COUNT(*) = 1` |
| Use Case | Filtering queries based on uniqueness constraints |

---

## 💡 Final Thought

This exercise shows how to build **higher-level logical constraints** into a query system.

By defining `unique`, you gain the power to:
- Express **"only one"** conditions
- Filter results based on **how many** answers exist

It's a powerful extension to any logic engine — especially useful in:
- Validating database integrity
- Enforcing business rules
- Exploring rare or unique patterns

And best of all, it builds on existing tools like `qeval` and streams — showing how extensible declarative systems can be.
