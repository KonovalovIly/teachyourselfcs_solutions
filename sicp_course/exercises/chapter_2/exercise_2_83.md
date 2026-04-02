## 📚 Understanding the Type Tower

This exercise builds on the idea of a **hierarchy of number types**, where:

- An integer can be seen as a rational with denominator 1.
- A rational can be seen as a real number (floating-point).
- A real number can be seen as a complex number with zero imaginary part.
- Complex numbers are at the top and cannot be raised further.

We want to define a generic operation called `raise`, such that:

```scheme
(raise (make-integer 5))     ; ⇒ rational 5/1
(raise (make-rational 5 2))  ; ⇒ real 2.5
(raise (make-real 3.7))      ; ⇒ complex 3.7 + 0i
```

---

## ✅ Step-by-Step Plan

We will:

1. Define **constructors** for each type (`make-integer`, `make-rational`, etc.)
2. Implement **raising procedures**:
   - `integer->rational`
   - `rational->real`
   - `real->complex`
3. Define a **generic `raise` operation** using the system's dispatch mechanism.

---

## 🛠️ Implementation in Scheme

Let’s assume we’re using a typical tagged data representation, and that we have the following constructors available:

```scheme
(define (make-integer n)    (attach-tag 'integer n))
(define (make-rational n d) (attach-tag 'rational (cons n d)))
(define (make-real x)       (attach-tag 'real x))
(define (make-complex z)    (attach-tag 'complex z))
```

Now let's implement the raise operations.

---

### 1. Integer → Rational

```scheme
(define (integer->rational n)
  (make-rational (contents n) 1))
```

---

### 2. Rational → Real

Convert numerator ÷ denominator to floating-point:

```scheme
(define (rational->real r)
  (let ((numerator (car (contents r)))
        (denominator (cdr (contents r))))
    (make-real (/ numerator denominator))))
```

---

### 3. Real → Complex

Create a complex number with zero imaginary part:

```scheme
(define (real->complex x)
  (make-complex-from-real-imag (contents x) 0))
```

Assuming we have:

```scheme
(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
```

---

## 🧩 Generic `raise` Operation

We'll use the standard `apply-generic` pattern.

```scheme
(define (raise obj)
  (let ((type (type-tag obj))
        (val  (contents obj)))
    (cond ((eq? type 'complex)
           (error "Cannot raise complex numbers"))
          ((eq? type 'integer)
           ((get 'integer->rational '()) obj))
          ((eq? type 'rational)
           ((get 'rational->real '()) obj))
          ((eq? type 'real)
           ((get 'real->complex '()) obj))
          (else
           (error "Unknown type -- RAISE" type)))))

;; Or better: use apply-generic style
(define (install-raise-package)
  ;; internal procedures
  (put 'raise '(integer) integer->rational)
  (put 'raise '(rational) rational->real)
  (put 'raise '(real) real->complex)

  'done)
```

Then define the generic interface:

```scheme
(define (raise obj)
  (let ((proc (get 'raise (list (type-tag obj)))))
    (if proc
        (proc obj)
        (error "No raise method for type" (type-tag obj)))))
```

---

## 🔁 Example Usage

```scheme
(define x (make-integer 5))
(raise x)
;; => (rational (5 . 1))

(raise (make-rational 5 2))
;; => (real 2.5)

(raise (make-real 3.7))
;; => (complex (rectangular 3.7 0))
```

---

## 📌 Summary

| From Type | To Type   | Procedure               |
|-----------|-----------|-------------------------|
| integer   | rational  | `integer->rational`     |
| rational  | real      | `rational->real`        |
| real      | complex   | `real->complex`         |

- Complex numbers do not have a raise method.
- We install these raise procedures into a table under the `'raise` key.
- The generic `raise` function looks up and applies the correct coercion.

---

## 💡 Extra: Why Raise?

Raising supports **automatic type conversion** when performing mixed-type arithmetic. For example, adding an integer and a real can be done by raising the integer to a real first.

Later exercises build on this idea to support full **type coercion through a tower**.
