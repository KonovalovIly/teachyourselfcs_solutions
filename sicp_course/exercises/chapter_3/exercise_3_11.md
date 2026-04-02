### 1. Defining `make-account`
The `make-account` procedure is defined in the global environment. Its definition is:
```scheme
(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request: MAKE-ACCOUNT" m))))
  dispatch)
```

### 2. Evaluating `(define acc (make-account 50))`
When `(make-account 50)` is called:
1. A new environment `E1` is created, extending the global environment, with `balance` bound to `50`.
2. In `E1`, the internal procedures `withdraw`, `deposit`, and `dispatch` are defined. These procedures are created in `E1`, so their enclosing environment is `E1`.
3. The `dispatch` procedure is returned and assigned to `acc` in the global environment.

At this point:
- `acc` is a procedure (the `dispatch` procedure) with its enclosing environment `E1` where `balance` is `50`.
- The environment structure looks like:
  ```
  Global Environment
    make-account: <procedure>
    acc: <dispatch procedure (with env E1)>
    ...
    E1 (extends Global)
      balance: 50
      withdraw: <procedure (with env E1)>
      deposit: <procedure (with env E1)>
      dispatch: <procedure (with env E1)>
  ```

### 3. Evaluating `((acc 'deposit) 40)`
This is two steps:
1. `(acc 'deposit)`:
   - `acc` is the `dispatch` procedure in `E1`.
   - Calling `(dispatch 'deposit)` in `E1` returns the `deposit` procedure (defined in `E1`).
2. `(deposit 40)`:
   - The `deposit` procedure is called with `amount` bound to `40`.
   - It updates `balance` in `E1` to `50 + 40 = 90` and returns `90`.

Now, `balance` in `E1` is `90`.

### 4. Evaluating `((acc 'withdraw) 60)`
Similarly:
1. `(acc 'withdraw)`:
   - `(dispatch 'withdraw)` returns the `withdraw` procedure (defined in `E1`).
2. `(withdraw 60)`:
   - The `withdraw` procedure checks that `90 >= 60`, updates `balance` to `90 - 60 = 30`, and returns `30`.

Now, `balance` in `E1` is `30`.

### 5. Defining `acc2`: `(define acc2 (make-account 100))`
When `(make-account 100)` is called:
1. A new environment `E2` is created, extending the global environment, with `balance` bound to `100`.
2. In `E2`, new `withdraw`, `deposit`, and `dispatch` procedures are defined (these are distinct from the ones in `E1`).
3. The `dispatch` procedure from `E2` is returned and assigned to `acc2` in the global environment.

Now, the environment structure looks like:
```
Global Environment
  make-account: <procedure>
  acc: <dispatch procedure (with env E1)>
  acc2: <dispatch procedure (with env E2)>
  ...
  E1 (extends Global)
    balance: 30
    withdraw: <procedure (with env E1)>
    deposit: <procedure (with env E1)>
    dispatch: <procedure (with env E1)>
  E2 (extends Global)
    balance: 100
    withdraw: <procedure (with env E2)>
    deposit: <procedure (with env E2)>
    dispatch: <procedure (with env E2)>
```

### Answers to the Questions:
1. **Where is the local state for `acc` kept?**
   - The local state for `acc` is the `balance` variable in environment `E1`.

2. **How are the local states for `acc` and `acc2` kept distinct?**
   - `acc`'s state is in `E1`, and `acc2`'s state is in `E2`. These are two separate environments, so their `balance` variables are distinct.

3. **Which parts of the environment structure are shared between `acc` and `acc2`?**
   - The global environment is shared (e.g., the `make-account` procedure itself). The internal procedures (`withdraw`, `deposit`, `dispatch`) and the `balance` variable are not shared; they are distinct in `E1` and `E2`.

### Summary:
- Each call to `make-account` creates a new environment with its own `balance` and associated procedures.
- The local state is kept in the environment created during the call to `make-account`.
- The environments (`E1` and `E2`) are distinct, so the states are distinct.
- Only the global environment is shared between `acc` and `acc2`.