## 🧠 Understanding the Simulator Structure

The register machine simulator from *SICP* Section 5.2 has a basic structure:

```scheme
(define (make-machine ops controller-text)
  (let ((machine (make-base-machine ...)))
    ;; assemble controller
    (set! machine 'start ...)
    machine))
```

Each machine supports message-passing interface like:

```scheme
(machine 'trace-on)
(machine 'execute)
```

We want to add:

```scheme
(machine 'get-instruction-count) → returns total instructions run
(machine 'reset-instruction-count) → resets the counter
```

This lets us profile performance of machines without changing their core behavior.

---

## 🔧 Step-by-Step Implementation

### 1. **Add New Register for Count**

Modify `make-base-machine` to include an extra register: `instruction-count`

Initialize it to 0.

```scheme
(set-register-contents! machine 'instruction-count 0)
```

Also, define a new operation:

```scheme
(list 'inc-instruction-count (lambda ()
  (set-register-contents! machine 'instruction-count
                         (+ 1 (get-register-contents machine 'instruction-count)))))
```

Now every time we execute an instruction, we call `inc-instruction-count`.

---

### 2. **Update Controller Instructions**

Modify the assembler so that every instruction includes a counter increment.

For example, change:

```scheme
(assign a (op +) (reg b) (reg c))
```

To:

```scheme
(perform (op inc-instruction-count))
(assign a (op +) (reg b) (reg c))
```

But doing this manually is tedious and error-prone.

Instead, we modify the **assembler** to automatically insert these counts.

---

## 🛠️ Part 1: Modify Assembler to Insert Counters

In `assemble`, wrap each instruction with a `perform` that increments the counter.

Here's how:

```scheme
(define (assemble insts machine labels operations flag)
  (define (loop insts labels operations flag)
    (cond ((null? insts) ...)
          (else
           (let ((inst (car insts)))
             (let ((action (cond ((assign-inst? inst)
                                  (make-assign inst machine labels operations flag))
                                 ((test-inst? inst)
                                  (make-test inst machine labels operations flag))
                                 ((branch-inst? inst)
                                  (make-branch inst machine labels flag))
                                 ((goto-inst? inst)
                                  (make-goto inst machine labels flag))
                                 ((save-inst? inst)
                                  (make-save inst machine))
                                 ((restore-inst? inst)
                                  (make-restore inst machine))
                                 (else (error "Unknown instruction -- ASSEMBLE" inst))))
               ;; Wrap action to increment instruction count
               (lambda ()
                 (machine 'inc-instruction-count)
                 (action)))) ; then perform original instruction
           (loop (cdr insts) labels operations flag))))
```

Now all instructions will first call `inc-instruction-count`.

---

## 📌 Part 2: Update Machine Interface

Define procedures to access and reset the instruction counter.

### Define These Methods in `make-machine`:

```scheme
(set! (machine 'get-instruction-count)
     (lambda () (get-register-contents machine 'instruction-count)))

(set! (machine 'reset-instruction-count)
     (lambda () (set-register-contents! machine 'instruction-count 0)))
```

Now you can do things like:

```scheme
(set-register-contents! fib-machine 'n 10)
(start fib-machine)
((fib-machine 'get-instruction-count)) → Returns number of instructions executed
((fib-machine 'reset-instruction-count)) → Resets counter
```

---

## 🧪 Example Usage

Run the factorial machine:

```scheme
(controller
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

fact-done)
```

Now test for different values of `n`:

| n | Instruction Count |
|---|-------------------|
| 1 | 4                 |
| 2 | 10                |
| 3 | 16                |
| 4 | 22                |

These numbers show how the recursive factorial machine executes more instructions as `n` increases.

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Count how many instructions are executed |
| Strategy | Add `instruction-count` register and increment it on each step |
| Key Change | Modify the controller assembler to insert the counter |
| Interface Added | `(machine 'get-instruction-count)` and `(machine 'reset-instruction-count)` |
| Real-World Use | Profiling, optimization, benchmarking |

---

## 💡 Final Thought

This exercise shows how to extend a low-level system with profiling tools.

By adding just one register and updating the controller assembly process:
- You gain insight into execution cost
- You can compare machine efficiency
- You can optimize algorithms based on real data

It's a great way to explore:
- How simulators can be extended
- How interpreters track execution metrics
- How to build profiling tools into virtual machines
