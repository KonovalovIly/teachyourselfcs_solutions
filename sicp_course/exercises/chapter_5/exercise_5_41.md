## 🧠 Understanding the Problem

You are given a compile-time environment like:

```scheme
'((y z) (a b c d e) (x y))
```

This means:
- The **current frame** is `(y z)` → index `0`
- The next frame up is `(a b c d e)` → index `1`
- Then comes `(x y)` → index `2`

When you look for a variable, you search each frame from **innermost to outermost**, and within each frame from **left to right**.

So:
- `'c'` is in frame `1`, at position `2`
- `'x'` is in frame `2`, at position `0`

If a variable isn't found in any frame → return `'not-found`

---

## 🛠️ Step-by-Step Implementation

We’ll define two helper functions:
- `list-index` – finds the position of an item in a list
- `find-variable` – searches through frames

---

### 🔹 Helper: `list-index`

Returns the **index** of a symbol in a list, or `#f` if not found.

```scheme
(define (list-index var lst)
  (define (iter items index)
    (cond ((null? items) #f)
          ((eq? var (car items)) index)
          (else (iter (cdr items) (+ index 1))))
  (iter lst 0))
```

Example:

```scheme
(list-index 'c '(a b c d e)) → 2
(list-index 'x '(a b c d e)) → #f
```

---

### 🔹 Main Function: `find-variable`

Now implement the full `find-variable` function.

```scheme
(define (find-variable var env)
  (define (loop frames frame-index)
    (if (null? frames)
        'not-found
        (let ((pos (list-index var (car frames))))
          (if pos
              (cons frame-index pos)
              (loop (cdr frames) (+ frame-index 1)))))
  (loop env 0))
```

### 📌 Explanation

- `env` is a list of frames
- We loop through each frame starting from index `0`
- For each frame, we try to find `var` using `list-index`
- If found, return `(frame-index . position)`
- Else continue with enclosing frames

---

## 🧪 Example Usage

Given this environment:

```scheme
'((y z) (a b c d e) (x y))
```

Then:

```scheme
(find-variable 'c '((y z) (a b c d e) (x y)))
→ (1 . 2)
```

```scheme
(find-variable 'x '((y z) (a b c d e) (x y)))
→ (2 . 0)
```

```scheme
(find-variable 'w '((y z) (a b c d e) (x y)))
→ 'not-found
```

✅ These match the expected behavior.

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Find lexical address of a variable in environment |
| Input | Variable name, compile-time environment |
| Output | `(frame-index . position)` or `'not-found` |
| Key Helper | `list-index` – finds position in frame |
| Search Order | Innermost to outermost frame |
| Real-World Use | Like resolving variables in nested scopes |

---

## 💡 Final Thought

This exercise shows how to build a **lexical scoping resolver** used by compilers to generate efficient code.

By implementing `find-variable`:
- You enable the compiler to replace symbolic lookup with direct memory access
- You support optimizations like:
  - Lexical addressing
  - Closure conversion
  - Stack allocation

It's a foundational step toward understanding how real compilers manage **nested scopes** and **free variables**
