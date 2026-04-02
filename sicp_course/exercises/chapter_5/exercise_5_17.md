## 🧠 Understanding the Problem

In previous exercises, you added:

- **Instruction counting**: tracks how many instructions were executed
- **Tracing**: prints each instruction as it's executed

Now you want to improve tracing further:
- Print labels just before their corresponding instruction is executed
- This helps identify context and control flow visually

For example, if your controller has:

```scheme
fact-loop
  (test (op =) (reg n) (const 1))
  (assign continue (label base-case))
```

Then when `(test ...)` runs, it should print:

```
Label: fact-loop
Instruction: (test (op =) (reg n) (const 1))
```

This makes it easier to follow execution flow and debug complex machines.

---

## 🔁 Step-by-Step Plan

We'll need to:

### 1. **Track label/instruction associations**

During assembly, we’ll build a mapping like:

```scheme
'((fact-loop . (test (op =) (reg n) (const 1)))
  ...
```

So for each instruction, we can look up which label(s) precede it.

### 2. **Modify `make-machine` or assembler to store label info**

We'll add a new field to the machine model: `label-map`, which maps instruction pointers to label names.

Each time we assemble an instruction, we remember the current label context.

### 3. **Update trace output logic**

When printing traced instructions:
- Look up what label(s) preceded that instruction
- Print them before the instruction

This helps you understand where you are in the controller.

---

## 🛠️ Part 1: Enhance Assembler to Track Labels

We’ll modify `extract-labels` to keep track of labels preceding each instruction.

Here’s a sketch of the updated version:

```scheme
(define (extract-labels text receive)
  (define (loop insts labels label-map current-labels)
    (if (null? insts)
        (receive labels label-map)
        (let ((next-inst (car insts)))
          (if (label-inst? next-inst)
              (loop (cdr insts)
                    labels
                    (cons (cons (label-name next-inst) current-labels) label-map)
                    (cons (label-name next-inst) current-labels)) ; update current labels
              (loop (cdr insts)
                    (add-to-labels next-inst labels)
                    (cons (cons next-inst current-labels) label-map)
                    '()))))) ; reset current labels after instruction
  (loop text '() '() '()))
```

This builds a map like:

```scheme
'(((test ...) (fact-loop))
  ((save continue) (fact-loop))
  ...)
```

Where each instruction is paired with the list of labels that preceded it.

---

## 📌 Part 2: Modify Tracing Logic

We already have tracing from Exercise 5.16. Now enhance it to show labels.

### Updated Trace Output Procedure

```scheme
(define (print-trace-info machine inst)
  (let* ((label-map (machine 'get-label-map))
         (labels (lookup-labels label-map inst)))
    (for-each (lambda (label)
                (display "Label: ")
                (display label)
                (newline))
              labels)
    (display "Instruction: ")
    (write inst)
    (newline)))
```

This ensures that all labels immediately preceding the instruction are printed **before** the instruction itself.

---

## 📈 Part 3: Ensure Compatibility with Instruction Counting

To ensure the tracing doesn't interfere with performance counters:

- The instruction count still increments once per instruction
- The tracing only adds side effects to `execute` loop

So the counter remains accurate even with tracing enabled.

---

## 🎯 Example: Recursive Factorial Machine

Controller snippet:

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

With tracing and labels enabled:

```scheme
(start factorial-machine)

→ Label: fact-loop
  Instruction: (test (op =) (reg n) (const 1))

→ Label: fact-loop
  Instruction: (save continue)

→ Label: fact-loop
  Instruction: (save n)

→ Label: fact-loop
  Instruction: (assign n (op -) (reg n) (const 1))
...
```

This shows exactly where you are in the controller at every step.

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Print labels before executing associated instructions |
| Strategy | Build label/instruction mapping during assembly |
| Key Data Structure | `label-map`: list of `(inst labels)` pairs |
| Interface Added | `(machine 'get-label-map)` |
| Real-World Use | Like source-level debugging in real CPUs |

---

## 💡 Final Thought

This exercise demonstrates how to enhance a simulator to support **context-aware tracing**, making it more useful for **debugging and analysis**.

By storing label information during assembly:
- You get full visibility into control flow
- Without affecting instruction counting or behavior

It mirrors real-world tools like:
- Debuggers
- Disassemblers
- Profilers

Where symbolic labels help make raw instructions understandable.
