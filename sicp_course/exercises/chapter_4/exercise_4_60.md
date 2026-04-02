## 🧠 Understanding the Problem

The query system doesn't inherently understand that `(lives-near A B)` and `(lives-near B A)` are the **same relationship**.

So when you ask:

```scheme
(lives-near ?person-1 ?person-2)
```

It matches every person living in the same town, both ways:
- If `A` lives near `B`, it returns both:
  - `?person-1 = A, ?person-2 = B`
  - `?person-1 = B, ?person-2 = A`

This leads to **duplicate results**, even though logically they're the same.

---

## ❓ Why Does This Happen?

Because the logic engine treats `(lives-near A B)` and `(lives-near B A)` as **distinct queries**, unless told otherwise.

In standard logic programming:
- Relationships are **symmetric only if explicitly defined**
- Otherwise, all combinations are explored independently

There is no built-in notion of:
- **Ordering of variables**
- **Unique unordered pairs**

So without intervention:
> ✅ The system will return **each unordered pair twice**

---

## ✅ Solution: Avoid Duplicates by Ordering

We can modify the rule so that it only reports one version of the pair.

For example, we can enforce an **ordering**, like alphabetical or lexicographical ordering:

```scheme
(rule (lives-near ?person-1 ?person-2)
      (and (address ?person-1 (?town . ?rest))
           (address ?person-2 (?town . ?rest))
           (not (same ?person-1 ?person-2))
           (lisp-value string<? ?person-1 ?person-2)))
```

Where:
- `string<?` compares names alphabetically
- Ensures that `?person-1 < ?person-2` → avoids reversing the pair later

Now, only one direction will match:
- `(lives-near A B)` if `A < B`
- Not `(lives-near B A)`

Thus, each unordered pair appears **only once**.

---

## 📌 Example with Real People

Suppose the database has:

```scheme
(address (Hacker Alyssa P.) (Boston (MIT) 1))
(address (Fect Cy D.) (Boston (MIT) 2))
(address (Bitdiddle Ben) (Slumerville (Onion St.) 90))
```

Without ordering, the query:

```scheme
(lives-near ?person-1 ?person-2)
```

Returns:

```
((Hacker Alyssa P.) (Fect Cy D.))
((Fect Cy D.) (Hacker Alyssa P.))
```

With ordering, it returns only:

```
((Hacker Alyssa P.) (Fect Cy D.))
```

And skips the reverse.

---

## 🛠️ Alternative: Define a Unique Pair Rule

If your system doesn't support `string<?` easily, define a new rule that enforces uniqueness:

```scheme
(rule (unique-lives-near ?p1 ?p2)
      (and (lives-near ?p1 ?p2)
           (lisp-value string<? ?p1 ?p2)))
```

Then query:

```scheme
(unique-lives-near ?p1 ?p2)
→ ((Hacker Alyssa P.) (Fect Cy D.))
```

Only once per pair.

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Avoid duplicate "nearby" pairs |
| Problem | Logic system treats `(lives-near A B)` and `(lives-near B A)` as distinct |
| Solution | Add constraint: `?p1 < ?p2` (alphabetically) |
| Result | Each unordered pair appears only once |
| Key Tool | Use `lisp-value` to apply Scheme predicate inside rules |

---

## 💡 Final Thought

This exercise shows how even small details in logic-based systems can lead to unexpected behavior:
- Without symmetry-breaking constraints, duplicates appear naturally
- But adding a simple condition like `?p1 < ?p2` ensures uniqueness

This mirrors real-world applications like:
- Social network connections
- Undirected graph edges
- Matching algorithms

Where you want to avoid redundant representation of symmetric relationships.
