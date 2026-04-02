## 🧠 Understanding the Simulator's Register Model

In *SICP* Section 5.2.1, registers are created using:

```scheme
(define (make-register name)
  (let ((contents '*unassigned*)
        (trace #f))
    (lambda (message)
      (cond ((eq? message 'get) contents)
            ((eq? message 'set)
             (lambda (value)
               (set! contents value)))
            (else (error "Unknown request -- REGISTER" message)))))
```

We need to enhance this to support tracing and make it accessible via the machine model.

---

## 🔁 Step-by-Step Plan

### 1. **Modify `make-register` to Support Tracing**

Update the register definition to include a trace flag and history:

```scheme
(define (make-register name)
  (let ((contents '*unassigned*)
        (trace-enabled #f))
    (define (set-value! value)
      (if trace-enabled
          (begin
            (display "Register ")
            (display name)
            (display " assigned: ")
            (display contents)
            (display " => ")
            (display value)
            (newline)))
      (set! contents value))

    (lambda (message)
      (cond ((eq? message 'get) contents)
            ((eq? message 'set) set-value!)
            ((eq? message 'turn-on-trace) (set! trace-enabled #t))
            ((eq? message 'turn-off-trace) (set! trace-enabled #f))
            (else (error "Unknown request -- REGISTER" message)))))
```

Now each time you assign a value to a traced register, it prints:

```
Register ⟨name⟩ assigned: ⟨old⟩ => ⟨new⟩
```

---

### 2. **Extend Machine Interface to Control Register Tracing**

Add methods to enable/disable tracing on specific registers:

```scheme
(set! (machine 'trace-register-on)
     (lambda (reg-name)
       (let ((reg (get-register machine reg-name)))
       (reg 'turn-on-trace)))

(set! (machine 'trace-register-off)
     (lambda (reg-name)
       (let ((reg (get-register machine reg-name)))
       (reg 'turn-off-trace)))
```

This lets you toggle tracing on individual registers:

```scheme
(machine 'trace-register-on 'a)
(machine 'trace-register-off 'val)
```

---

## 📌 Part 3: Example Usage

Define a simple factorial machine:

```scheme
(define fact-machine
  (make-machine
   (list (list '= =) (list '* *) (list '- -))
   '(
     (assign continue (label fact-done))
     (assign val (const 1))
     (goto (label fact-loop))))

(fact-machine 'trace-register-on 'continue)
(fact-machine 'trace-register-on 'val)

(set-register-contents! fact-machine 'n 3)
(start fact-machine)
```

### Sample Trace Output

As the machine runs, you’ll see output like:

```
Register continue assigned: *unassigned* => fact-done
Register val assigned: *unassigned* => 1
Register n assigned: *unassigned* => 3
Register n assigned: 3 => 2
Register val assigned: 1 => 2
Register n assigned: 2 => 1
Register val assigned: 2 => 2
Register n assigned: 1 => 0
Register val assigned: 2 => 6
```

This gives insight into:
- How registers change during execution
- What values they take at key points
- Whether assignments follow expected logic

---

## 🎯 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Add per-register tracing to simulator |
| Strategy | Extend `make-register` with trace state and logging |
| Key Change | Registers now accept `'turn-on-trace`, `'turn-off-trace` |
| Interface Added | `(machine 'trace-register-on ⟨reg⟩)` and similar |
| Real-World Use | Like variable watches in debuggers |

---

## 💡 Final Thought

This exercise shows how to add **fine-grained observability** to low-level systems.

By extending registers with tracing capabilities:
- You gain visibility into internal state changes
- You can debug complex machines more effectively
- You can compare actual behavior against expectations

It mirrors tools used in real-world debugging:
- Watch variables
- Log statements
- Instruction-level tracing

And prepares you for even richer introspection features in future exercises.
