## 🧠 Step-by-Step Rule Definitions

### 🔹 Rule 1: Grandson Relationship

A person `S` is a **grandson of G** if:
- `S` is the son of someone who is the son of `G`.

```scheme
(rule (grandson ?g ?s)
      (and (son ?g ?f)
           (son ?f ?s)))
```

This allows us to find:
- Grandsons of **Cain**, **Methushael**, etc.

---

### 🔹 Rule 2: Sons of Lamech

We want to find all people who are sons of Lamech or his wife Ada.

From the database:
- Lamech is married to Ada
- Ada has two sons: Jabal and Jubal

So we define:

```scheme
(rule (son ?m ?c)
      (and (wife ?m ?w)
           (son ?w ?c)))
```

Now:
- `(son Lamech ?x)` will match both Jabal and Jubal

---

## 📌 Query Examples

Let’s test with each of the requested queries.

---

### ✅ Query 1: Grandsons of Cain

Use the `grandson` rule:

```scheme
(grandson Cain ?x)
```

From the data:
- Cain → Enoch → Irad

So:
```scheme
?x = Irad
```

✅ **Answer**: Irad

---

### ✅ Query 2: Sons of Lamech

We already defined the rule that includes sons via wife:

```scheme
(son Lamech ?x)
→ ?x = Jabal, Jubal
```

These are Ada's sons.

✅ **Answer**: Jabal and Jubal

---

### ✅ Query 3: Grandsons of Methushael

We use the `grandson` rule again:

```scheme
(grandson Methushael ?x)
→ Methushael → Lamech → ?x = Jabal, Jubal
```

Because:
- Lamech is Methushael’s son
- Jabal and Jubal are Lamech’s sons → thus grandsons of Methushael

✅ **Answer**: Jabal and Jubal

---

## 📊 Summary Table

| Query | Result |
|-------|--------|
| `(grandson Cain ?x)` | `?x = Irad` |
| `(son Lamech ?x)` | `?x = Jabal`, `Jubal` |
| `(grandson Methushael ?x)` | `?x = Jabal`, `Jubal` |

---

## 💡 Final Thought

This exercise shows how you can build up complex family relationships using just a few simple rules.

By combining:
- Direct facts (`(son Adam Cain)`)
- Rules for indirect relationships (`grandson`, `son via wife`)
You can explore multi-generational connections declaratively.

This mirrors real-world applications like:
- Family tree exploration
- Genealogy systems
- Logic-based reasoning over social networks

It’s a beautiful example of how symbolic logic can capture natural relationships.
