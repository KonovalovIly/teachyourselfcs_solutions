## 🧠 Core Idea: Detect Recursive Loops

We need to add a **loop detection mechanism** that tracks:
- What queries are currently being processed
- Whether we’re revisiting a goal we’ve already seen in the current chain

If so, we **fail** and backtrack instead of continuing the infinite recursion.

---

## 🔁 Step-by-Step Loop Detection Strategy

We’ll maintain a **history of goals** currently being pursued.

Each time we attempt to evaluate a new rule body, we check:
- If this same pattern is already on the stack
- If yes → fail (to break the loop)

Let’s define how to do this.

---

## 🛠️ Part 1: Add a History Stack

Add a global variable that keeps track of active queries:

```scheme
(define *active-goals* '())
```

Each entry will be a **goal pattern**, e.g., `(outranked-by (Bitdiddle Ben) ?boss)`

---

## 📌 Part 2: Modify Rule Application Logic

When applying a rule, first check if the goal has already been attempted in the current deduction path.

Here’s how you might modify the `apply-a-rule` function:

```scheme
(define (apply-a-rule rule query-pattern frame)
  (let ((instantiated-body (instantiate-conclusion rule frame)))
    (if (already-working-on? instantiated-body *active-goals*)
        (succeed-more frame) ; Fail by returning empty stream
        (let ((new-frame (extend-active-goals instantiated-body)))
          (qeval (rule-body rule) new-frame)))))

(define (extend-active-goals goal frame)
  (add-binding-to-frame '*active-goals* goal frame))

(define (already-working-on? goal history)
  (member goal history equal?))
```

Where:
- `equal?` ensures structural match
- `*active-goals*` is part of the environment or frame

---

## 🧪 Part 3: Example Loop Detection

Suppose we have:

```scheme
(rule (outranked-by ?staff ?boss)
      (or (supervisor ?staff ?boss)
          (and (supervisor ?staff ?manager)
               (outranked-by ?manager ?boss))))

(supervisor (Alyssa P. Hacker) (Ben Bitdiddle))
(supervisor (Ben Bitdiddle) (Lamech))
```

Now run:

```scheme
(outranked-by (Alyssa P. Hacker) ?boss)
```

Without loop detection:
- Alyssa outranks Ben → Ben outranks Lamech
- Query returns `?boss = Lamech`

But with a **circular rule**, like:

```scheme
(rule (outranked-by ?staff ?boss)
      (or (supervisor ?staff ?boss)
          (and (outranked-by ?middle ?boss)
               (supervisor ?staff ?middle))))
```

The second clause can cause infinite recursion:
- `(outranked-by ?middle ?boss)` may include `(Alyssa ?boss)` again
- Then system tries to prove `(outranked-by Alyssa ?boss)` again → loop

With loop detection:
- When `(outranked-by Alyssa Lamech)` is tried again,
- It sees `(outranked-by Alyssa Lamech)` is already on the stack
- So it **fails** and backtracks

✅ Prevents infinite loops!

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Avoid infinite recursion in logic engine |
| Key Tool | Track active goals in a history list |
| Detection Strategy | Check for repeated patterns in current deduction chain |
| Where to Integrate | In `apply-a-rule`, before evaluating the rule body |
| Real-World Analogy | Like detecting cycles in graph traversal |

---

## 💡 Final Thought

This exercise shows how to make a **logic programming system more robust** by adding a **loop detector**.

By maintaining a history of goals being pursued:
- You can detect when you're entering a cycle
- And prevent infinite recursion from occurring

This mirrors real-world systems like Prolog, which use similar techniques to handle **recursive rules safely**.

It also shows how even small enhancements — like tracking derivation paths — can make declarative engines much more practical.
