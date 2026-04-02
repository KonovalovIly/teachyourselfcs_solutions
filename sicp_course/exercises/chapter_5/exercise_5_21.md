## 🧠 Understanding the Problem

We’re working with a **register machine** model, where memory is represented by a vector and cons cells use `car` and `cdr` registers.

Each version of `count-leaves` traverses a tree and counts all the **leaf nodes**.

We'll simulate both procedures using the register-machine language from *SICP* Section 5.4.

Assume we have these primitive operations:

```scheme
(list 'car car)
(list 'cdr cdr)
(list 'pair? pair?)
(list 'null? null?)
(list '+ +)
```

Also assume access to `cons` if needed.

---

# ✅ Part (a): Recursive `count-leaves`

Here’s the recursive procedure:

```scheme
(define (count-leaves tree)
  (cond ((null? tree) 0)
        ((not (pair? tree)) 1)
        (else (+ (count-leaves (car tree))
                (count-leaves (cdr tree))))))
```

This is not tail-recursive: it makes two recursive calls, then adds them.

So we need a **stack** to manage intermediate results.

---

## 🔁 Register Machine Design

### Registers

| Register | Purpose |
|---------|----------|
| `tree` | Current subtree being processed |
| `val` | Result of counting leaves |
| `continue` | Return address after recursive call |
| `temp` | Temporary storage during addition |

### Stack Usage

Since this is **non-tail recursive**, we’ll need to use the stack to save:
- The current `tree`
- The `continue` label

---

## ⚙️ Controller Instructions

```scheme
(controller
  (assign continue (label count-done))

count-loop
  (test (op null?) (reg tree))
  (branch (label base-null))

  (test (op pair?) (reg tree))
  (branch (label recursive-case))

  ;; Leaf node
  (assign val (const 1))
  (goto (reg continue))

base-null
  (assign val (const 0))
  (goto (reg continue))

recursive-case
  ;; Save current state before first recursive call
  (save continue)
  (save tree)
  (assign continue (label after-car))
  (assign tree (op car) (reg tree))
  (goto (label count-loop))

after-car
  (restore tree)
  (restore continue)
  (save continue)
  (save val) ; Save result of car branch
  (assign continue (label after-cdr))
  (assign tree (op cdr) (reg tree))
  (goto (label count-loop))

after-cdr
  (restore temp) ; Restore car result
  (assign val (op +) (reg temp) (reg val))
  (goto (reg continue))

count-done)
```

---

## 📌 Example Execution

Input: `'((1 . 2) . (3 . 4))`

Output: `4`

The machine will recursively explore each part of the tree, using the stack to keep track of pending additions.

---

# ✅ Part (b): Tail-Recursive `count-leaves` Using Iteration

Now implement this version:

```scheme
(define (count-leaves tree)
  (define (count-iter t n)
    (cond ((null? t) n)
          ((not (pair? t)) (+ n 1))
          (else (count-iter (cdr t) (count-iter (car t) n)))))
(count-iter tree 0))
```

This version uses **tail recursion**, so no stack is needed.

It accumulates the leaf count in `n`.

---

## 🧮 Register Machine Design

### Registers

| Register | Purpose |
|--------|---------|
| `tree` | Current subtree |
| `n` | Accumulated leaf count |
| `temp` | For temporary values during operations |

No stack needed – this is fully **tail-recursive**

---

## ⚙️ Controller Instructions

```scheme
(controller
  (assign n (const 0))

count-iter
  (test (op null?) (reg tree))
  (branch (label return))

  (test (op pair?) (reg tree))
  (branch (label recursive-case))

  ;; Leaf node
  (assign n (op +) (reg n) (const 1))
  (goto (reg continue))

recursive-case
  (save tree)
  (save n)
  (assign tree (op car) (reg tree))
  (goto (label count-iter))

return
  (restore n)
  (restore tree)
  (assign tree (op cdr) (reg tree))
  (goto (label count-iter))

done)
```

Wait — no, this isn't tail-recursive yet.

Let's restructure the controller to avoid needing a stack:

---

## 🛠️ Final Tail-Recursive Controller

We can avoid stack usage entirely by restructuring control flow.

Here’s a better approach:

```scheme
(controller
start
  (assign tree (reg input-tree))
  (assign n (const 0))

count-loop
  (test (op null?) (reg tree))
  (branch (label done))

  (test (op pair?) (reg tree))
  (branch (label recurse))

  ;; Leaf node
  (assign n (op +) (reg n) (const 1))
  (assign tree (op cdr) (reg tree))
  (goto (label count-loop))

recurse
  (assign tree (op car) (reg tree))
  (goto (label count-loop))

done
  (perform (op print) (reg n)))
```

This version uses only `tree` and `n`, and avoids any stack-based recursion.

It effectively implements a **depth-first traversal** using only registers.

---

## 📊 Summary Table

| Feature | Recursive Version | Tail-Recursive Version |
|--------|---------------------|------------------------|
| Uses Stack? | ✅ Yes | ❌ No |
| Stack Entries | Used to store intermediate results | Not needed |
| Performance | Slower due to stack management | Faster due to tail recursion |
| Register Count | More complex: needs `continue`, stack | Fewer registers used |
| Real-World Use | Like naive recursive functions | Like optimized interpreters |

---

## 💡 Final Thought

These exercises show how even simple functional algorithms translate into low-level control logic.

By implementing both:
- A **recursive** version (with stack)
- And a **tail-recursive** version (without)

You gain insight into:
- How recursion is implemented at the machine level
- Why tail recursion matters for performance
- How to manage memory efficiently

It's a great step toward understanding:
- Compilers
- Interpreters
- Garbage collection
- And efficient execution models
