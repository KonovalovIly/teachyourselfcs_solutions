### Unsynchronized Case (Without Serialization)

**Initial value**: x = 10
**Two parallel processes**:
1. P1: `(set! x (* x x))`       (x = x²)
2. P2: `(set! x (* x x x))`     (x = x³)

#### Possible Interleavings and Results:

1. **P1 completes then P2**:
   - P1: 10 * 10 = 100 → x = 100
   - P2: 100 * 100 * 100 = 1,000,000 → x = 1,000,000

2. **P2 completes then P1**:
   - P2: 10 * 10 * 10 = 1,000 → x = 1,000
   - P1: 1,000 * 1,000 = 1,000,000 → x = 1,000,000

3. **P1 reads x (10), then P2 completes, then P1 writes**:
   - P1 reads x = 10
   - P2: 10 * 10 * 10 = 1,000 → x = 1,000
   - P1 writes: 10 * 10 = 100 → x = 100

4. **P2 reads x (10), then P1 completes, then P2 writes**:
   - P2 reads x = 10
   - P1: 10 * 10 = 100 → x = 100
   - P2 writes: 10 * 10 * 10 = 1,000 → x = 1,000

5. **Both read x=10, then interleaved writes**:
   - Both read x = 10
   - P1 writes 100 → x = 100
   - P2 writes 1,000 → x = 1,000 (last write wins)

6. **Partial multiplication in P2 before P1 writes**:
   - P2 computes 10 * 10 = 100 (but hasn't assigned)
   - P1 writes 100 → x = 100
   - P2 completes: 100 * 10 = 1,000 → x = 1,000

**Possible final values**: 100, 1,000, 1,000,000

### Synchronized Case (With Serialization)

Using serialized procedures forces each operation to complete entirely before the other can start:

**Possible executions**:

1. **P1 then P2**:
   - P1: 10 * 10 = 100 → x = 100
   - P2: 100 * 100 * 100 = 1,000,000 → x = 1,000,000

2. **P2 then P1**:
   - P2: 10 * 10 * 10 = 1,000 → x = 1,000
   - P1: 1,000 * 1,000 = 1,000,000 → x = 1,000,000

**Only possible final value**: 1,000,000

### Key Observations

1. **Without Serialization**:
   - Multiple interleavings possible due to separate read/write operations
   - Results depend on when each process reads x and when they write
   - 3 possible outcomes: 100, 1,000, 1,000,000

2. **With Serialization**:
   - Each operation is atomic (reads and writes can't be separated)
   - Only one possible outcome: 1,000,000
   - Eliminates all race conditions

3. **Serialization Effect**:
   - Forces operations to happen in sequence
   - Maintains consistency by preventing interleaved reads/writes
   - Guarantees deterministic result

### Final Answer

**Without serialization**, possible values of x: 100, 1,000, 1,000,000
**With serialization**, only possible value: 1,000,000
