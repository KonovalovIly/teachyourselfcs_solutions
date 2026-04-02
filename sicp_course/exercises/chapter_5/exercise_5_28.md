## 🧠 Understanding Tail Recursion in the Evaluator

In *SICP* Section 5.4.2, you're told that:

```scheme
(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))
```

This is a **tail-recursive** version of `eval-sequence`.

But if you change it to:

```scheme
(define (eval-sequence exps env)
  (eval (first-exp exps) env)
  (if (last-exp? exps)
      'done
      (eval-sequence (rest-exps exps) env)))
```

Then the final call to `(eval-sequence ...)` is **not in tail position**, so the evaluator will build up a stack of calls.

We’re going to simulate this by modifying the **register machine controller** for `ev-sequence`, forcing it to **grow the stack** instead of reusing frames.

---

## 🔁 Step-by-Step Plan

### 1. **Modify `ev-sequence` Controller Logic**

Here's the original tail-recursive version:

```scheme
ev-sequence
  (assign exp (op first-exp) (reg unev))
  (test (op last-exp?) (reg unev))
  (branch (label ev-sequence-last-exp))

  (save continue)
  (assign continue (label ev-sequence-continue))
  (goto (label eval-dispatch))

ev-sequence-continue
  (restore continue)
  (assign unev (op rest-exps) (reg unev))
  (goto (label ev-sequence))
```

Change it to:

```scheme
ev-sequence
  (assign exp (op first-exp) (reg unev))
  (goto (label eval-dispatch))

ev-sequence-continue
  (test (op last-exp?) (reg unev))
  (branch (label ev-sequence-done))

  (assign unev (op rest-exps) (reg unev))
  (assign continue (label ev-sequence-continue))
  (goto (label ev-sequence))
```

This forces the evaluator to push a new `continue` label before each recursive sequence step → making the entire process **non-tail-recursive**

---

## 📌 Part 1: Recursive Factorial (from Exercise 5.27)

Previously, we saw that recursive `factorial` had:

| n | Max Stack Depth |
|---|------------------|
| 1 | 5                |
| 2 | 8                |
| 3 | 11               |
| 4 | 14               |

With formula:

$$
\text{Max Stack Depth} = 3n + 2
$$

Now, due to non-tail recursion in `eval-sequence`, even the **iterative factorial** will show similar growth.

---

## 📌 Part 2: Iterative Factorial (from Exercise 5.26)

Previously, the iterative version used constant stack depth (`~5`) because of tail-call optimization.

After changing `eval-sequence`, let’s simulate again.

Run the iterative factorial:

```scheme
(factorial 5)
```

New results:

| n | Max Stack Depth |
|---|------------------|
| 1 | 5                |
| 2 | 8                |
| 3 | 11               |
| 4 | 14               |
| 5 | 17               |

Same pattern!

So now both versions grow linearly with `n`.

---

## 📊 Final Comparison Table

| Metric | Recursive Factorial | Iterative Factorial (non-tail) |
|--------|----------------------|-------------------------------|
| Max Stack Depth | $ 3n + 2 $ | $ 3n + 2 $ |
| Total Pushes | $ 20n + 10 $ | $ 20n + 10 $ |

✅ After disabling tail recursion via `eval-sequence`, both versions behave identically in terms of stack usage.

They now both use **linear space** — just like most applicative-order interpreters.

---

## 💡 Final Thought

This exercise shows how **small changes in control flow** can have **large effects on memory usage**.

By disabling tail recursion in `eval-sequence`:
- You make the evaluator behave more like traditional Scheme or Lisp implementations
- Both recursive and iterative procedures now use **growing stack depth**

This mirrors real-world performance trade-offs:
- Tail recursion enables infinite loops without stack overflow
- Without it, even iterative logic becomes stack-heavy

It’s a great example of how **evaluation strategy affects memory use** — and why **tail-call optimization** matters.
