## 🧠 Understanding the Simulator

The simulator from *SICP* Section 5.2 supports a message-passing interface:

```scheme
(define fib-machine (make-machine ...))
(fib-machine 'trace-on)
(fib-machine 'trace-off)
(fib-machine 'execute) ; runs controller
```

We're to extend it with a new feature:
- Print each instruction as it's about to be executed
- Controlled by trace state: on or off

This helps you **debug complex machines** by seeing exactly what instructions are being run.

---

## 🔧 Step-by-Step Implementation Plan

We’ll make changes in two places:
1. The **machine definition**
2. The **execution loop**

---

### 1. **Add Tracing State to Machine Model**

Modify `make-machine` to track whether tracing is enabled.

In your machine constructor:

```scheme
(define (make-machine ops controller-text)
  (let ((machine (make-base-machine ...)))
    (set-register-contents! machine 'trace-flag #f) ; default: tracing off
    (assemble controller-text machine ops)
    machine))
```

Then define procedures for turning tracing on/off.

---

### 2. **Define `trace-on` and `trace-off` Messages**

Update the machine's message-passing interface:

```scheme
(set! (machine 'trace-on)
     (lambda () (set-register-contents! machine 'trace-flag #t)))

(set! (machine 'trace-off)
     (lambda () (set-register-contents! machine 'trace-flag #f)))

(set! (machine 'get-trace-flag)
     (lambda () (get-register-contents machine 'trace-flag)))
```

Now we can toggle tracing at runtime.

---

### 3. **Instrument Execution Loop to Print Instructions**

Inside the execution logic (in the internal `execute` function), we need to print the instruction if tracing is on.

Here’s how you’d modify the inner loop:

```scheme
(define (execute machine)
  (let loop ()
    (if (empty-instruction? machine)
        'done
        (let ((insts (get-next-instruction machine)))
          (if ((machine 'get-trace-flag))
              (begin
                (display "Tracing: ")
                (write insts)
                (newline)))
          ((machine 'inc-instruction-count)) ; from Exercise 5.15
          (execute-insts insts machine)
          (loop)))))
```

Where:
- `(get-next-instruction machine)` gets the next instruction
- If `trace-flag` is true → print the instruction
- Then execute it

This way, users can turn tracing on and off dynamically.

---

## 📌 Example Usage

Define a simple factorial machine:

```scheme
(define fact-machine
  (make-machine
   (list (list '= =) (list '* *) (list '- -))
   '(
     (assign continue (label fact-done))

     fact-loop
     (test (op =) (reg n) (const 1))
     (branch (label base-case))

     (save continue)
     (save n)
     (assign n (op -) (reg n) (const 1))
     (assign continue (label fact-loop))
     (goto (label fact-loop))

     base-case
     (assign val (const 1))
     (goto (reg continue))

     fact-done)))
```

Now simulate it:

```scheme
(set-register-contents! fact-machine 'n 5)
(fact-machine 'trace-on)
(start fact-machine)

→ Output:
Tracing: (assign continue (label fact-done))
Tracing: (test (op =) (reg n) (const 1))
Tracing: (branch (label base-case))
Tracing: (save continue)
...
```

Then:

```scheme
(fact-machine 'trace-off)
(start fact-machine)
→ No output
```

---

## 🎯 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Add instruction tracing to register machine |
| Strategy | Add trace flag; print instruction if flag is on |
| Key Registers | `trace-flag` |
| New Messages | `'trace-on`, `'trace-off` |
| Real-World Use | Debugging low-level control flow |

---

## 💡 Final Thought

This exercise shows how to build **observability into a low-level system**.

By adding just a few lines:
- You get powerful insight into execution flow
- You can debug complex machines step-by-step
- And toggle tracing without modifying core behavior

It mirrors real-world tools like:
- CPU instruction tracers
- VM profilers
- Assembly-level debuggers

And prepares you for more advanced profiling features like those in Exercises 5.17 and 5.18.
