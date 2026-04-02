## 🧠 Understanding Lexical Addressing

In a **lexical addressing** scheme, each variable is represented as:

```scheme
(lexical ⟨frame-offset⟩ ⟨var-index⟩)
```

Where:
- `frame-offset`: how many frames up to go (starting from 0 = current frame)
- `var-index`: index of the variable within that frame's list of variables

The environment is a chain of **frames**, each with a list of **variables**

So we need helper functions:
- To navigate the environment
- To access and modify variable values by index

---

# ✅ Part 1: Implement `lexical-address-lookup`

We’ll define this function to take:
- A lexical address like `(lexical 1 0)`
- The current environment

And return the value stored in that location, or raise an error if unassigned.

---

## 🔍 Helper Functions You Need

Assume you have these utility functions defined:

```scheme
(define (enclosing-environment env) (cdr env)) ; move outward
(define (first-frame env) (car env))            ; current frame
(define (frame-variables frame) ...)           ; list of variable names in frame
(define (frame-values frame) ...)              ; list of variable values in frame
(define (list-ref items n) ...)                ; get nth item from list
```

---

## 🛠️ Implementation

```scheme
(define (lexical-address-lookup lexical-addr env)
  (let ((frame-offset (cadr lexical-addr))
        (var-index (caddr lexical-addr)))
    (define (nth-frame n env)
      (if (= n 0)
          (first-frame env)
          (nth-frame (- n 1) (enclosing-environment env))))

    (let* ((target-frame (nth-frame frame-offset env))
           (vals (frame-values target-frame))
           (val (list-ref vals var-index)))
      (if (eq? val '*unassigned*)
          (error "Unassigned variable" lexical-addr)
          val))))
```

### 🔍 Explanation

- `lexical-address-lookup` takes a form like `(lexical 1 0)` and the environment
- It finds the correct frame by recursively walking the environment
- Then retrieves the value at that position
- If it’s `*unassigned*`, it raises an error

This allows the compiler to generate more efficient variable accesses by **avoiding name lookup**.

---

# ✅ Part 2: Implement `lexical-address-set!`

Now write a procedure to set the value of a variable at a given lexical address.

```scheme
(define (lexical-address-set! lexical-addr value env)
  (let ((frame-offset (cadr lexical-addr))
       (var-index (caddr lexical-addr)))
    (define (nth-frame n env)
      (if (= n 0)
          (first-frame env)
          (nth-frame (- n 1) (enclosing-environment env))))

    (let* ((target-frame (nth-frame frame-offset env))
           (vals (frame-values target-frame)))
      (set-car! (list-tail vals var-index) value))))
```

### 🔁 How This Works

- Find the frame using `nth-frame`
- Get the values list in that frame
- Use `list-tail` to reach the correct position
- Then `set-car!` to update the value

This assumes that:
- Frames store their variables and values in separate lists
- You can mutate those lists directly

If not, you may need to use mutable pairs or structures.

---

## 📌 Example Usage

Suppose the environment looks like this:

```scheme
env → [frame0: ((x y z) (1 2 3)),
       frame1: ((a b) (10 20))]
```

Then:

```scheme
(lexical-address-lookup '(lexical 0 1) env)
→ 2 ; value of y in current frame

(lexical-address-set! '(lexical 1 0) 99 env)

(lexical-address-lookup '(lexical 1 0) env)
→ 99 ; new value of a
```

---

## 🎯 Summary Table

| Function | Purpose |
|----------|---------|
| `lexical-address-lookup` | Retrieve value from environment using lexical address |
| `lexical-address-set!` | Set value at a lexical address |
| Key Idea | Avoid symbol lookup at runtime |
| Benefit | Faster variable access in compiled code |
| Error Handling | Detects `*unassigned*` variables |
| Real-World Analogy | Like stack slot access in virtual machines |

---

## 💡 Final Thought

These procedures support a key optimization in compiled code:
> ❗ **Lexical addressing avoids costly variable lookups during execution**

By replacing symbolic lookup (`lookup-variable-value`) with direct access:
- Compiled code becomes faster
- And easier to analyze statically

It mirrors real-world optimizations in:
- Virtual machines (like JVM, CLR)
- JavaScript engines (e.g., V8 uses similar techniques internally)

Implementing these helps you understand how compilers manage environments efficiently.
