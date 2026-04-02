## 🧠 Understanding the Two Factorial Versions

### 🔁 Recursive `factorial-alt`
This is a **tree-recursive** process:
- Each call to `(factorial-alt (- n 1))` builds up on the stack
- The multiplication happens **after** the recursive call returns
- So, it's **not tail-recursive**
- Requires stack depth proportional to `n`

### 🔄 Iterative `factorial`
This uses an **explicit loop** via tail recursion:
- Accumulates result in `product` and `counter`
- All operations happen **before** the recursive call
- Tail-recursive → no growing stack usage
- Stack depth remains constant

So:
| Feature | `factorial-alt` | `factorial` |
|--------|------------------|--------------|
| Type | Tree recursion | Tail recursion |
| Stack Depth | Linear in `n` | Constant |
| Memory Use | High – grows with `n` | Low – constant |
| Speed | Slower for large `n` | Faster |

---

## 🔧 Step-by-Step: Compiling `factorial-alt`

We assume you're using the Scheme compiler described in *SICP* Section 5.5.

Let’s compile:

```scheme
(define (factorial-alt n)
  (if (= n 1)
      1
      (* n (factorial-alt (- n 1))))
```

Using:

```scheme
(compile '(define (factorial-alt n)
           (if (= n 1)
               1
               (* n (factorial-alt (- n 1))))
         'val
         (make-labels))
```

### 🧾 Compiled Code Highlights

The generated code will look something like this (simplified):

```scheme
(assign val (op make-compiled-procedure) ...)

entry-point-factorial-alt
  (assign env (op compiled-procedure-env) (reg proc))
  (save continue)
  (save env)

  ;; Evaluate predicate (= n 1)
  (assign exp (op lexical-address-lookup) (const (lexical n)))
  (assign val (op =) (reg val) (const 1))
  (test (reg val))
  (branch (label base-case))

  ;; Recursive case
  (save val) ; Save n before evaluating factorial-alt(- n 1)

  (assign exp (op -) (reg val) (const 1))
  (assign argl (op list) (reg exp))
  (assign proc (op lookup-variable-value) (const factorial-alt) (reg env))
  (assign continue (label after-call))
  (goto (label apply-dispatch))

after-call
  (assign arg1 (reg val))
  (restore arg2) ; previously saved n
  (assign val (op *) (reg arg1) (reg arg2))
  (goto (reg continue))

base-case
  (assign val (const 1))
  (goto (reg continue))
```

### ⚙️ Key Observations
- This version saves `n` before making the recursive call
- Then multiplies it **after** the return
- So each multiplication must wait for the recursive call
- This leads to **stack growth**

---

## 📌 Compare with Iterative Version

The iterative version compiles to code where:
- The procedure calls itself as the last operation
- No need to save values across the call
- `continue`, `env`, etc., are preserved only once

Compiled code would look like:

```scheme
(assign val (op make-compiled-procedure) ...)

entry-point-factorial
  (assign env (op compiled-procedure-env) (reg proc))
  (assign continue (reg val))

  ;; Apply iter with product=1 and counter=1
  (assign proc (op lookup-variable-value) (const iter) (reg env))
  (assign val (op list) (const 1) (const 1))
  (goto (label apply-dispatch))
```

Then inside `iter`:

```scheme
(entry-point-iter)
  (test if counter > n)
  (branch (label base-case))

  ;; Compute new product and counter
  (assign product (op *) (reg counter) (reg product))
  (assign counter (op +) (reg counter) (const 1))
  (goto (label entry-point-iter))
```

Because this is tail-recursive:
- It doesn't grow the stack
-### ✅ **Exercise 5.33 — SICP**
> Compare two recursive definitions of `factorial`:

#### Original Version (Tail-recursive style):
```scheme
(define (factorial n)
  (define (iter product counter)
    (if (> counter n)
        product
        (iter (* counter product) (+ counter 1))))
  (iter 1 1))
```

#### Alternative Version:
```scheme
(define (factorial-alt n)
  (if (= n 1)
      1
      (* n (factorial-alt (- n 1))))
```

You are asked:
- To **compile both versions**
- Compare the resulting machine code
- Explain any differences
- Determine which version runs more efficiently

Let’s walk through this step-by-step.

---

## 🧠 Understanding the Two Versions

### 🔹 `factorial`
- Uses an **iterative recursion pattern**, implemented via tail calls
- Accumulator-based: multiplies and increments in each call
- Designed to be compiled into **tail-recursive code**

### 🔹 `factorial-alt`
- Classic **tree recursion**: computes `(factorial-alt (- n 1))`, then multiplies by `n`
- Not tail-recursive: multiplication happens **after** recursive call returns
- Requires saving/restoring intermediate values

This difference affects how the **compiler generates instructions**, especially regarding register usage, stack operations, and control flow.

---

# ✅ Part 1: Compile Both Procedures

We’ll assume you're using the compiler from *Section 5.5* of *SICP*.

Here’s a simplified view of what the compiler would generate for each.

---

## 🔁 Compiled Code for `factorial`

The inner loop is tail-recursive:

```scheme
(iter 1 1)
→ if counter > n → return product
→ else → iter(* counter product) (+ counter 1)
```

### 📌 Compiled Instruction Snippet (simplified):

```scheme
(assign continue (label fact-done))
(save continue)
(assign val (const 1))
(assign arg1 (reg val)) ; product
(assign arg2 (const 1)) ; counter
(goto (label fact-iter))

fact-iter
  (test (op >) (reg arg2) (reg n))
  (branch (label base-case))

  (assign product (op *) (reg arg1) (reg arg2))
  (assign counter (op +) (reg arg2) (const 1))
  (assign arg1 (reg product))
  (assign arg2 (reg counter))
  (goto (label fact-iter))

base-case
  (assign val (reg product))
  (goto (reg continue))
```

✅ This uses **minimal stack space** due to tail recursion.

---

## 🛠️ Compiled Code for `factorial-alt`

Recursive definition:

```scheme
(factorial-alt n)
→ if n = 1 → 1
→ else → * n (factorial-alt (- n 1))
```

Since the multiplication happens **after** the recursive call, it's **not tail-recursive**

### 📌 Compiled Instruction Snippet (simplified):

```scheme
fact-alt
  (test (op =) (reg n) (const 1))
  (branch (label base-case))

  (save continue)
  (save n)

  (assign continue (label after-fact))
  (assign n (op -) (reg n) (const 1))
  (goto (label fact-alt))

after-fact
  (restore n)
  (restore continue)
  (assign val (op *) (reg n) (reg val))
  (goto (reg continue))

base-case
  (assign val (const 1))
  (goto (reg continue))
```

This version **uses the stack heavily**, because it must remember:
- The value of `n` at each level
- The `continue` label for later multiplication

---

# 📊 Comparison Table

| Feature | `factorial` (tail-recursive) | `factorial-alt` |
|--------|------------------------------|------------------|
| Recursive Style | Tail-recursive | Tree-recursive |
| Stack Usage | Constant (no growth with `n`) | Linear in `n` |
| Number of Pushes | Linear in `n`, but minimal |
| Tail Call Optimization | ✅ Yes – reuses stack frame |
| Multiplication Timing | Before recursive call | After recursive call |
| Register Usage | Optimized: no need to save/restore |
| Performance | Faster for large `n` |
| Real-World Use | Like efficient loops | Like naive recursive functions |

---

## 💡 Why `factorial-alt` Is Less Efficient

Because the multiplication happens **after** the recursive call:
- Each recursive call must be saved on the stack
- The system can’t reuse the current frame
- So every call increases stack depth

Whereas in the iterative version:
- All computation happens before recursion
- Frame state is reused
- No need to preserve registers across recursive calls

This mirrors real-world performance differences between:
- Tail-recursive procedures
- Tree-recursive ones

And explains why compilers **favor tail-call optimization**.

---

## 🎯 Final Answer Summary

| Question | Answer |
|---------|--------|
| Do the compiled versions differ? | ✅ Yes – `factorial-alt` requires extra saves/restores |
| Which one executes more efficiently? | ✅ `factorial` – constant stack depth vs linear |
| Why is `factorial-alt` slower? | ❌ Not tail-recursive – needs to multiply after recursion |
| Can the compiler optimize it? | ❌ No – not without restructuring the procedure |
| Key Insight | ✅ Evaluation order and tail recursion matter deeply |
