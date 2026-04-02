## 🧠 Understanding the Problem

This exercise explores how **evaluation order** affects whether recursive procedures using special forms like `unless` can work correctly.

Let’s analyze both cases:

---

## 🔍 Part (a): Applicative-Order Evaluation

In **applicative-order**, all arguments to a procedure are evaluated **before** the procedure body is entered.

So when evaluating:

```scheme
(factorial 5)
→ (unless (= 5 1) (* 5 (factorial 4)) 1)
→ since 5 ≠ 1, return (* 5 (factorial 4))
```

But here's the problem:
> ❗ The expression `(* 5 (factorial 4))` must be **evaluated immediately** because `unless` is a **procedure**, not a special form.

That means:
- Even though `unless` returns `usual-value` only if `condition` is false,
- In applicative order, **both branches are evaluated anyway** before `unless` is called.

So:
```scheme
(unless (= n 1)
        (* n (factorial (- n 1))
        1)
```

Before `unless` is even called:
- `(* n (factorial (- n 1)))` is evaluated
- That means `factorial` will be called recursively **immediately**

This leads to **infinite recursion**.

Even for `n = 1`, it tries to compute `(* 1 (factorial 0))` before calling `unless`.

So:

> ❌ **The definition fails under applicative-order evaluation** — it results in infinite recursion.

---

## ✅ Part (b): Normal-Order Evaluation

In **normal-order**, expressions are passed unevaluated until needed.

If `unless` were a **special form** (like `if`), and used **normal-order evaluation**, then:

```scheme
(unless condition usual-value exceptional-value)
```

would behave like:

```scheme
(if (not condition)
    usual-value
    exceptional-value)
```

And crucially:
- Only one of `usual-value` or `exceptional-value` would be evaluated — the one that is actually needed.

So in normal-order:

```scheme
(factorial 5)
→ (unless #f (* 5 (factorial 4)) 1)
→ evaluate only `(* 5 (factorial 4))`
→ now evaluate `(factorial 4)`
→ and so on...

At each step, only the needed branch is evaluated.

Eventually:
```scheme
(factorial 1)
→ (unless #t (* 1 (factorial 0)) 1)
→ evaluate `1`, return 1
```

No infinite recursion!

✅ So:

> ✔️ **Yes**, the definition works in a **normal-order** language, assuming `unless` is a **special form**.

---

## 📌 Summary

| Feature | Applicative-Order | Normal-Order |
|--------|--------------------|-------------|
| Evaluation Strategy | Evaluate args first | Delay evaluation until needed |
| Behavior of `unless` as Procedure | ❌ Fails due to infinite recursion |
| Behavior of `unless` as Special Form | N/A (requires interpreter support) | ✅ Works correctly |

---

## 💡 Final Notes

This exercise highlights a core idea from *SICP*:

> ⚠️ **Evaluation order matters**.

Some constructs that look fine in **normal-order** languages fail in **applicative-order** ones unless they're implemented as **special forms** with their own evaluation rules.

This also relates to the implementation of control structures like `if`, `cond`, and custom conditionals such as `unless`.

---

## 🧩 Optional: Implementing `unless` as a Special Form

If you're using a metacircular evaluator (from Chapter 4), you could implement `unless` as a special form:

```scheme
(define (unless? exp) (tagged-list? exp 'unless))

(define (unless-condition exp) (cadr exp))
(define (unless-usual exp) (caddr exp))
(define (unless-exceptional exp) (cadddr exp))

(define (eval-unless exp env)
  (let ((condition (eval (unless-condition exp env)))
    (if (true? condition)
        (eval (unless-exceptional exp) env)
        (eval (unless-usual exp) env))))

(put 'eval 'unless unless? eval-unless)
```

Now `unless` behaves like `if` — and won't evaluate unnecessary branches.

This makes `factorial` work even in **applicative-order** interpreters.

---

## 📊 Example: Why It Fails in Applicative Order

```scheme
(factorial 1)
→ (unless #t (* 1 (factorial 0)) 1)
→ But in applicative order, both:
   - (* 1 (factorial 0))
   - 1
are fully evaluated before `unless` runs.

So it evaluates `(* 1 (factorial 0))` → which calls `factorial 0` → `factorial -1` → etc.

Infinite loop.
```
---

## ✅ Summary Table

| Case | Definition | Evaluation Order | Works? | Why |
|------|------------|------------------|--------|-----|
| Applicative-Order + `unless` as Procedure | ❌ No | Arguments evaluated early | Infinite recursion |
| Normal-Order + `unless` as Special Form | ✅ Yes | Lazy evaluation | Only needed branch evaluated |
| Applicative-Order + `unless` as Special Form | ✅ Yes | Only one branch evaluated | Same behavior as `if` |
