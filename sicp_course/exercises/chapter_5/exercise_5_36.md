## 🧠 Understanding Operand Evaluation Order

In *SICP* Section 5.5, the compiler generates code that evaluates operands one at a time and builds up the `argl` register with the list of evaluated arguments.

The key procedure is:

```scheme
compile-application
```

Which calls:

```scheme
construct-arglist
```

To evaluate each operand and build the argument list.

Currently, the compiler evaluates operands **from right to left**, because:

- It builds the argument list using `cons`
- And prepends values to `argl` as they're evaluated
- So last operand is evaluated first
- Then second-to-last, and so on

This is done to avoid needing extra stack space.

---

## 🔍 Part 1: Current Order Is Right-to-Left

Here’s why:

```scheme
(f a b c)
→ Evaluates c → b → a
→ Because when building argl, it pushes them in reverse order
→ So compiled code ends up evaluating from **right to left**

For example:

```scheme
(compile '(f a b c) 'val '())
```

Would generate instructions like:

```scheme
(save continue)
(assign continue (label after-c))
(eval c)

after-c
(restore continue)
(save val)
(assign continue (label after-b))
(eval b)

after-b
(save val)
(assign continue (label after-a))
(eval a)

after-a
(restore arg2)
(restore arg1)
(assign argl (op list) (reg val) (reg arg1) (reg arg2))
(goto (label apply-procedure))
```

So:
✅ The compiler evaluates operands in **right-to-left** order.

---

## 📌 Part 2: Where This Order Is Determined

Look at the function:

```scheme
construct-arglist
```

It uses:

```scheme
(generate-application-code operands)
```

Inside that function, the compiler processes the list of operands using:

```scheme
(reverse operands)
```

Then iteratively evaluates them and builds `argl` via `cons`.

So:
> ❗ The **reverse** ensures that the final list is in correct order

But the actual **evaluation** happens in **right-to-left** order.

---

## 🛠️ Part 3: Modify Compiler to Evaluate Left-to-Right

We can change the compiler to evaluate operands **left-to-right**, by removing the `reverse` call and adjusting the way `argl` is built.

Change:

```scheme
(reverse operands)
→ remove or replace with identity
```

And modify the loop to append to `argl` rather than cons.

Example fix:

```scheme
(define (generate-application-code operands)
  (let ((operand-codes (map (lambda (opd)
                             (compile opd 'val 'next-arg))
                           operands)))
    (append-instruction-sequences
     ...
     (preserving '(env continue)
                 (make-instruction-sequence ...)))))
```

Now the compiler will evaluate operands **left-to-right**.

---

## 📈 Part 4: Effect on Efficiency

### Original Right-to-Left Order

Evaluates rightmost operand first, then builds `argl` via `cons`.

Each new value is pushed onto `argl` directly.

Efficient because:
- No need to reverse or rearrange the list
- Stack-based operand evaluation matches natural `cons` behavior

### New Left-to-Right Order

Now you must:
- Evaluate `a`, then `b`, then `c`
- But still build `argl = (a b c)`
- Which means either:
  - Reversing the list at the end
  - Or appending to the end of `argl` (which requires tracking the tail)

Both options are **less efficient**:
- Appending to the end requires more instructions
- Reversing the list adds overhead once

Thus:
✅ **Right-to-left** is more efficient for the compiler

Because:
- It allows building `argl` in a single pass
- Using just `cons` and no reversing

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Default Operand Order | Right-to-left |
| Why? | Matches `cons` structure; avoids reversing |
| Key Function | `construct-arglist` / `reverse` |
| Change Needed | Remove `reverse`, evaluate in original order |
| Efficiency Cost | Higher if we use left-to-right without optimization |
| Real-World Analogy | Like choosing between stack and queue in code generation |

---

## 💡 Final Thought

This exercise shows how **evaluation order affects performance** even in low-level code generation.

By default, the compiler uses **right-to-left** operand evaluation:
- For efficiency in list construction
- To avoid reversing or walking the list multiple times

Changing the order to **left-to-right** may be more intuitive:
- Matches Scheme’s usual evaluation order
- But costs performance unless optimized

This mirrors real-world compilers:
- Where evaluation order is chosen not just for semantics, but for speed

And shows how small design decisions have big impacts on generated code.
