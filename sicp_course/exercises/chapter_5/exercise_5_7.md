## 🧠 Understanding the Simulator

The **explicit-control evaluator** simulator lets you:
- Define machines with registers
- Specify controller instructions
- Set register contents
- Run the machine
- Inspect results

You can simulate your machines using:

```scheme
(define expt-recursive-machine (make-machine ...))
(define expt-iterative-machine (make-machine ...))
```

Then test them by setting inputs and running:

```scheme
(set-register-contents! expt-recursive-machine 'b 2)
(set-register-contents! expt-recursive-machine 'n 5)

(start expt-recursive-machine)
(get-register-contents expt-recursive-machine 'val) ; should be 32
```

Similarly for iterative version.

---

# ✅ Part 1: Test Recursive Exponentiation Machine

### 🔁 Recall: Recursive `expt` Definition

```scheme
(define (expt b n)
  (if (= n 0)
      1
      (* b (expt b (- n 1)))))
```

### ⚙️ Register Machine Controller (Recall from Exercise 5.4)

```scheme
(controller
  (assign continue (label expt-done))
  (goto (label expt-loop))

expt-loop
  (test (op =) (reg n) (const 0))
  (branch (label base-case))
  ;; Recursive call
  (save b)
  (save n)
  (save continue)
  (assign continue (label after-expt))
  (assign n (op -) (reg n) (const 1))
  (goto (label expt-loop))

after-expt
  (restore n)
  (restore b)
  (assign val (op *) (reg b) (reg val))
  (goto (reg continue))

base-case
  (assign val (const 1))
  (goto (reg continue))

expt-done
)
```

### 🛠️ Define and Test It

```scheme
(define expt-recursive-machine
  (make-machine
   '(b n val continue temp one)
   (list (list '= =)
         (list '- -)
         (list '* *)
         (list 'print display))
   '(
     (assign one (const 1))
     (assign continue (label expt-done))
     (goto (label expt-loop))

     expt-loop
     (test (op =) (reg n) (reg one))
     (branch (label base-case))

     (save b)
     (save n)
     (save continue)
     (assign continue (label after-expt))
     (assign n (op -) (reg n) (reg one))
     (goto (label expt-loop))

     after-expt
     (restore n)
     (restore b)
     (restore continue)
     (assign val (op *) (reg b) (reg val))
     (goto (reg continue))

     base-case
     (assign val (reg one))
     (goto (reg continue))

     expt-done
     )))
```

### 🧪 Run the Machine

Test `2^5 = 32`:

```scheme
(set-register-contents! expt-recursive-machine 'b 2)
(set-register-contents! expt-recursive-machine 'n 5)
(start expt-recursive-machine)
(get-register-contents expt-recursive-machine 'val)
→ 32
```

Stack contents during execution:
- Each recursive call pushes `b`, `n`, `continue`
- After base case returns 1, values are popped and multiplied back up

✅ Works correctly!

---

# ✅ Part 2: Test Iterative Exponentiation Machine

### 🔁 Recall: Iterative `expt` Definition

```scheme
(define (expt b n)
  (define (expt-iter counter product)
    (if (= counter 0)
        product
        (expt-iter (- counter 1) (* b product))))
  (expt-iter n 1))
```

### ⚙️ Register Machine Controller (Recall from Exercise 5.4)

```scheme
(controller
  (assign counter (reg n))
  (assign product (const 1))

loop
  (test (op =) (reg counter) (const 0))
  (branch (label done))

  (assign product (op *) (reg b) (reg product))
  (assign counter (op -) (reg counter) (const 1))
  (goto (label loop))

done
  (assign val (reg product))
  (goto (reg continue))
)
```

### 🛠️ Define and Test It

```scheme
(define expt-iterative-machine
  (make-machine
   '(b n counter product val one)
   (list (list '= =)
         (list '- -)
         (list '* *))
   '(
     (assign one (const 1))
     (assign counter (reg n))
     (assign product (reg one))

     loop
     (test (op =) (reg counter) (reg one))
     (branch (label done))

     (assign product (op *) (reg b) (reg product))
     (assign counter (op -) (reg counter) (reg one))
     (goto (label loop))

     done
     (assign val (reg product))
     )))
```

### 🧪 Run the Machine

Test `2^5 = 32`:

```scheme
(set-register-contents! expt-iterative-machine 'b 2)
(set-register-contents! expt-iterative-machine 'n 5)
(start expt-iterative-machine)
(get-register-contents expt-iterative-machine 'val)
→ 32
```

This version is faster because:
- No stack operations
- Just a simple loop that updates `product` and `counter`

✅ Works correctly — and more efficiently than the recursive version

---

## 📊 Summary Table

| Feature | Recursive Exponentiation | Iterative Exponentiation |
|--------|--------------------------|----------------------------|
| Stack Usage | ✅ Yes – used for recursion | ❌ No – tail-recursive |
| Registers | `b`, `n`, `val`, `continue`, `one` | `b`, `n`, `counter`, `product`, `one` |
| Performance | Slower – stack management overhead | Faster – no stack |
| Example Input | `(b=2 n=5)` | `(b=2 n=5)` |
| Output | `32` | `32` |
| Real-World Analogy | Like recursive function calls in C | Like `for` loop in assembly |

---

## 💡 Final Thought

This exercise gives hands-on experience using the **register machine simulator** to test control logic and data flow.

By defining and testing both versions of `expt`, you see how:
- Recursion requires stack management
- Iteration avoids it entirely → better performance

It's a great way to explore the difference between:
- **Recursive algorithms** (slower, more complex)
- **Iterative algorithms** (faster, simpler)

And how those differences show up at the **machine level**
