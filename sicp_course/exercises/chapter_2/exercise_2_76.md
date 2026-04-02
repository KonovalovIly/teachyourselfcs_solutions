### ### **Exercise 2.76: Strategies for Evolving Systems with Generic Operations**

1. **Generic operations with explicit dispatch**
2. **Data-directed style**
3. **Message-passing style**

Each strategy has its own way of organizing code, which affects how easy it is to add new **types** or new **operations** to a system.

---

### ✅ 1. Generic Operations with Explicit Dispatch

In this approach, each operation checks explicitly (via conditionals like `if` or `cond`) what type it's dealing with and then calls the appropriate implementation.

#### 🔧 Adding New Types:
- You must **modify every existing generic operation** to handle the new type.
- This is **invasive**: adding a new type requires changes across many functions.

#### 🔧 Adding New Operations:
- Add a new generic function that contains conditional logic for all types.
- Less invasive than adding new types, but still involves checking all types.

#### ⚠️ Summary:
- **Hard to add types**, because every operation must be updated.
- **Moderately hard to add operations**, since each new operation must account for all types.

---

### ✅ 2. Data-Directed Style

This uses a table to store implementations: operations and types are keys, and the associated procedures are stored and retrieved dynamically.

Example: `(put 'magnitude '(complex) ...)`, `(get 'magnitude '(complex))`.

#### 🔧 Adding New Types:
- You can **add a new type without modifying existing code**.
- Just define the necessary operations for the new type and install them in the table.

#### 🔧 Adding New Operations:
- Similarly, you can define and install the operation for all existing types.
- No need to modify existing types.

#### ✅ Summary:
- **Easy to add both types and operations**.
- Requires careful management of the operation-and-type table.

---

### ✅ 3. Message-Passing Style

Each data object is a **procedure that takes messages (operation names)** and performs the corresponding action.

Example: A `make-vector` might respond to `'magnitude`, `'angle`, etc., by returning the appropriate value.

#### 🔧 Adding New Types:
- Easy: create a new message-handling procedure.
- Doesn't interfere with existing types.

#### 🔧 Adding New Operations:
- Hard: you must modify **all existing data objects** to handle the new message.
- Not scalable if many types exist.

#### ⚠️ Summary:
- **Easy to add types**.
- **Hard to add operations**, since all existing types must be modified.

---

## 🧠 Comparative Analysis

| Strategy                  | Add New Types | Add New Operations |
|---------------------------|---------------|--------------------|
| Explicit Dispatch         | ❌ Hard       | ❌ Moderate        |
| Data-Directed             | ✅ Easy       | ✅ Easy            |
| Message-Passing           | ✅ Easy       | ❌ Hard            |

---

## 💡 Which Organization Is Most Appropriate?

### If **new types must often be added**:
> **Best choice: Message-passing style or Data-directed style**, since both allow adding new types without modifying existing code.  
> Between the two, **message-passing** is better when types are conceptually self-contained.

### If **new operations must often be added**:
> **Best choice: Data-directed style**, as it allows adding new operations without modifying existing types.  
> **Avoid message-passing**, which makes adding new operations difficult.

---

## 📝 Final Answer Summary

For each strategy:

- **Explicit dispatch**: Adding either new types or new operations requires changing multiple parts of the system. Poor extensibility.
- **Data-directed**: Flexible for both types and operations. Centralized table manages complexity.
- **Message-passing**: Flexible for new types; not ideal for new operations.

### ✅ Best Fit:
- Use **message-passing** if your system evolves by frequently adding **new types**.
- Use **data-directed style** if your system evolves by frequently adding **new operations**.