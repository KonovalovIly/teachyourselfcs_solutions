## 🧠 Understanding Normal-Order Evaluation

In **applicative-order evaluation** (default in most languages), arguments are evaluated before applying a procedure.

In **normal-order evaluation** (used in lazy languages like Haskell or the lazy Scheme interpreter in Section 4.2):
- Arguments are **not evaluated** until used inside the body
- They are passed as **unevaluated expressions**
- Only forced when actually referenced

So for example:

```scheme
(define (p) (p))
(define (test x y) x)

(test 0 (p)) ; → returns 0 in normal order
```

Because `(p)` is never evaluated.

We’ll implement this behavior in the register machine evaluator.

---

## 🔁 Step-by-Step Plan

To convert the evaluator to **normal-order**:
1. Modify the way arguments are collected during application
2. Wrap unevaluated arguments in **thunks** using `delay-it`
3. Update `eval` to not evaluate operator and operands immediately
4. Add support for `force-it` when evaluating variables or applying procedures

Let’s go through each change carefully.

---

## 🛠️ Part 1: Define Thunk Operations

Add these primitive operations:

```scheme
(list 'delay-it (lambda (exp env) (list 'thunk exp env)))
(list 'thunk? (lambda (obj) (tagged-list? obj 'thunk)))
(list 'thunk-exp cadr)
(list 'thunk-env caddr)
(list 'evaluated-thunk? (lambda (obj) (tagged-list? obj 'evaluated-thunk)))
(list 'thunk-value cadr)
(list 'force-it (lambda (obj)
                  (if (thunk? obj)
                      (let ((result (actual-value (thunk-exp obj) (thunk-env obj))))
                    (set-car! obj 'evaluated-thunk result)
                    result)
                  obj)))
```

Where:
- A **thunk** is a list: `'(thunk ⟨exp⟩ ⟨env⟩)`
- An **evaluated thunk** becomes: `'(evaluated-thunk ⟨value⟩)`

---

## 📌 Part 2: Modify Application Logic

In the original applicative-order evaluator, we have:

```scheme
ev-application
  (save continue)
  (assign unev (op operands) (reg exp))
  (assign continue (label ev-appl-did-eval-operand))
  (assign proc (op lookup-variable-value) (reg fun) (reg env))
  (test (op primitive-procedure?) (reg proc))
  (branch (label primitive-apply))

  (test (op compound-procedure?) (reg proc))
  (branch (label compound-apply))

  (goto (label unknown-procedure-type))
```

For **normal-order**, we instead delay all operand evaluations.

Modify it to:

```scheme
ev-application
  (save continue)
  (assign unev (op operands) (reg exp))
  (assign fun (op operator) (reg exp))
  (assign proc (op eval) (reg fun) (reg env))
  (assign argl (op delay-args) (reg unev) (reg env))
  (goto (label apply-procedure))
```

Where `delay-args` builds a list of **thunks** for each operand.

---

## 🧮 Part 3: Implement `delay-args` as Primitive Operation

Define `delay-args` as an operation that takes an expression list and environment, and returns a list of **thunks**:

```scheme
(list 'delay-args
      (lambda (exps env)
        (define (loop exps)
          (if (null? exps)
              '()
              (cons (list 'thunk (car exps) env)
                    (loop (cdr exps)))))
        (loop exps))
```

Now, `(f (+ 1 2) (* 3 4))` will pass two unevaluated thunks to `f`.

---

## 🎯 Part 4: Modify Variable Lookup to Force Thunks

Change `lookup-variable-value` to force evaluation on demand.

```scheme
(list 'lookup-variable-value
      (lambda (var env)
        (let ((binding (lookup var env)))
          (if (eq? binding '*unbound*)
              (error "Unbound variable" var)
              (let ((val (binding-value binding)))
                (if (thunk? val)
                    (force-it val)
                    val)))))
```

Then define `force-it` as above.

---

## 📊 Summary Table

| Feature | Applicative Order | Normal Order |
|--------|--------------------|--------------|
| Argument Eval | Before apply | On-demand |
| Expression | Fully evaluated first | Passed as thunks |
| Support Needed | None | `delay-it`, `force-it`, `thunk?` |
| Performance | Faster if all args used | Better if some args unused |
| Real-World Use | Most functional languages | Lazy languages like Haskell |

---

## 💡 Final Thought

This exercise shows how to extend a low-level evaluator to support **lazy evaluation semantics**.

By modifying:
- How arguments are passed (`delay-args`)
- When they’re forced (`force-it`)
- And how variables are looked up

You transform the entire execution model from eager to lazy.

It mirrors real-world interpreters like:
- The lazy evaluator from Section 4.2
- Haskell’s call-by-need
- Stream-based systems

And gives you deep insight into how **evaluation strategy affects language design**.
