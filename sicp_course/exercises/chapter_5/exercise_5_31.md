## 🧠 Understanding Save/Restore in Evaluator Controller

In the register machine evaluator, when evaluating a procedure application like:

```scheme
(f a b c)
```

The evaluator does this in several steps:

### Step 1: Evaluate Operator `f`

```scheme
(save env)
(goto (label eval-dispatch))
(restore env)
(assign proc (reg val))
```

Because `f` may evaluate in an environment that changes `env`.

✅ **Save/restore needed**

---

### Step 2: Evaluate Operands

For each operand (except last one), it does:

```scheme
(save argl)
(save env)
(goto (label eval-dispatch))
(restore env)
(restore argl)
(assign argl (op cons) (reg val) (reg argl))
```

This is because:
- Evaluation order matters
- Intermediate operands must be collected into `argl`
- The `env` might change during operand evaluation

✅ So for intermediate operands, save/restore `argl` and `env` is necessary.

---

### Step 3: Final Operand

Only evaluates the final operand and adds directly to `argl` — no need to save/restore `argl`, since it won’t be used again.

✅ So `argl` doesn't need saving/restoring for last operand.

---

### Step 4: Apply Procedure

Once all operands are evaluated, apply the procedure:

```scheme
(save argl)
(assign continue (label after-call))
(goto (label primitive-apply)) ; or compound-apply
(restore argl)
```

So:
- `argl` is preserved before applying the procedure

✅ Needed only if `argl` will be reused later

---

# 🔍 Analyze Each Expression

We’ll look at each expression and determine which **saves/restores** are unnecessary.

---

## ✅ Case 1: `(f 'x 'y)`

### Structure

Both `'x` and `'y` are **self-evaluating** (quoted symbols).

So:
- Evaluating `'x` or `'y` does not modify `env`, `argl`, or `proc`
- No nested calls
- No side effects

### Which Saves Are Unnecessary?

| Register | Save/Restore Needed? | Why |
|---------|----------------------|-----|
| `env` before evaluating `'x'` | ❌ No | Quoted symbol doesn't use `env` |
| `env` before evaluating `'y'` | ❌ No | Same reason |
| `argl` before evaluating `'x'` | ❌ No | `'x'` is self-eval → doesn't affect `argl` |
| `argl` before evaluating `'y'` | ✅ Yes | `'y'` is second operand → must preserve previous `argl` |
| `proc` around operand eval | ❌ No | `f` is already known; no need to save it |

### ✔️ Summary – Case 1

- **Unneeded**: `env` before both quoted args, `argl` before first arg
- **Needed**: `argl` before second arg

---

## ✅ Case 2: `((f) 'x 'y)`

### Structure

Operator is `(f)` → must evaluate `(f)` to get actual function

Then evaluate `'x'` and `'y'`

### Save/Restore Analysis

| Register | Save/Restore Needed? | Why |
|---------|----------------------|-----|
| `env` before `(f)` | ✅ Yes | Must protect `env` while evaluating `(f)` |
| `proc` before evaluating `'x'` and `'y'` | ✅ Yes | Because `proc` came from `(f)` and must be preserved |
| `argl` before `'x'` | ❌ No | `'x'` is self-eval → no side effect on `argl` |
| `argl` before `'y'` | ✅ Yes | To build full list of arguments |
| `env` before `'x'` and `'y'` | ❌ No | Again, quoted symbols don’t affect `env` |

### ✔️ Summary – Case 2

- **Unneeded**: `env` before quoted args
- **Needed**: `env` before `(f)`; `proc` before operand evaluation; `argl` before second operand

---

## ✅ Case 3: `(f (g 'x) y)`

### Structure

- First operand: `(g 'x)` → involves calling `g`
- Second operand: `y` → variable reference

### Save/Restore Analysis

| Register | Save/Restore Needed? | Why |
|---------|----------------------|-----|
| `env` before `(g 'x)` | ✅ Yes | `g` may involve environment changes |
| `env` before `y` | ✅ Yes | `y` is a variable → may be unbound |
| `argl` before `(g 'x)` | ✅ Yes | `(g 'x)` can modify `argl` via recursion |
| `argl` before `y` | ❌ No | Last operand → no restore needed |
| `proc` around operand eval | ✅ Yes | `f` may be changed during operand evaluation |

### ✔️ Summary – Case 3

- **Needed**: `env`, `argl`, `proc` — all around `(g 'x)`
- **Not needed**: `argl` before `y` (last operand)

---

## ✅ Case 4: `(f (g 'x) 'y)`

### Structure

- First operand: `(g 'x)` → involves calling `g`
- Second operand: `'y'` → self-evaluating

### Save/Restore Analysis

| Register | Save/Restore Needed? | Why |
|---------|----------------------|-----|
| `env` before `(g 'x)` | ✅ Yes | May modify `env` |
| `env` before `'y'` | ❌ No | `'y'` is self-evaluating |
| `argl` before `(g 'x)` | ✅ Yes | Can modify `argl` during call |
| `argl` before `'y'` | ❌ No | Last operand → no need to save |
| `proc` before operands | ✅ Yes | `f` may be overwritten during operand evaluation |

### ✔️ Summary – Case 4

- **Needed**: `env`, `argl`, `proc` around `(g 'x)`
- **Not needed**: `env`, `argl` before `'y'`

---

## 📊 Final Comparison Table

| Expression | Saves Around Operator Eval | Saves Around Operands | Saves Around Last Operand |
|------------|----------------------------|------------------------|----------------------------|
| (f 'x 'y) | `env` before `f` | `argl` before `'x'` | None before `'y'` |
| ((f) 'x 'y) | `env` before `(f)` | `proc`, `argl` before `'x'` | Only `argl` before `'y'` |
| (f (g 'x) y) | `env` before `f` | All saves needed for `(g 'x)`<br>`proc`, `env`, `argl` saved<br>only `argl` skipped for `y` |
| (f (g 'x) 'y) | `env` before `f` | All saves needed for `(g 'x)`<br>none needed for `'y'` |

---

## 💡 Final Thought

This exercise shows how **operand evaluation affects register state**, and how much work is actually needed to manage registers safely.

By analyzing which values are:
- Self-evaluating
- Involve variables
- Or require full recursion

You learn how to **optimize stack usage** by eliminating redundant `save` and `restore` instructions.

This mirrors real-world compilers:
- That track **register usage**
- And optimize away unnecessary spills and reloads

And prepares you for more advanced optimizations in Exercise 5.32 and beyond.
