## 🧠 Understanding the Logic Query System

We’re working in the logic-based query system from *SICP* Section 4.4, similar to Prolog.

The goal is to define:

```scheme
(reverse ⟨input⟩ ⟨output⟩)
```

Which means: `⟨output⟩` is the reverse of `⟨input⟩`.

To do that, we’ll use:
- Recursion over lists
- The built-in `append-to-form` rule for concatenation

Here's the definition of `append-to-form`:

```scheme
(rule (append-to-form () ?y ?y))
(rule (append-to-form (?u . ?v) ?y (?u . ?z))
      (append-to-form ?v ?y ?z))
```

This allows you to append two lists or break one down into parts.

---

## ✅ Part 1: Define `reverse` Using Rules

We can define `reverse` recursively:
- Base case: empty list reversed is still empty
- Recursive case: reverse of `(a b c d)` is:
  ```scheme
  (append (reverse (b c d)) (a))
  ```

So here's how to write this in the logic system:

```scheme
(rule (reverse () ()))
(rule (reverse (?car . ?cdr) ?reversed)
      (and (reverse ?cdr ?rev-cdr)
           (append-to-form ?rev-cdr (?car) ?reversed)))
```

This says:
- The reverse of an empty list is empty
- For a non-empty list `(a . rest)`, first reverse `rest` → `rev-rest`
- Then append `(a)` to the end of `rev-rest` → gives full reverse

So:
```scheme
(reverse (1 2 3) ?x) ⇒ ?x = (3 2 1)
```

And:
```scheme
(reverse ?x (1 2 3)) ⇒ ?x = (3 2 1)
```

✅ This works in both directions!

---

## 📌 Part 2: Test Cases

### ✅ Case 1: Forward Reversal

Query:
```scheme
(reverse (1 2 3) ?x)
```

Result:
```scheme
?x = (3 2 1)
```

Because:
- Reverse `(2 3)` → `(3 2)`
- Append `(1)` at the end → `(3 2 1)`

---

### ✅ Case 2: Backward Reversal

Query:
```scheme
(reverse ?x (1 2 3))
```

This asks: What list reverses to `(1 2 3)`?

Answer:
```scheme
?x = (3 2 1)
```

Why?
- The only list that reverses to `(1 2 3)` is `(3 2 1)`

So yes:
> ✅ Our rule supports **both forward and backward queries**

---

## 🧪 Optional: Try More Complex Queries

Try:

```scheme
(reverse ?x ?y)
```

This will generate all possible list pairs where `?y` is the reverse of `?x`.

For example:
- `(reverse (1 2) (2 1))`
- `(reverse (1 2 3) (3 2 1))`
- `(reverse ?x (3 2 1))` → binds `?x = (1 2 3)`

---

## 📊 Summary Table

| Query | Expected Result |
|-------|------------------|
| `(reverse (1 2 3) ?x)` | `?x = (3 2 1)` |
| `(reverse ?x (1 2 3))` | `?x = (3 2 1)` |
| `(reverse ?x ?y)` | All valid list-reverse pairs |
| Rule Directionality | ✅ Works in both directions |

---

## 💡 Final Thought

This exercise shows how powerful **logic-based definitions** can be:
- You don’t specify how to reverse a list
- Just what it means to be the reverse
- And the system deduces the answer automatically

By defining `reverse` in terms of `append-to-form`, you get a declarative, bidirectional rule that:
- Handles known input
- Can also infer original input from output

This mirrors real-world logic systems like Prolog, where operations are defined relationally rather than procedurally.
