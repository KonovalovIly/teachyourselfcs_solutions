## 🧠 Understanding the Problem

We are to translate this into a **register machine**, which has:
- **Registers**: `n`, `product`, `counter`
- **Operations**: multiply, add, compare (`>`)
- **Controller**: directs the flow of execution based on tests

Our goal is to simulate the behavior of the `factorial` function using only register machine instructions.

---

## 🔧 Step-by-Step Register Machine Design

### 1. **Registers**

| Register | Purpose |
|---------|----------|
| `n` | Holds input value |
| `product` | Accumulates result |
| `counter` | Iterates from 1 to n+1 |
| `one` | Constant: holds 1 |
| `max-count` | Holds `n + 1` (for comparison) |
| `temp` | Temporary storage for operations |

### 2. **Data-Path Diagram**

Here's a textual approximation of the data-path:

```
[Constant 1] → one
[Input n] → n

one → [product]
one → [counter]

[counter] → [add 1] → max-count
[counter] → [multiply product] → temp

[Condition > counter n?] → Controller Branch
   → If true: return product
   → If false: update product & counter
```

You can imagine these registers connected to an **ALU** that supports:
- Multiply
- Add
- Compare (`>`)
- Conditional branch

---

## 📊 Controller Instructions (High-Level)

Let’s define the controller steps in terms of microinstructions.

### Controller Steps

```
start
  assign product ← 1
  assign counter ← 1

loop
  test if counter > n
    if true → done
    if false → go to loop-body

loop-body
  assign temp ← counter * product
  assign product ← temp
  assign counter ← counter + 1
  goto loop
```

### Controller Table

| Label | Action | Test/Conditional |
|-------|--------|------------------|
| start | Set `product` to 1 | None |
|       | Set `counter` to 1 |      |
| loop  | Test `counter > n` | Yes/No |
| yes   | Go to `done`       |        |
| no    | Compute `temp = counter × product` |
|       | Assign `product ← temp` |
|       | Assign `counter ← counter + 1` |
|       | Goto `loop`              |
| done  | Return `product`         |

---

## 📈 Data-Path Diagram (Textual Representation)

Here's how the data paths connect:

```
Registers:
┌──────────┐     ┌──────────┐     ┌────────────┐
│  product │<----┤   temp   ├-----► counter × ? │
└──────────┘     └──────────┘     └────────────┘
                   ▲
                   │
                  [×]
                 /     \
                /       \
               V         V
           counter     product
```

```
Counter Path:
┌──────────┐     ┌──────────┐     ┌────────────┐
│ counter  ├-----► counter+1 ◄-----┤ incr button? │
└──────────┘     └──────────┘     └────────────┘
```

```
Compare Path:
┌──────────┐     ┌──────────┐
│ counter  ├-----► > n       ◄─── "Is counter > n?"
└──────────┘     └──────────┘
                   ▲
                   │
          [Go to done if true]
```

---

## 🎯 Final Controller Diagram

Here’s a high-level **controller diagram** in pseudocode form:

```
start:
  set product = 1
  set counter = 1
loop:
  test: if counter > n
  branch: if true → done
          if false → loop-body
loop-body:
  set temp = counter × product
  set product = temp
  set counter = counter + 1
  goto loop
done:
  return product
```

This matches the control structure of the iterative Scheme code.

---

## 📌 Summary

| Feature | Description |
|--------|-------------|
| Goal | Implement iterative factorial as a register machine |
| Registers | `n`, `product`, `counter`, `one`, `temp`, `max-count` |
| Operations | Multiply, Add, Compare |
| Controller Logic | Loops until `counter > n`, then returns `product` |
| Data Paths | Connects registers through ALU for math and conditionals |
| Real-World Use | Foundation for understanding low-level control flow |

---

## 💡 Final Thought

This exercise shows how to break down even a simple functional algorithm like factorial into:
- **Register transfers**
- **Control flow**
- **Arithmetic operations**

It builds the foundation for later exercises where you’ll implement more complex interpreters and compilers.

By drawing both the **data-path** and **controller diagrams**, you gain insight into how high-level logic becomes concrete computation in real machines.
