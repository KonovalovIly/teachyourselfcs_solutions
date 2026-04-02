### Ripple-Carry Adder Implementation

To implement an n-bit ripple-carry adder, we'll chain together n full-adders, with each carry-out connected to the next carry-in.

#### Full-Adder Implementation (for reference)
```scheme
(define (full-adder a b c-in sum c-out)
  (let ((s (make-wire))
       (c1 (make-wire))
       (c2 (make-wire)))
    (half-adder b c-in s c1)
    (half-adder a s sum c2)
    (or-gate c1 c2 c-out)
    'ok))
```

#### Ripple-Carry Adder Procedure
```scheme
(define (ripple-carry-adder A B S C)
  (define (iter a-wires b-wires s-wires carry-in)
    (if (null? a-wires)
        (set-signal! C (get-signal carry-in))
        (let ((carry-out (make-wire)))
          (full-adder (car a-wires)
                      (car b-wires)
                      carry-in
                      (car s-wires)
                      carry-out)
          (iter (cdr a-wires)
                (cdr b-wires)
                (cdr s-wires)
                carry-out))))
  (let ((initial-carry (make-wire)))
    (set-signal! initial-carry 0)
    (iter A B S initial-carry)))
```

### Delay Time Analysis

The total delay for an n-bit ripple-carry adder is:
```
n × full-adder-delay
```

Where `full-adder-delay` can be broken down as:
```
full-adder-delay = 2 × half-adder-delay + or-gate-delay
half-adder-delay = max(and-gate-delay,
                       or-gate-delay + and-gate-delay + inverter-delay)
```

#### Detailed Breakdown:

1. **Half-Adder Delay**:
   - Sum path: `or-gate-delay + and-gate-delay + inverter-delay`
   - Carry path: `and-gate-delay`
   - Overall: max of these two paths

2. **Full-Adder Delay**:
   - Two half-adders in series: `2 × half-adder-delay`
   - Plus one OR gate: `or-gate-delay`
   - Total: `2 × half-adder-delay + or-gate-delay`

3. **Ripple-Carry Adder**:
   - n full-adders in series: `n × full-adder-delay`

### Key Observations

1. **Propagation Delay**:
   - The carry signal must ripple through all n stages
   - This makes the adder's performance O(n)

2. **Critical Path**:
   - The carry chain is the limiting factor
   - Sum bits settle at different times (earlier bits first)

3. **Typical Values**:
   - If we assume:
     - `and-gate-delay` = 1
     - `or-gate-delay` = 1
     - `inverter-delay` = 1
   - Then:
     - `half-adder-delay` = 3
     - `full-adder-delay` = 7
     - n-bit adder delay = 7n

This implementation demonstrates how to build a basic parallel adder while highlighting its fundamental performance limitation - the linear growth of delay with the number of bits. More advanced adder designs (like carry-lookahead) can improve this to O(log n) delay.
