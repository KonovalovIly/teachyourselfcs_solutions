## 🧠 Part 1: Implementing `unless` as a Derived Expression (Special Form)

If we're working in the **metacircular evaluator**, we can add `unless` as a new special form.

### 🔧 Step-by-Step Implementation

#### 1. **Define Syntax Predicates**

```scheme
(define (unless? exp) (tagged-list? exp 'unless))
(define (unless-condition exp) (cadr exp))
(define (unless-usual exp) (caddr exp))
(define (unless-exceptional exp) (cadddr exp))
```

Where:

```scheme
(define (tagged-list? exp tag)
  (and (pair? exp) (eq? (car exp) tag)))
```

#### 2. **Implement `eval-unless`**

This is how we evaluate an `unless` expression:

```scheme
(define (eval-unless exp env)
  (let ((condition (eval (unless-condition exp) env)))
    (if (true? condition)
        (eval (unless-exceptional exp) env)
        (eval (unless-usual exp) env))))
```

#### 3. **Install into Evaluator**

If you’re using data-directed dispatch from Exercise 4.3:

```scheme
(put 'eval 'unless unless? eval-unless)
```

Now your interpreter supports:

```scheme
(unless (= x 0)
        (display "x is non-zero")
        (display "x is zero"))
```

✅ This works fine — but it’s now **just another special form**, like `if`.

---

## 📌 Ben’s Viewpoint: Special Form Is Enough

Ben argues that `unless` doesn’t need lazy evaluation — just define it like `if`, as a **special form**.

Pros:
- Efficient
- Simple to implement
- Works correctly in applicative-order languages

Cons:
- Cannot be passed to or returned by higher-order procedures
- Not first-class; behaves differently than ordinary procedures

---

## 🧩 Alyssa’s Counterargument: First-Class Procedures Are Better

Alyssa wants `unless` to be a **first-class procedure**, so she can use it like any other function.

She proposes defining `unless` like this:

```scheme
(define (unless condition usual exceptional)
  (if condition
      exceptional
      usual))
```

Then define `factorial`:

```scheme
(define (factorial n)
  (unless (= n 1)
          (* n (factorial (- n 1))
          1))
```

But there's a problem in **applicative-order** Scheme:
- All arguments are evaluated before the function runs.
- So even if `condition` is true, `(factorial 0)` gets evaluated anyway → infinite recursion

So:

> ❌ **Unless cannot safely be defined as a procedure in applicative order.**

However...

---

## ✅ Alyssa’s Point: Unless Should Be a Procedure

Why?
Because only then can you do things like:

### 🔄 Use `unless` with Higher-Order Functions

Suppose you have a generic function:

```scheme
(define (filtered-map pred proc lst)
  (map (lambda (x)
         (if (pred x)
             (proc x)
             x))
       lst))
```

What if you want to write a version that maps **only when a condition is false**?

With `unless` as a **procedure**, you could write:

```scheme
(filtered-map (lambda (x) (even? x))
              (lambda (x) (* x 10))
              '(1 2 3 4 5))

;; With unless:
(filtered-map (lambda (x) (unless (even? x) #f #t)) ; equivalent to not
              (lambda (x) (* x 10))
              '(1 2 3 4 5))
```

This is **not possible** if `unless` is a special form — because you can't pass it as an argument to another function.

Thus, Alyssa has a point:
> You lose **composability** if `unless` isn’t a real function.

---

## 🛠️ How to Make `unless` Work in Applicative-Order Languages

You can simulate lazy evaluation manually using **delay/force**:

```scheme
(define (unless condition-proc usual-proc exceptional-proc)
  (if (condition-proc)
      (exceptional-proc)
      (usual-proc)))
```

Then define factorial like this:

```scheme
(define (factorial n)
  (unless (lambda () (= n 1))
          (lambda () (* n (factorial (- n 1)))
          (lambda () 1)))
```

This way:
- You wrap expressions in lambdas to delay their evaluation
- `unless` calls them only when needed

Now `unless` is a full **higher-order procedure** that can be used flexibly.

---

## 📊 Summary Table

| Feature | As Special Form | As Procedure |
|--------|------------------|--------------|
| Can Be Used Like `if` | ✅ Yes | ✅ Yes |
| Can Be Passed to Higher-Order Functions | ❌ No | ✅ Yes |
| Can Be Composed with Other Procedures | ❌ No | ✅ Yes |
| Requires Lazy Evaluation | ❌ No | ✅ Yes (or manual delay/force) |
| Example Use Case | Control flow inside body | Generic logic with `map`, `filter`, etc. |

---

## 💡 Final Thought

This exercise shows the tension between:

| Approach | Use Case | Limitation |
|---------|-----------|------------|
| Special Form (`unless`) | Good for simple control flow | Not composable |
| Procedure (`unless`) | Fully composable | Needs lazy evaluation or manual wrapping |

In **normal-order** languages (like the lazy evaluator in Section 4.1.6), `unless` would work fine as a procedure.

In **applicative-order**, you must either:
- Define `unless` as a **special form**
- Wrap all branches in lambdas to **simulate laziness**

---

## 🧪 Example: Using `unless` as a Function

Here’s a useful example of passing `unless` to a higher-order function.

### Define a Generalized Mapper

```scheme
(define (map-if predicate then-fn else-fn lst)
  (map (lambda (x)
         (if (predicate x)
             (then-fn x)
             (else-fn x)))
       lst))
```

Now suppose we define a variant using `unless`:

```scheme
(define (map-unless predicate usual exceptional lst)
  (map (lambda (x)
        (unless (predicate x)
                (usual x)
                (exceptional x)))
       lst))
```

This works **only if `unless` is a procedure** and respects lazy evaluation.

Example usage:

```scheme
(map-unless even?
            (lambda (x) (+ x 1))
            (lambda (x) x)
            '(1 2 3 4 5))
→ '(2 2 4 4 6)
```

This kind of abstraction is **not possible** if `unless` is a special form.

---

## ✅ Conclusion

| Statement | Verdict |
|----------|---------|
| Ben: “Just make `unless` a special form” | ✅ Valid — works for control flow |
| Alyssa: “But then you can’t compose it with higher-order procedures” | ✅ Correct — limits expressiveness |
| Best Compromise | Define `unless` as a procedure that takes thunks or uses `delay` and `force` | ✅ Supports both control flow and composition |
