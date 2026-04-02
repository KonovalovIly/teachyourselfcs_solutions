### Constraint Arithmetic Procedures

To enable the expression-oriented style shown in the converter example, we'll implement constraint versions of arithmetic operations:

#### Constant Value (cv)
```scheme
(define (cv val)
  (let ((c (make-connector)))
    (constant val c)
    c))
```

#### Constraint Addition (c+)
```scheme
(define (c+ x y)
  (let ((z (make-connector)))
    (adder x y z)
    z))
```

#### Constraint Subtraction (c-)
```scheme
(define (c- x y)
  (let ((z (make-connector)))
    (adder y z x)  ; x - y = z implemented as y + z = x
    z))
```

#### Constraint Multiplication (c*)
```scheme
(define (c* x y)
  (let ((z (make-connector)))
    (multiplier x y z)
    z))
```

#### Constraint Division (c/)
```scheme
(define (c/ x y)
  (let ((z (make-connector)))
    (multiplier y z x)  ; x / y = z implemented as y * z = x
    z))
```

### Complete Celsius-Fahrenheit Converter

Now we can implement the converter exactly as shown in the example:

```scheme
(define (celsius-fahrenheit-converter x)
  (c+ (c* (c/ (cv 9) (cv 5)) x)
      (cv 32)))

(define C (make-connector))
(define F (celsius-fahrenheit-converter C))
```

### Key Features

1. **Expression-Oriented Style**:
   - Each operation returns a new connector
   - Can be nested naturally like regular arithmetic

2. **Automatic Constraint Propagation**:
   - Relationships are maintained automatically
   - Changes propagate through the network

3. **Bidirectional Computation**:
   - Works in both directions (C→F and F→C)
   - Maintains all constraint relationships

### Example Usage

```scheme
; Set Celsius to 25
(set-value! C 25 'user)
(get-value F)  ; Returns 77

; Set Fahrenheit to 212
(forget-value! C 'user)
(set-value! F 212 'user)
(get-value C)  ; Returns 100
```

These constraint arithmetic procedures provide a clean, functional interface for building complex constraint networks while maintaining all the benefits of the original constraint system.
