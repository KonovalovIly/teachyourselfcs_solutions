### Part a: Sequential Execution Orders

With three operations (Peter, Paul, Mary) and sequential execution, there are 3! = 6 possible orderings. Let's compute the final balance for each:

1. **Peter → Paul → Mary**:
   - Start: $100
   - Peter: +10 → $110
   - Paul: -20 → $90
   - Mary: -45 → $45

2. **Peter → Mary → Paul**:
   - Start: $100
   - Peter: +10 → $110
   - Mary: -55 → $55
   - Paul: -20 → $35

3. **Paul → Peter → Mary**:
   - Start: $100
   - Paul: -20 → $80
   - Peter: +10 → $90
   - Mary: -45 → $45

4. **Paul → Mary → Peter**:
   - Start: $100
   - Paul: -20 → $80
   - Mary: -40 → $40
   - Peter: +10 → $50

5. **Mary → Peter → Paul**:
   - Start: $100
   - Mary: -50 → $50
   - Peter: +10 → $60
   - Paul: -20 → $40

6. **Mary → Paul → Peter**:
   - Start: $100
   - Mary: -50 → $50
   - Paul: -20 → $30
   - Peter: +10 → $40

**Possible final balances**: $35, $40, $45, $50

### Part b: Interleaved Execution Possibilities

When operations can be interleaved at the statement level, more outcomes become possible. Here are some additional scenarios:

1. **Read-Read-Modify Pattern**:
   - All three read balance ($100) simultaneously
   - Peter writes 110
   - Paul writes 80
   - Mary writes 50
   - Final result: $50 (last write wins)

2. **Overlapping Reads**:
   - Peter and Paul read $100
   - Mary reads after Peter writes:
     - Peter writes +10 → $110
     - Mary reads $110, writes -55 → $55
     - Paul writes -20 → $80
   - Final result: $80

3. **Partial Interleaving**:
   - Paul reads $100
   - Peter reads $100
   - Mary reads $100
   - Peter writes +10 → $110
   - Mary writes -50 → $60 (using her read of $100)
   - Paul writes -20 → $80
   - Final result: $80

**Additional possible balances**: $55, $60, $80

### Timing Diagram Example (for $80 result)

```
Time  | Peter          | Paul           | Mary
-----------------------------------------------------
1     | Read: 100      |                |
2     |                | Read: 100      |
3     |                |                | Read: 100
4     | Write: 100+10  |                |
5     |                |                | Write: 100-50
6     |                | Write: 100-20  |
-----------------------------------------------------
Final balance: 80
```

### Key Observations

1. **Sequential** gives 4 possible outcomes ($35, $40, $45, $50)
2. **Interleaved** can produce 3 additional outcomes ($50, $55, $60, $80)
3. **Critical Factor**: When each operation reads the balance value
4. **Anomalies Occur** when:
   - Operations read stale values
   - Writes overwrite each other unexpectedly
   - Withdrawals calculate based on outdated balances

This demonstrates how concurrent access to shared state without proper synchronization can lead to inconsistent results.
