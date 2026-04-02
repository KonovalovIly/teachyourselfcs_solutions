### Sequential Execution (Correct Behavior)

When exchanges are performed sequentially, the balances will always maintain their original values in some order:

1. **Initial balances**: A=$10, B=$20, C=$30 (Total=$60)
2. **Any sequence of exchanges** (e.g., A↔B then B↔C then A↔C):
   - Each exchange perfectly swaps two account values
   - Final state will always be a permutation of the original values
   - Example possible outcome: A=$20, B=$30, C=$10 (Total still=$60)

### Problem with First Exchange Implementation

The first version of `account-exchange` doesn't serialize the entire operation:
```scheme
(define (account-exchange acc1 acc2)
  (let ((difference (- (acc1 'balance)
                      (acc2 'balance))))
    ((acc1 'withdraw) difference)
    ((acc2 'deposit) difference)))
```

**Violation Scenario** (Timing Diagram):

```
Process P1: A↔B          Process P2: B↔C
-------------------------------------------
1. Reads A=10, B=20
                        2. Reads B=20, C=30
3. Computes diff=-10
                        4. Computes diff=-10
5. Withdraws 10 from A (A=0)
                        6. Withdraws 10 from B (B=10)
7. Deposits 10 to B (B=20)
                        8. Deposits 10 to C (C=40)
Final balances: A=0, B=20, C=40 (Total=60)
```

Here, the original values aren't preserved (we have $0), though the total is correct.

### Sum Preservation Guarantee

Even with this flawed exchange:
1. Each `withdraw` and `deposit` is serialized per-account
2. Every +Δ to one account matches a -Δ to another
3. **Sum remains invariant** because:
   - All deposits correspond to equal withdrawals
   - No money is created or destroyed
   - Only transfers between accounts occur

### Violation Without Serialization

If we remove **all** serialization:

```
Process P1: A↔B          Process P2: B↔C
-------------------------------------------
1. Reads A=10, B=20
                        2. Reads B=20, C=30
3. Computes diff=-10
                        4. Computes diff=-10
5. Reads B=20 (for withdraw)
                        6. Reads B=20 (for withdraw)
7. Sets A=(10-10)=0
                        8. Sets B=(20-10)=10
9. Sets B=(20+10)=30
                        10. Sets C=(30+10)=40
Final balances: A=0, B=30, C=40 (Total=70!)
```

Now the **sum is corrupted** ($70 ≠ original $60) because:
- Both processes withdrew from B concurrently
- The same $10 was effectively "double-counted"
- Serialization prevents this by making operations atomic

### Key Insights

1. **Full Exchange Serialization** needed to:
   - Preserve individual balances (as permutations)
   - Maintain atomic "all-or-nothing" transfers

2. **Per-Account Serialization** only:
   - Preserves total sum
   - But allows intermediate states to leak

3. **No Serialization**:
   - Corrupts both individual balances and total sum
   - Allows race conditions on reads/writes

### Correct Implementation

The proper solution serializes the entire exchange:
```scheme
(define (serialized-exchange acc1 acc2)
  (let ((serializer1 (acc1 'serializer))
        (serializer2 (acc2 'serializer)))
    ((serializer1 (serializer2 account-exchange))
     acc1 acc2)))
```
This ensures the complete swap operation is atomic.
