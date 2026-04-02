### ✅ **Exercise 3.49 — SICP**
> Give a scenario where the **deadlock-avoidance mechanism** from **Exercise 3.48** fails.

---

## 🧠 **Recap: Deadlock Avoidance via Resource Ordering**

In Exercise 3.48, we avoided deadlock in the exchange problem by:

- Assigning **unique numbers to accounts**
- Always acquiring locks in **increasing order of account number**

This ensures:
- No circular wait → no deadlock
- All processes follow the same global ordering

But this strategy **only works when all required resources are known in advance**.

---

## ❗ Problem: Resources Are Not Known Up Front

The hint says:

> Consider a situation where a process must get access to some shared resources before it can know which additional shared resources it will require.

This breaks the assumption behind resource ordering.

---

## ✅ **Example Scenario Where This Fails**

### 📌 Description

Imagine a system where:

- There are two types of shared resources: **databases A and B**
- Each database has a **lock**, numbered so A < B
- Processes may need to access multiple databases
- But crucially, **which additional databases are needed depends on data retrieved during processing**

---

### 🔁 Scenario

Let’s define two processes:

#### Process 1:
1. Acquires lock on **A** (lower-numbered)
2. Reads data from A
3. Based on data, determines it needs to update **C** (a new resource)

#### Process 2:
1. Acquires lock on **B** (higher-numbered)
2. Reads data from B
3. Based on data, decides it also needs to update **C**

Now assume:
- `A < B < C`

So both processes follow the rule: acquire lower-numbered first.

But now suppose:

| Time | Process 1                    | Process 2                    |
|------|------------------------------|------------------------------|
| t0   | Acquire A                    | Acquire B                    |
| t1   | Read from A → decide to use C| Read from B → decide to use C|
| t2   | Try to acquire C             | Try to acquire C             |
| t3   | Wait for Process 2 to release C | Wait for Process 1 to release C |

→ **Deadlock!**

Even though they followed the ordering rule initially, once they dynamically discover new dependencies, they can still **block each other**.

---

## 📌 Why This Breaks the Strategy

| Reason | Explanation |
|--------|-------------|
| **Dynamic resource acquisition** | New resources are discovered only after accessing earlier ones |
| **Unpredictable dependencies** | One process might need a resource that another already holds |
| **No global knowledge** | You can't sort unknown resources ahead of time |

This violates the assumption that **all required resources are known at the start**.

---

## 💡 Real-World Analogy

Think of this like:

> Two chefs in a kitchen trying to cook recipes.
> - Chef A starts with ingredient A, reads recipe, realizes it also needs ingredient C.
> - Chef B starts with ingredient B, reads recipe, also needs ingredient C.
>
> Now both want to grab ingredient C — but neither knows about the other's dependency until too late.

They followed an order, but **late binding of dependencies** caused a deadlock anyway.

---

## ✅ Summary

| Concept | Description |
|--------|-------------|
| Goal | Show a case where resource-ordering deadlock avoidance fails |
| Key Insight | The method assumes all needed resources are known up front |
| Real-world issue | Some dependencies are discovered **at runtime**, not design time |
| Result | Even ordered resource acquisition can lead to deadlock if dependencies are dynamic |
| Solution? | Need more advanced techniques like **timeout/retry**, **wait-for graphs**, or **transactional memory**
