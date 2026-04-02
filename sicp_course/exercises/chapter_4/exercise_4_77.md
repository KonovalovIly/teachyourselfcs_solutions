## 🧠 Understanding the Problem

In the current system:

```scheme
(and (job ?x ?y) (lisp-value salary<? ?x ?boss))
```

The second clause uses `lisp-value`, which evaluates a Scheme predicate (`salary<?`) on the current frame.

But if `?x` or `?boss` is **unbound**, then:
- The predicate cannot be evaluated
- But the system tries anyway → returns **true** or **false** based on incomplete data

This leads to incorrect pruning of valid answers.

Similarly, `(not ⟨query⟩)` may fail simply because some variable in `⟨query⟩` hasn’t been bound yet.

So:
> ❌ Premature filtering causes **incorrect behavior**

We need to delay these operations until enough variables are bound to evaluate them safely.

---

## ✅ Solution Strategy: Delay Filtering Until Safe

We'll implement a **delayed filtering mechanism**, using the idea of attaching a **filtering promise** to each frame.

Each time a frame is extended (e.g., via rule application or assertion), we check if any pending promises can now be fulfilled.

If yes:
- Evaluate the filter
- If it fails, discard the frame
- If it succeeds, keep the frame and remove the promise

This way:
> ✅ We avoid filtering too early
> ✅ We still allow filtering as soon as possible

It's a balance between:
- Correctness: don’t apply constraints before variables are bound
- Efficiency: apply them as early as possible once safe

---

## 🔧 Step-by-Step Implementation Plan

### 1. **Modify Frame Structure to Include Pending Filters**

Instead of just storing variable bindings, extend the frame to include **pending filters**.

For example:

```scheme
(define (make-frame bindings)
  (list 'frame bindings '())) ; '()' = no pending filters

(define (frame-bindings frame) (cadr frame))
(define (frame-filters frame) (caddr frame))

(define (add-filter-to-frame frame filter-predicate)
  (cons 'frame (frame-bindings frame) (cons filter-predicate (frame-filters frame))))
```

Now, frames carry both variable bindings and pending filter checks.

---

### 2. **Delay Application of `not` and `lisp-value`**

When you encounter a `not` or `lisp-value` clause in a query:

- Check whether all required variables are currently **bound**
- If not, add a **filtering promise** to the frame
- If yes, evaluate immediately

Here’s how to modify `qeval` for `lisp-value`:

```scheme
(define (qeval-lisp-value exp frame-stream)
  (let ((predicate (cadr exp))
        (args (cddr exp)))
    (stream-flatmap
     (lambda (frame)
       (if (all-vars-bound? args frame)
           (if (apply (get-predicate predicate) (map (lambda (arg) (lookup-in-frame arg frame)) args))
               (singleton-stream frame)
               the-empty-stream)
           (singleton-stream (add-filter-to-frame frame (make-filter predicate args))))
     frame-stream))
```

Where:
- `all-vars-bound?` checks if all arguments to the predicate are already bound
- If not, attach a **filtering promise** to the frame

Do the same for `not`.

---

### 3. **Check Promises When Extending Frames**

Every time you create a new frame (e.g., during rule application or assertion matching), check if any pending filters can now be satisfied.

Here’s how to do that:

```scheme
(define (satisfy-filters frame)
  (define (check filter-list result)
    (if (null? filter-list)
        result
        (let ((filter (car filter-list)))
          (if (all-vars-bound? (filter-vars filter) frame)
              (let ((pred (filter-predicate filter))
                    (args (filter-vars filter)))
                (if (apply pred (map (lambda (var) (lookup-in-frame var frame)) args))
                    (check (cdr filter-list) result)
                    the-empty-stream))
              (check (cdr filter-list) (extend-frame-with-filter result filter)))))
  (check (frame-filters frame) frame))
```

Then wrap this into your stream processing logic.

---

## 📌 Example: Avoiding Premature Filter Failure

Suppose we have:

```scheme
(job ?x ?j)
(lisp-value equal? ?j (computer wizard))
```

Without delaying:
- First clause binds `?j = (computer wizard)`
- Second clause runs immediately, since `?j` is known
- So it works fine

But suppose we have:

```scheme
(job ?x ?j)
(lisp-value equal? ?j ?target-job)
```

And `?target-job` is unbound.

Without delay:
- Try to compare `?j` and `?target-job` → both unbound
- Fails, discards frame
- But `?target-job` may become bound later

With delayed filtering:
- Attach a filter: `(equal? ?j ?target-job)`
- Wait until both variables are bound
- Then run the test

✅ This ensures correct behavior even when variables are bound later.

---

## 🛠️ Supporting Functions

### Check if All Variables Are Bound

```scheme
(define (all-vars-bound? vars frame)
  (every? (lambda (var) (binding-in-frame var frame)) vars))
```

### Attach Filter to Frame

```scheme
(define (add-filter-to-frame frame pred vars)
  (list 'frame (frame-bindings frame)
        (cons (list pred vars) (frame-filters frame))))
```

### Extract Variable Bindings

```scheme
(define (lookup-in-frame var frame)
  (let ((val (assoc var (frame-bindings frame))))
    (if val
        (cdr val)
        '*unbound*)))

(define (binding-in-frame var frame)
  (lookup-in-frame var frame))
```

These utilities help determine if a variable is ready for use.

---

## 🧪 Sample Query That Would Fail Without Delay

```scheme
(and (job ?x ?j)
     (lisp-value equal? ?j ?target-job)
     (job ?target-job (computer wizard)))
```

Without delay:
- `?j` is bound, but `?target-job` is not
- Compare `?j` with unbound `?target-job` → predicate fails
- Discard frame

With delay:
- Attach filter: `(equal? ?j ?target-job)`
- Continue evaluating rest of query
- Later bind `?target-job = (computer wizard)`
- Now re-evaluate the filter
- It matches `?j = (computer wizard)` → keeps frame

✅ Now the system behaves correctly.

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Fix premature failure of `lisp-value` and `not` due to unbound variables |
| Core Idea | Delay filtering until all variables are bound |
| Key Change | Add support for **pending filters** in frames |
| Behavior | Same logical outcome, but more accurate |
| Real-World Analogy | Like deferring constraint checking until all fields are known |

---

## 💡 Final Thought

This exercise shows how subtle control flow and **partial information** can affect declarative systems.

By delaying the application of filters until all variables are known:
- You ensure **logical correctness**
- You avoid false failures
- And still maintain efficiency by applying filters as soon as they're safe

This mirrors real-world logic engines like Prolog or Datalog, where:
- Constraints are postponed until enough information is available
- Oracles or solvers track dependencies and trigger evaluation when ready

It’s a powerful technique for building robust, scalable logic-based systems.
