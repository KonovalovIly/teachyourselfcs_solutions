## 🧠 Understanding the Problem

In *SICP*, the machine simulator uses an **assembler** that builds a list of instructions and maps each label to its corresponding instruction.

The issue arises because:
- The same label (`here`) appears more than once
- The assembler may map `here` to the **first** or **last** occurrence — depending on how it collects labels

This leads to **ambiguous behavior**:
- Which `here` does `(goto (label here))` jump to?

Let’s simulate this by hand.

---

## 🔁 Part 1: Behavior of Current Simulator

Assume the simulator uses a procedure like `extract-labels` to build a lookup table for labels.

If it processes the controller instructions **from top to bottom**, and replaces previous mappings when redefining a label, then:

| Label | Instruction |
|-------|-------------|
| `start` | `(goto (label here))` |
| `here` | First definition: assign `a = 3` |
| `here` | Second definition: assign `a = 4` |
| `there` | End point |

Now, during `extract-labels`, the last definition of `here` wins.

So:
- The first `here` → skipped
- The second `here` → used as target of `goto`

Thus, when the machine runs:

```scheme
(goto (label here)) ; jumps to second "here"
(assign a (const 4))
```

✅ So register `a` ends up with value **4**

But this behavior is **undefined and confusing**:
- It depends on how the assembler resolves duplicate labels
- There’s no guarantee which `here` is chosen

---

## ✅ Part 2: Modify `extract-labels` to Signal an Error

We need to ensure that each label is defined only **once**

Here’s how `extract-labels` might look originally:

```scheme
(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (let ((next (car text)))
        (if (label-inst? next)
            (let ((label (label-name next)))
              (extract-labels
               (cdr text)
               (lambda (insts labels)
                 (if (assoc label labels)
                     (error "Label repeated" label))
                 (receive (cons (make-label-entry label insts) labels))))
            (extract-labels
             (cdr text)
             (lambda (insts labels)
               (receive (cons (make-instruction next) insts) labels)))))
```

Wait — not quite right. Let’s define a better version.

### Here's a Corrected Version That Checks for Duplicates

```scheme
(define (extract-labels text receive)
  (define (loop insts labels seen)
    (cond ((null? insts)
           (receive labels insts))
          ((label-inst? (car insts))
           (let ((label (label-name (car insts))))
             (if (memq label seen)
                 (error "Duplicate label: " label))
             (loop (cdr insts)
                   (cons (make-label-entry label (cdr insts)) labels)
                   (cons label seen))))
          (else
           (loop (cdr insts)
                 labels
                 seen))))

  (loop text '() '()))
```

Where:
- `seen` keeps track of previously encountered labels
- If a label is already in `seen`, we raise an error

This ensures:
> ❌ **Error on duplicate label definitions**

---

## 📌 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Detect duplicate labels in register machine code |
| Problem | Ambiguous control flow if label appears more than once |
| Solution | Modify `extract-labels` to check for duplicates |
| Key Change | Track seen labels; signal error if any are reused |
| Real-World Analogy | Like checking for duplicate case labels in C switch statements |

---

## 💡 Final Thought

This exercise shows how important **label management** is in low-level control logic.

By default, the simulator doesn't catch duplicate labels — but that can lead to **unpredictable behavior**.

Adding a simple check to `extract-labels` makes your system more robust:
- You avoid silent bugs
- You enforce clarity in control flow
- You mirror real-world assemblers and compilers that detect label conflicts

This kind of change is essential when building complex interpreters or compilers — small errors in structure can lead to big issues in execution.
