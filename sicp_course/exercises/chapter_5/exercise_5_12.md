## 🧠 Understanding the Goal

We want to build an **analyzer** into our simulator that tracks:
- All unique instructions
- Which registers are involved in control flow (`goto`, `branch`)
- Which registers are saved/restored
- What expressions assign values to each register

This gives us insight into:
- What **data paths** are needed
- How many **stack operations** occur
- Which **registers** are updated from where

This kind of analysis mirrors what compilers do during code generation:
- Determine **register usage**
- Identify **control flow**
- Analyze **memory access patterns**

---

## 🔧 Step-by-Step Implementation

We’ll modify the **assembler** so that it builds up these structures as part of the machine definition.

We'll define a new field in the machine object: `analysis-info`, which contains:

```scheme
(analysis-info
  instruction-list
  entry-point-registers
  save-restore-registers
  register-sources)
```

Now let's extend the assembler.

---

## 🛠️ Part 1: Modify Assembler to Track Instructions

### Define helper procedures:

```scheme
(define (add-if-new item lst)
  (if (member item lst) lst (cons item lst)))
```

Update the instruction parser to collect them.

Inside `extract-labels` or wherever you parse controller instructions:

```scheme
(define (track-instruction inst info)
  (let ((inst-type (car inst)))
    (case inst-type
      ((assign)
       (let ((reg-name (assign-reg-name inst))
             (value-exp (assign-value-exp inst)))
         (extend-analysis info
                          (instructions (add-if-new inst (analysis-instructions info)))
                          (sources (record-source reg-name value-exp (analysis-sources info)))))

      ((goto branch)
       (let ((target (branch-label-name inst)))
         (extend-analysis info
                          (entry-points (add-if-new target (analysis-entry-points info)))))

      ((save restore)
       (let ((reg-name (stack-inst-reg-name inst)))
         (extend-analysis info
                          (save-restore (add-if-new reg-name (analysis-save-restore info)))))

      (else
       (extend-analysis info
                        (instructions (add-if-new inst (analysis-instructions info)))))))
```

Where:
- `analysis-info` is stored in the machine object
- Each time we process an instruction, we update the relevant fields

---

## 📌 Part 2: Update Machine Message-Passing Interface

Add methods to retrieve the analysis data:

```scheme
(set! (machine 'get-instructions)
     (lambda () instruction-list))

(set! (machine 'get-entry-points)
     (lambda () entry-point-registers))

(set! (machine 'get-save-restore)
     (lambda () save-restore-registers))

(set! (machine 'get-register-sources)
     (lambda (reg) (hash-ref register-sources reg #f)))
```

Now you can query the machine like this:

```scheme
((machine 'get-instructions))
→ List of all instructions

((machine 'get-entry-points))
→ List of registers used in `goto` and `branch` instructions

((machine 'get-save-restore))
→ List of registers used with `save` and `restore`

((machine 'get-register-sources) 'val)
→ Sources for `val`
```

---

# ✅ Part 3: Test on Fibonacci Machine

Recall the **Fibonacci machine** from Figure 5.12:

```scheme
(controller
 (assign continue (label fib-done)) ; set up constant
 fib-loop
 (test (op <) (reg n) (const 2))
 (branch (label immediate-answer))

 ;; Recursive call to fib(n-1)
 (save continue)
 (save n)
 (assign continue (label after-fib-n-1))
 (assign n (op -) (reg n) (const 1))
 (goto (label fib-loop))

after-fib-n-1
 (assign a (reg val)) ; Save val as a
 (restore n)
 (restore continue)
 (save a)
 (assign continue (label after-fib-n-2))
 (assign n (op -) (reg n) (const 2))
 (goto (label fib-loop))

after-fib-n-2
 (assign b (reg val))
 (assign val (op +) (reg a) (reg b))
 (goto (reg continue))

immediate-answer
 (assign val (reg n))
 (goto (reg continue))

fib-done)
```

Run the analyzer on this machine.

---

## 📊 Analysis Results for Fibonacci Machine

After parsing, you should get:

### 1. Instruction List (Unique)

```scheme
'(assign test goto branch restore save perform)
```

### 2. Entry Point Registers (Used in `goto` or `branch`)

```scheme
'(continue)
```

Because `(goto (reg continue))` is used to return from recursive calls.

### 3. Saved/Restored Registers

```scheme
'(n continue a)
```

These are the registers used with `save` and `restore`.

### 4. Register Sources

For each register, track where assignments come from:

| Register | Sources |
|----------|---------|
| `continue` | `(label fib-done)` `(label after-fib-n-1)` `(label after-fib-n-2)` |
| `n` | `(reg n) (op -) (reg n) (const 1)` → and similar |
| `a` | `(reg val)` |
| `b` | `(reg val)` |
| `val` | `(reg n)` `(op +) (reg a) (reg b)` |

So:

```scheme
((machine 'get-register-sources) 'val)
→ '((reg n) (op +) (reg a) (reg b))
```

---

## 🎯 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Instrument the simulator to gather analysis data |
| Instructions Tracked | Unique list of all instructions |
| Entry Points | Registers used in `goto` and `branch` |
| Save/Restore Regs | Registers that push/pop from stack |
| Register Sources | Where each register gets its values |
| Real-World Use | Like compiler intermediate representation analysis |

---

## 💡 Final Thought

This exercise shows how to add **introspection and analysis** to a low-level system.

By extending the **assembler** to collect metadata:
- You gain visibility into machine behavior
- You understand what **data paths** are needed
- You can optimize register usage
- And identify redundant operations

This mirrors how real-world compilers and interpreters use:
- **Static single assignment (SSA)** forms
- **Control-flow graphs**
- **Register allocation and interference graphs**

You’re not just simulating machines — you're building tools to understand them deeply.
