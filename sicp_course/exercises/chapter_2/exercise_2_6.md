### **Church Numerals: Representing Numbers as Functions**
Church numerals represent non-negative integers as **higher-order functions**:
- A number `n` is a function that applies its argument `n` times.
- **`zero`**: Applies `f` **0 times** (just returns `x`).
- **`add-1`**: Takes a numeral `n` and returns a new numeral that applies `f` **one more time** than `n`.

---

### **1. Definitions of `zero` and `add-1`**
Given:
```scheme
(define zero 
  (lambda (f) 
    (lambda (x) x)))  ; Applies f 0 times: λf.λx.x

(define (add-1 n)
  (lambda (f) 
    (lambda (x) 
      (f ((n f) x))))) ; Applies f one more time than n: λn.λf.λx.f (n f x)
```

---

### **2. Derive `one` and `two` Directly**
#### **Step 1: Compute `(add-1 zero)` to find `one`**
Substitute `zero` into `add-1`:
```scheme
(add-1 zero)
= (lambda (f) (lambda (x) (f ((zero f) x))))
```
Now evaluate `(zero f)`:
```scheme
(zero f) 
= (lambda (x) x)  ; zero applies f 0 times, so it's the identity function.
```
Thus:
```scheme
= (lambda (f) (lambda (x) (f ((lambda (x) x) x))))
= (lambda (f) (lambda (x) (f x)))  ; Simplified: λf.λx.f x
```
So, **`one`** is:
```scheme
(define one 
  (lambda (f) 
    (lambda (x) 
      (f x))))  ; Applies f once: λf.λx.f x
```

#### **Step 2: Compute `(add-1 one)` to find `two`**
Substitute `one` into `add-1`:
```scheme
(add-1 one)
= (lambda (f) (lambda (x) (f ((one f) x)))))
```
Now evaluate `(one f)`:
```scheme
(one f) 
= (lambda (x) (f x))  ; one applies f once.
```
Thus:
```scheme
= (lambda (f) (lambda (x) (f (f x))))  ; Applies f twice: λf.λx.f (f x)
```
So, **`two`** is:
```scheme
(define two 
  (lambda (f) 
    (lambda (x) 
      (f (f x)))))  ; Applies f twice: λf.λx.f (f x)
```

---

### **3. Direct Definition of Addition (`+`)**
Church numeral addition should produce a numeral that applies `f` **`a + b`** times.  
Given two numerals `a` and `b`, their sum `(+ a b)` should apply `f` **`a` times followed by `b` times**:
```scheme
(define (+ a b)
  (lambda (f) 
    (lambda (x) 
      ((a f) ((b f) x)))))  ; λa.λb.λf.λx.a f (b f x)
```

#### **Intuition**:
- `(b f)` applies `f` `b` times to `x`, yielding `(f (f ... (f x)...))` (`b` times).
- `(a f)` then applies `f` `a` times to the result of `(b f x)`.

#### **Verification**:
Compute `(+ one two)`:
```scheme
(+ one two)
= (lambda (f) (lambda (x) ((one f) ((two f) x))))
= (lambda (f) (lambda (x) ((lambda (x) (f x)) ((two f) x))))
= (lambda (f) (lambda (x) (f ((two f) x))))
= (lambda (f) (lambda (x) (f (f (f x)))))  ; Which is three (λf.λx.f (f (f x)))
```

---

### **Key Insights**
1. **Church Numerals as Functions**:
   - `zero`: `λf.λx.x` (apply `f` 0 times).
   - `one`: `λf.λx.f x` (apply `f` 1 time).
   - `two`: `λf.λx.f (f x)` (apply `f` 2 times).
2. **Addition**:
   - `(+ a b)` composes `a` and `b` applications of `f`.
3. **Abstraction**:
   - Numbers are **operations**, not data. This aligns with λ-calculus, where everything is a function.

---

### **Example Evaluations**
#### **Church numeral for 3**:
```scheme
(define three (+ one two))
(define (inc x) (+ x 1))  ; Helper to test

((three inc) 0)  ; => 3 (applies inc 3 times to 0)
```

#### **Testing Addition**:
```scheme
(define four (+ two two))
((four inc) 0)  ; => 4
```

---

### **Conclusion**
Church numerals show how **lambda calculus can encode arithmetic purely with functions**. This exercise demonstrates:
1. **Numbers as higher-order procedures**.
2. **Addition as functional composition**.
3. The power of **abstraction** in representing fundamental concepts.  

This is foundational in computability theory and functional programming.