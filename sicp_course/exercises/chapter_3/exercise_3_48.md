### ✅ **Exercise 3.48 — SICP**
> Explain why numbering accounts and always acquiring the smaller-numbered one first avoids deadlock in the exchange problem, and update `serialized-exchange` and `make-account` accordingly.

---

## 🧠 Background: The Exchange Problem

In Exercise 3.40 and earlier, we saw that when two processes concurrently try to exchange money between multiple bank accounts:

```scheme
(serialized-exchange account1 account2)
```

If one process tries to acquire `account1`, then `account2`, and another does the reverse, it can lead to **deadlock**:

- Process A holds `account1`, wants `account2`
- Process B holds `account2`, wants `account1`
- **Deadlock**: Both wait forever

This is a classic **circular wait condition**, which is one of the four necessary conditions for deadlock.

---

## 🔐 Deadlock Avoidance Strategy

To avoid deadlock:

> **Impose a total ordering on resources (in this case, bank accounts)**
> Always acquire resources in increasing order of number.

This prevents circular waits:
- If everyone acquires lower-numbered accounts before higher ones,
- Then no process can hold a higher-numbered account while waiting for a lower-numbered one.

Thus, **deadlock is impossible**.

---

## ✅ Part 1: Modify `make-account` to Include an Account Number

We extend `make-account` so each account has a unique number:

```scheme
(define (make-account-and-serializer balance account-number)
  (let ((balance balance)
        (serializer (make-serializer))
        (number account-number)) ; new field
    (define (withdraw amount)
      (if (>= balance amount)
          (begin (set! balance (- balance amount))
                 balance)
          "Insufficient funds"))
    (define (deposit amount)
      (set! balance (+ balance amount))
      balance)
    (define (get-balance) balance)
    (define (get-number) number) ; added method
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (serializer withdraw))
            ((eq? m 'deposit) (serializer deposit))
            ((eq? m 'balance) (serializer get-balance))
            ((eq? m 'serializer) serializer)
            ((eq? m 'number) get-number) ; dispatch message for number
            (else (error "Unknown request: MAKE-ACCOUNT" m))))
    dispatch))
```

Now each account responds to `(account 'number)` with its unique ID.

---

## ✅ Part 2: Rewrite `serialized-exchange` to Use Account Numbers

We define a helper to determine which account comes first:

```scheme
(define (get-account-number account)
  ((account 'number))) ; returns the number
```

Then, rewrite `serialized-exchange`:

```scheme
(define (serialized-exchange account1 account2)
  (let* ((number1 (get-account-number account1))
         (number2 (get-account-number account2)))
    (define (maybe-swap a b)
      (if (< (get-account-number a) (get-account-number b))
          (list a b)
          (list b a)))

    (let* ((ordered-accounts (maybe-swap account1 account2))
           (accountA (car ordered-accounts))
           (accountB (cadr ordered-accounts)))
      ((accountA 'serializer)
       ((accountB 'serializer)
        (lambda ()
          (let ((difference ((accountA 'balance) - ((accountB 'balance)))))
            ((accountA 'withdraw) difference)
            ((accountB 'deposit) difference))))))))
```

---

## 📌 Key Explanation

Why does this prevent deadlock?

| Concept | How It Prevents Deadlock |
|--------|---------------------------|
| **Total Order** | Accounts are numbered; comparison defines a strict order |
| **Acquisition Order** | Always acquire lower-numbered account first |
| **No Circular Waits** | No process will ever wait for a lower-numbered account than one it already holds |
| **Consistent Behavior** | All processes follow the same ordering rule |

This eliminates the possibility of a **deadlock cycle** like A→B and B→A.

---

## 💡 Final Notes

This is a general technique for avoiding deadlocks:
- **Order all shared resources**
- **Always access them in the same order**

It’s widely used in operating systems and database transactions.

---

## ✅ Summary

| Task | Description |
|------|-------------|
| Goal | Avoid deadlock in `serialized-exchange` |
| Strategy | Assign unique numbers to accounts; always acquire in increasing order |
| Modified `make-account` | Added a number field and access method |
| Updated `serialized-exchange` | Acquire accounts in consistent order |
| Result | Deadlock-free exchange operation |

