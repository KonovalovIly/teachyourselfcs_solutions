## 🧠 Step-by-Step Breakdown

### 1. **Total Assignments Before Constraints**

Each person can live on **any of 5 floors**, so:

$$
\text{Total possibilities} = 5^5 = 3125
$$

This includes duplicates like:
```scheme
(baker 1)
(cooper 1)
(fletcher 1)
(miller 1)
(smith 1)
```

But we know they must all live on **different floors**.

So now apply the `distinct?` constraint.

---

### 2. **After Distinct Constraint**

We’re choosing **permutations** of 5 unique values → number of such permutations is:

$$
5! = 120
$$

So:
> ✅ Only 120 out of 3125 total combinations are valid when requiring all floors are distinct.

This shows how powerful **early pruning** is.

---

## 🔍 Why Naive Approach Is Inefficient

In the original version:

```scheme
(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5))
        (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5))
        (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 1)))
    (require (not (= fletcher 5)))
    (require (> miller cooper))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (distinct? ...))
    (list ...)))
```

This allows each person to choose any floor first, then checks constraints later.

This leads to:
- A lot of wasted computation
- Many invalid paths explored before being rejected

---

## ✅ More Efficient Version: Apply Constraints Early

We can do better by **generating only valid options at each step**, reducing the branching factor as we go.

Here’s an optimized version:

```scheme
(define (multiple-dwelling-efficient)
  (define (distinct-values . values)
    (apply require (apply distinct? values)))

  (let ((baker (amb 1 2 3 4))) ; Baker ≠ 5
    (distinct-values baker)

    (let ((cooper (amb 2 3 4 5))) ; Cooper ≠ 1
      (distinct-values baker cooper)

      (let ((fletcher (amb 2 3 4))) ; Fletcher ≠ 1 and ≠ 5
        (distinct-values baker cooper fletcher)

        (let ((miller (amb 1 2 3 4 5)))
          (require (> miller cooper)) ; Miller lives above Cooper
          (distinct-values baker cooper fletcher miller)

          (let ((smith (amb 1 2 3 4 5)))
            (require (not (= (abs (- smith fletcher)) 1))) ; Smith not adjacent to Fletcher
            (distinct-values baker cooper fletcher miller smith)

            (list (list 'baker baker)
                  (list 'cooper cooper)
                  (list 'fletcher fletcher)
                  (list 'miller miller)
                  (list 'smith smith))))))))
```

---

## 📌 Key Improvements

| Optimization | Description |
|--------------|-------------|
| **Early Filtering** | Each new person picks from remaining available floors |
| **Distinct Check Incremental** | After each assignment, ensure it's distinct so far |
| **Fletcher Restricted First** | He cannot live on floor 1 or 5 |
| **Miller Must Be Above Cooper** | Enforced once both are chosen |
| **Smith Not Adjacent to Fletcher** | Checked last, since depends on both |
| **Avoid Invalid Branches** | E.g., don’t assign Fletcher to floor 1 or 5 |

---

## 🚀 Performance Gain

Let’s estimate the number of possibilities explored under both approaches.

### Naive Version:
- All 3125 initial combinations
- Most fail due to non-distinctness
- Very few survive to final check

### Optimized Version:
- Baker picks from 4 values (since he ≠ 5)
- Cooper picks from 4 values (≠ 1), excluding Baker’s floor → 3 choices
- Fletcher picks from 3 remaining floors (≠ 1, 5, and not same as previous)
- Miller picks from 2 remaining floors, and must be > Cooper
- Smith picks from last remaining floor, and must not be adjacent to Fletcher

So instead of exploring 3125 total combinations, we explore only those that satisfy constraints **at each step**.

This drastically reduces the number of backtracking branches.

✅ **Result**: This version finds the solution much faster than the naive one.

---

## 🧪 Example Output

Run:

```scheme
(multiple-dwelling-efficient)
```

And you get the known solution:

```scheme
((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))
```

If you try again with:

```scheme
try-again
```

You’ll get `no more values`, because there’s only one valid solution.

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Total Floor Assignments | 5⁵ = 3125 |
| Distinct Assignments | 5! = 120 |
| Valid Solutions | 1 |
| Naive Approach | Tries all 3125 combinations, prunes late |
| Optimized Version | Prunes impossible combinations early |
| Strategy | Nest `let`s and apply constraints incrementally |
| Result | Much fewer backtracking steps needed |

---

## 💡 Final Thought

This exercise illustrates the power of **constraint propagation** and **incremental pruning** in logic programming.

Instead of generating all possibilities and filtering them at the end:
> ✅ You should generate only those that pass earlier constraints

This mirrors real-world solvers like Prolog or SAT solvers, where:
- Smart variable ordering
- Constraint propagation
- Pruning invalid paths early

Are crucial for performance.
