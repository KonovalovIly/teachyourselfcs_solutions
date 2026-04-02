## 🧠 Understanding the Problem

The goal is to make the evaluator support:

```scheme
(compile-and-run '(define (factorial n) ...))
→ compiles and installs factorial in the global environment

(factorial 5)
→ returns 120
```

This means integrating the compiler with the interpreter at runtime.

To do this, we must:
- Modify the **evaluator's primitive operation set**
- Implement a way to **compile expressions on demand**
- Store the compiled closure under the defined name in the environment

---

## 🔁 Step-by-Step Plan

We’ll add a new primitive called `compile-and-run` that:
1. Accepts a quoted Scheme expression
2. Compiles it using the compiler from *Section 5.5*
3. Evaluates any `define`s by installing the compiled closure in the global environment

Here’s how to do it cleanly.

---

## 🛠️ Part 1: Add `compile-and-run` as a Primitive

In your evaluator machine definition, add this operation:

```scheme
(list 'compile-and-run
      (lambda (exp)
        (let ((compiled-code (compile exp 'val 'next)))
          (start-evaluator-with compiled-code))))
```

Then define `start-evaluator-with` to execute the compiled code and update the environment.

---

## 📌 Part 2: Implement `compile-and-run` Controller Logic

Add a new entry point to the evaluator controller:

```scheme
ev-compile-and-run
  (assign continue (label compile-done))
  (save continue)
  (save env)

  (assign exp (op cadr) (reg val)) ; get the quoted expression
  (assign val (op compile-procedure-body) (reg exp) (reg env))
  (restore env)
  (restore continue)
  (assign proc (reg val))
  (goto (reg continue))
```

Now extend the evaluator to recognize this label:

```scheme
(test (op tagged-list?) (reg exp) (const compile-and-run))
(branch (label ev-compile-and-run))
```

This allows the evaluator to detect `(compile-and-run ⟨expr⟩)` and compile it dynamically.

---

## 🎯 Part 3: Compile and Install Definitions

Modify the evaluator to handle `define`s inside `compile-and-run`.

When compiling a `define`, we want to:
- Create a compiled closure
- Install it in the global environment under its name

### Example Compiled Code for `(define (f x) (+ x x))`

The compiler generates something like:

```scheme
(assign val (op make-compiled-procedure) (label f-entry) (reg env))

f-entry
  (assign env (op compiled-procedure-env) (reg proc))
  (assign exp (op lookup-variable-value) (const x) (reg env))
  (assign arg1 (reg exp))
  (assign exp (op lookup-variable-value) (const x) (reg env))
  (assign arg2 (reg exp))
  (assign val (op +) (reg arg1) (reg arg2))
  (goto (reg continue))
```

We then install this in the global environment under `'f'`

---

## 🧪 Part 4: Test It Out

Once integrated, test the system interactively in the evaluator:

### Enter ECE REPL

```scheme
(start eceval)
```

Then type:

```scheme
(compile-and-run '(define (factorial n)
                   (if (= n 1)
                       1
                       (* n (factorial (- n 1)))))
```

This should return:

```scheme
ok
```

Then call:

```scheme
(factorial 5)
→ 120
```

✅ If it works, you’ve successfully extended the evaluator to compile and install procedures at runtime!

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Allow evaluator to compile and install procedures at runtime |
| Strategy | Add `compile-and-run` primitive |
| Key Change | Compiler now callable from interpreted code |
| Required Components | Compiler, evaluator interface, environment manipulation |
| Real-World Use | Like dynamic compilation in interpreters |
| Performance Impact | Slower than pre-compiled code, but more flexible |
| Integration Point | In evaluator’s dispatch logic |

---

## 💡 Final Thought

This exercise shows how to build a **self-hosting compiler-interpreter hybrid system**.

By adding just one primitive:
- You gain the power to **compile arbitrary Scheme code at runtime**
- And seamlessly integrate it into the interpreter's world

This mirrors real-world systems like:
- Racket's interaction between JIT and interpreter
- Python's `__import__` and `exec`
- JavaScript engines that compile functions on the fly

And gives deep insight into how modern language runtimes manage both **interpreted** and **compiled** code.
