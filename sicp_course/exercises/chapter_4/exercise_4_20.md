## 🧠 Part (a): Implement `letrec` as a Derived Expression

We want to transform:

```scheme
(letrec ((var1 exp1) ... (varn expn)) body)
```

into:

```scheme
(let ((var1 '*unassigned*) ... (varn '*unassigned*))
  (set! var1 exp1)
  ...
  (set! varn expn)
  body)
```

This ensures all variables are bound before any of their expressions are evaluated — allowing mutual recursion.

---

### 🔧 Step-by-Step Implementation

#### 1. **Define Syntax Predicates**

```scheme
(define (letrec? exp) (tagged-list? exp 'letrec))

(define (letrec-bindings exp) (cadr exp))
(define (letrec-body exp) (cddr exp))
```

Where:

```scheme
(define (tagged-list? exp tag)
  (and (pair? exp) (eq? (car exp) tag)))
```

---

#### 2. **Transform `letrec` into Nested `let` + `set!`**

```scheme
(define (letrec->let exp)
  (let ((bindings (letrec-bindings exp))
        (body (letrec-body exp)))
    (let ((vars (map car bindings))
          (exps (map cadr bindings)))
      (make-let vars '*unassigned*
                 (append (map make-set! vars exps)
                         body)))))
```

Where helper functions are defined as:

```scheme
(define (make-let vars vals body)
  (cons 'let (cons (map list vars vals) body)))

(define (make-set! var exp)
  (list 'set! var exp))
```

So this transformation:

```scheme
(letrec ((even? (lambda (n) (if (= n 0) true (odd? (- n 1))))
         (odd?  (lambda (n) (if (= n 0) false (even? (- n 1)))))
  ⟨body⟩)
```

Becomes:

```scheme
(let ((even? '*unassigned*)
      (odd? '*unassigned*))
  (set! even? (lambda (n) (if (= n 0) true (odd? (- n 1))))
  (set! odd?  (lambda (n) (if (= n 0) false (even? (- n 1))))
  ⟨body⟩)
```

Now both `even?` and `odd?` can safely reference each other.

---

### ✅ Install It in the Evaluator

If you're using data-directed dispatch from Exercise 4.3:

```scheme
(put 'eval 'letrec letrec? eval-letrec)

(define (eval-letrec exp env)
  (eval (letrec->let exp) env))
```

Now your evaluator supports `letrec`.

---

## 📊 Part (b): Environment Diagrams — `letrec` vs `let`

Louis Reasoner thinks that `let` is sufficient for defining recursive or mutually recursive procedures.

But there’s a key difference between:

```scheme
(letrec ((even? ...) (odd? ...)) ...)
```

and:

```scheme
(let ((even? ...) (odd? ...)) ...)
```

Let’s illustrate this by evaluating:

```scheme
(f 5)
```

where `f` is defined as:

```scheme
(define (f x)
  (letrec ((even? (lambda (n)
                    (if (= n 0)
                        true
                        (odd? (- n 1))))
           (odd? (lambda (n)
                   (if (= n 0)
                       false
                       (even? (- n 1)))))
    (even? x)))
```

### 🟩 Environment Diagram Using `letrec`

```
global env
   |
   ↓
[f] → parameters: x
       → body: letrec with even? and odd?

When entering f with x = 5:
   create new frame with x = 5

Then evaluate the letrec:
   bind even? and odd? to '*unassigned*

Create inner environment frame:
   [even? = *unassigned*, odd? = *unassigned*]

Evaluate set! expressions:
   even? → lambda that calls odd?
   odd? → lambda that calls even?

Both lambdas now see each other via the same environment.

Final evaluation:
   (even? 5) → evaluates recursively → returns false
```

✅ **Behavior**: Works correctly because both functions share the same environment where they’re defined.

---

### 🟥 What Happens If We Use `let` Instead?

Change `letrec` to `let`:

```scheme
(define (f x)
  (let ((even? (lambda (n) (if (= n 0) true (odd? (- n 1))))
        (odd?  (lambda (n) (if (= n 0) false (even? (- n 1)))))
    (even? x)))
```

Now try to evaluate `(f 5)`.

#### ❌ Problem: Evaluation Order

In `let`, **all right-hand sides are evaluated in the outer environment**, before any assignments occur.

So:
- When evaluating `(lambda (n) (odd? ...))`, `odd?` hasn’t been defined yet
- You get an error: **"Unassigned variable: odd?"**

#### Environment Structure

```
global env
   |
   ↓
[f] → x = 5

When entering let:
   Evaluate even? body first → uses odd?
   But odd? has not been defined yet!
```

So the lambdas don't see each other — mutual recursion fails.

---

## 🧮 Summary

| Feature | Description |
|--------|-------------|
| Goal | Implement `letrec` as a derived expression |
| Strategy | Transform `letrec` into `let` + `set!` |
| Key Idea | All variables are declared first, then assigned — so lambdas can refer to each other |
| Transformation | Replace with `let` binding all vars as unassigned, then assign them in sequence |
| Final Definition | ```(define (letrec->let exp) (let ((vars (map car (letrec-bindings exp))) (exps (map cadr (letrec-bindings exp))) (body (letrec-body exp))) (make-let vars '*unassigned* (append (map make-set! vars exps) body)))``` |

---

## 📌 Louis’s Mistake

Louis says:
> “If you don’t like internal definitions, just use `let`.”

But he's wrong:
- In `let`, all expressions are evaluated in the outer environment
- So mutual references fail
- While in `letrec`, expressions are evaluated in an environment where all names are already bound (though possibly unassigned)

Thus, `letrec` enables **mutual recursion**, while `let` does not.

---

## 💡 Final Thought

This exercise shows how powerful syntactic transformations can be:
- You can add full support for **mutual recursion** without touching the core evaluator
- Just rewrite the code into equivalent forms that work under existing rules

It also illustrates why language design matters:
- `letrec` gives you safe, predictable scoping for recursive definitions
- While `let` leads to subtle bugs if misused
