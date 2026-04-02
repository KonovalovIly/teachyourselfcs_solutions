## 🧠 Understanding the Goal

You are to:
- Take the **register-machine interpreter** from Section 5.4
- Translate its logic into **C or another low-level language**
- Simulate registers, stack, and control flow manually
- Implement support for basic Scheme features

This mirrors how real interpreters are built:
- From scratch
- In C or Rust (modern alternatives)

And gives insight into:
- How functional languages can be implemented in imperative ones
- How evaluators manage environments and apply procedures
- And how garbage collection and memory management work

---

# 🔧 Step-by-Step Implementation Plan

We’ll build a minimal subset of Scheme using C, with a structure similar to the explicit-control evaluator.

---

## 📌 Part 1: Define Core Data Structures

### 1. **Values and Tags**

Use tagged unions to represent different types:

```c
typedef enum {
    TYPE_NULL,
    TYPE_BOOL,
    TYPE_NUMBER,
    TYPE_SYMBOL,
    TYPE_PAIR,
    TYPE_PROCEDURE,
    TYPE_PRIMITIVE,
    TYPE_COMPOUND,
    TYPE_ENVIRONMENT
} ObjectType;

typedef struct Object {
    ObjectType type;
    union {
        int number;
        char *symbol;
        struct Pair *pair;
        struct Procedure *proc;
        struct Environment *env;
    };
} Object;
```

---

### 2. **Environments**

Implement environments as linked lists of frames:

```c
typedef struct Frame {
    Object **vars;
    Object **vals;
    int size;
} Frame;

typedef struct Environment {
    Frame *frame;
    struct Environment *enclosing;
} Environment;
```

Each frame holds a list of variable names and their corresponding values.

---

### 3. **Stack**

Implement a simple stack using an array:

```c
#define STACK_SIZE 1024

Object *stack[STACK_SIZE];
int stack_pointer = 0;

void push(Object *obj) {
    if (stack_pointer >= STACK_SIZE) error("Stack overflow");
    stack[stack_pointer++] = obj;
}

Object* pop() {
    if (stack_pointer == 0) error("Stack underflow");
    return stack[--stack_pointer];
}
```

This will simulate the **machine stack** used by the evaluator.

---

### 4. **Registers**

Define key registers used by the evaluator:

```c
Object *exp;       // current expression
Object *env;        // current environment
Object *val;        // result of evaluation
Object *continue;   // label to jump to
Object *proc;       // procedure being applied
Object *argl;       // list of evaluated arguments
```

These correspond directly to the evaluator's register machine model.

---

## 🎯 Part 2: Implement Key Primitives

Implement primitive operations as C functions returning `Object*`:

```c
Object* op_add(Object *x, Object *y) {
    if (x->type != TYPE_NUMBER || y->type != TYPE_NUMBER)
        error("ADD: expected numbers");
    Object *res = make_number(x->number + y->number);
    return res;
}

Object* op_cons(Object *a, Object *d) {
    Pair *p = malloc(sizeof(Pair));
    p->type = TYPE_PAIR;
    p->car = a;
    p->cdr = d;
    return (Object*)p;
}

Object* op_car(Object *p) {
    if (p->type != TYPE_PAIR)
        error("CAR: not a pair");
    return ((Pair*)p)->car;
}

Object* op_cdr(Object *p) {
    if (p->type != TYPE_PAIR)
        error("CDR: not a pair");
    return ((Pair*)p)->cdr;
}
```

Also implement:
- `lookup-variable-value`
- `set-variable-value!`
- `extend-environment`
- `make-procedure`, `apply`, etc.

---

## ⚙️ Part 3: Implement the Evaluator Loop

Create a function that simulates the **controller instructions** from the evaluator.

Here’s a simplified version of the main loop:

```c
void eval_loop() {
    while(1) {
        printf("Scheme> ");
        exp = read_input();  // parse user input into object
        val = eval(exp, global_env);  // evaluate expression
        print(val);           // print result
    }
}
```

Where `eval()` implements dispatching based on expression type:

```c
Object* eval(Object *exp, Environment *env) {
    if (is_self_evaluating(exp)) return exp;
    if (is_variable(exp)) return lookup_variable_value(exp, env);

    if (is_quoted(exp)) {
        return text_of_quotation(exp);
    }

    if (is_assignment(exp)) {
        return eval_assignment(exp, env);
    }

    if (is_definition(exp)) {
        return eval_definition(exp, env);
    }

    if (is_if(exp)) {
        return eval_if(exp, env);
    }

    if (is_lambda(exp)) {
        return make_compound_procedure(lambda_parameters(exp), lambda_body(exp), env);
    }

    if (is_application(exp)) {
        proc = eval(operator(exp), env);
        argl = list_of_values(operands(exp), env);
        return apply(proc, argl);
    }

    error("Unknown expression type -- EVAL", exp);
}
```

---

## 🛠️ Part 4: Implement Apply

Apply handles both primitive and compound procedures:

```c
Object* apply(Object *proc, Object *args) {
    if (is_primitive_procedure(proc)) {
        return apply_primitive_procedure(proc, args);
    } else if (is_compound_procedure(proc)) {
        Environment *new_env = extend_environment(
            procedure_parameters(proc),
            args,
            procedure_environment(proc)
        );
        return eval(procedure_body(proc), new_env);
    } else {
        error("Unknown procedure type -- APPLY", proc);
    }
}
```

Compound procedures require environment extension and body evaluation.

---

## 🧪 Example: Run Factorial in Your New Interpreter

Once all pieces are in place, you can run:

```scheme
(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1))))

(factorial 5)
→ 120
```

But your system must now:
- Parse the code into internal representation
- Compile it or interpret it using your evaluator
- Manage environments and stacks manually
- Handle recursion and tail calls correctly

All in **pure C**, with no Scheme underneath

✅ This is a major milestone!

---

## 🧱 Part 5: Memory Management

Since we’re working in C, we need to manage memory ourselves.

### 1. **Memory Allocation**

Implement routines like:

```c
Object* make_number(int n) {
    Object *o = malloc(sizeof(Object));
    o->type = TYPE_NUMBER;
    o->number = n;
    return o;
}

Object* make_symbol(char *name) {
    Object *o = malloc(sizeof(Object));
    o->type = TYPE_SYMBOL;
    o->symbol = strdup(name);
    return o;
}
```

### 2. **Garbage Collection (Basic)**

At minimum, use a **mark-and-sweep GC** strategy:
- Traverse all reachable objects
- Mark them as live
- Free unmarked ones periodically

Or start with a fixed-size heap and error on out-of-memory.

---

## 📊 Summary Table

| Feature | Description |
|--------|-------------|
| Goal | Implement Scheme interpreter in C |
| Strategy | Use tagged structs, simulate registers and stack |
| Key Registers | `exp`, `env`, `val`, `continue`, `proc`, `argl` |
| Environments | Linked list of frames with variables and values |
| Stack | Array-based, supports recursive calls |
| Memory Model | Manual allocation, optional garbage collection |
| Real-World Analogy | Like building a small VM |
| Performance | Slower than native Scheme |
| Educational Value | High – shows full interpreter design |

---

## 💡 Final Thought

This exercise gives hands-on experience with:
- How interpreters are structured at the lowest level
- How register machines simulate high-level logic
- And how memory and control flow work together

By implementing the evaluator in C:
- You gain fine-grained control over execution
- You understand how higher-level constructs map to lower-level logic
- And you learn how real-world interpreters like Python, Ruby, and JavaScript engines are built

It’s a great way to explore:
- Language implementation
- Virtual machines
- Compilers and interpreters

And serves as a strong foundation for more advanced projects like:
- Building a JIT compiler
- Writing a Scheme-to-C translator
- Or even bootstrapping a new language
