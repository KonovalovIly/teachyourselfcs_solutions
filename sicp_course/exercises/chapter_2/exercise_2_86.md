## 🧠 Understanding the Problem

In earlier exercises, complex numbers were implemented using **Scheme's native numbers** for their components (e.g., `real-part`, `imag-part`, `magnitude`, `angle`). That limits flexibility.

Now, you are asked to:

- Allow complex numbers to be built from **generic numeric types**: integers, rationals, reals, etc.
- Replace all hard-coded uses of Scheme primitives (`+`, `-`, `sqrt`, `sin`, `cos`, etc.) with their **generic equivalents**: `add`, `sub`, `sqrt`, `sin`, `cos`, etc.
- Modify both the **rectangular** and **polar** implementations of complex numbers accordingly.

---

## ✅ Step-by-Step Plan

### 1. Use Generic Operators Everywhere

Replace:
- `+` → `add`
- `-` → `sub`
- `*` → `mul`
- `/` → `div`
- `sqrt` → `sqrt-generic`
- `sin`, `cos`, `atan` → `sin-generic`, `cos-generic`, `atan-generic`

This ensures that complex number construction and manipulation work regardless of the internal numeric types.

---

### 2. Define Generic Trigonometric and Square Root Operations

We need to define:

```scheme
(define (sin-generic x) (apply-generic 'sine x))
(define (cos-generic x) (apply-generic 'cosine x))
(define (atan-generic x y) (apply-generic 'arctangent x y))
(define (sqrt-generic x) (apply-generic 'square-root x))
```

Then implement these operations for each type:

| Type      | Operation Implemented |
|-----------|------------------------|
| scheme-number | use Scheme’s `sin`, `cos`, `atan`, `sqrt` |
| rational      | convert to real first, then apply |
| integer       | raise to real, then apply |

---

### 3. Modify Rectangular and Polar Packages

Update the internal procedures in both packages to use generic operations instead of primitive ones.

#### A. Rectangular Package

Previously:

```scheme
(define (make-from-real-imag x y)
  (cons x y))

(define (real-part z) (car z))
(define (imag-part z) (cdr z))

(define (magnitude z)
  (sqrt (+ (square (real-part z)) (square (imag-part z)))))

(define (angle z)
  (atan (imag-part z) (real-part z)))
```

Now becomes:

```scheme
(define (make-from-real-imag x y)
  (cons x y))

(define (real-part z) (car z))
(define (imag-part z) (cdr z))

(define (magnitude z)
  (sqrt-generic (add (square (real-part z)) (square (imag-part z)))))

(define (angle z)
  (arctangent (imag-part z) (real-part z)))
```

#### B. Polar Package

Previously:

```scheme
(define (make-from-mag-ang r a)
  (cons r a))

(define (magnitude z) (car z))
(define (angle z) (cdr z))

(define (real-part z)
  (* (magnitude z) (cos (angle z))))

(define (imag-part z)
  (* (magnitude z) (sin (angle z))))
```

Now becomes:

```scheme
(define (make-from-mag-ang r a)
  (cons r a))

(define (magnitude z) (car z))
(define (angle z) (cdr z))

(define (real-part z)
  (mul (magnitude z) (cos-generic (angle z))))

(define (imag-part z)
  (mul (magnitude z) (sin-generic (angle z))))
```

---

### 4. Install Primitive Implementations

Now install the low-level implementations of `sine`, `cosine`, `arctangent`, and `square-root` for `scheme-number`.

```scheme
(define (install-scheme-number-package)
  ;; ...
  (put 'sine '(scheme-number)
       (lambda (x) (make-scheme-number (sin (contents x)))))

  (put 'cosine '(scheme-number)
       (lambda (x) (make-scheme-number (cos (contents x)))))

  (put 'arctangent '(scheme-number scheme-number)
       (lambda (x y) (make-scheme-number (atan (contents x) (contents y)))))

  (put 'square-root '(scheme-number)
       (lambda (x) (make-scheme-number (sqrt (contents x)))))

  'done)
```

For `rational` and `integer`, project or raise to `real` before applying:

```scheme
(put 'sine '(rational)
     (lambda (x) (sine (raise x)))) ; assuming raise : rational → real

(put 'sine '(integer)
     (lambda (x) (sine (raise x)))) ; raise : integer → rational → real
```

---

## 🧩 Final Notes

### 🔁 Why This Works

By replacing all primitive operations with their generic counterparts:
- You make complex numbers **type-agnostic**.
- You enable support for **new numeric types**, as long as they implement the necessary operations.
- You maintain **modularity** and **extensibility** in your system.

---

## 📌 Summary of Key Changes

| Area                  | Change Made |
|-----------------------|-------------|
| Complex number parts  | Allow generic numeric types (not just Scheme numbers) |
| Rectangular package   | Use `add`, `mul`, `sqrt-generic`, `sin-generic`, etc. |
| Polar package         | Same: replace primitives with generic ops |
| Generic operations    | Add `sine`, `cosine`, `arctangent`, `square-root` |
| Primitive implementation | Define these for `scheme-number`; project/raise for others |

---

## 💡 Example Usage

```scheme
(define c1 (make-complex-from-real-imag (make-integer 3) (make-rational 1 2)))
(define c2 (make-complex-from-mag-ang (make-real 5.0) (make-real 0.785)))

(add c1 c2)
;; ⇒ Result will be simplified via drop if possible
```

The result will be a complex number whose components are computed using generic arithmetic and automatically simplified if possible.
