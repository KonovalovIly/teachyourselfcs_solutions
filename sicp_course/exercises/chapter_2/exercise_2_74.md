### **Exercise 2.74: Data-Directed Strategy for Insatiable Enterprises**

#### **Core Idea**
Use **data-directed programming** to:
1. **Tag** each division's file with its division type (e.g., `'division1`, `'division2`).
2. **Store** division-specific procedures in a central table.
3. **Dispatch** operations (like `get-record`) based on the division tag.

---

### **Part A: `get-record` Procedure**
**Goal**: Retrieve an employee's record from any division's file.

#### **Division File Structure**
Each division's file must:
1. **Be tagged** with its division type (e.g., `'division1`).
2. **Implement** a division-specific `get-record` procedure.
3. **Expose** a consistent interface for headquarters.

**Example**:
```scheme
;; Division 1's file: List of (name . record) pairs
(define division1-file
  '(division1
    (("Alice" (address "123 Main St") (salary 50000)))
    (("Bob" (address "456 Park Ave") (salary 60000)))))

;; Division 2's file: Hash table keyed by name
(define division2-file
  '(division2
    #("Charlie" (address "789 Broadway") (salary 70000))))
```

#### **Implementation**
```scheme
(define (get-record employee-name file)
  (let ((division-type (car file))
        (data (cdr file)))
    ((get division-type 'get-record) data employee-name)))

;; Install division-specific procedures
(put 'division1 'get-record
     (lambda (data name)
       (assoc name data)))  ; Division 1 uses assoc

(put 'division2 'get-record
     (lambda (data name)
       (hash-ref data name))) ; Division 2 uses hash table
```

**Usage**:
```scheme
(get-record "Alice" division1-file) 
; => ("Alice" (address "123 Main St") (salary 50000))
```

---

### **Part B: `get-salary` Procedure**
**Goal**: Extract salary from any division's employee record.

#### **Record Structure Requirement**
Each division's record must:
1. **Be tagged** with its division type (e.g., `'division1-record`).
2. **Store salary** under a consistent key (`'salary`).

**Implementation**:
```scheme
(define (get-salary record)
  (let ((record-type (car record))
        (data (cdr record)))
    ((get record-type 'get-salary) data)))

;; Install record handlers
(put 'division1-record 'get-salary
     (lambda (data)
       (cadr (assoc 'salary data)))) ; Division 1: Nested alist

(put 'division2-record 'get-salary
     (lambda (data)
       (hash-ref data 'salary))) ; Division 2: Hash table
```

**Usage**:
```scheme
(define alice-record (get-record "Alice" division1-file))
(get-salary alice-record) ; => 50000
```

---

### **Part C: `find-employee-record` Procedure**
**Goal**: Search all divisions' files for an employee.

**Implementation**:
```scheme
(define (find-employee-record name files)
  (if (null? files)
      #f
      (let ((record (get-record name (car files))))
        (if record
            record
            (find-employee-record name (cdr files))))))
```

**Usage**:
```scheme
(find-employee-record "Bob" (list division1-file division2-file))
; => ("Bob" (address "456 Park Ave") (salary 60000))
```

---

### **Part D: Adding a New Division**
**Steps**:
1. **Define** the new division's file structure (e.g., `'division3`).
2. **Implement** and register:
   ```scheme
   (put 'division3 'get-record ...)
   (put 'division3-record 'get-salary ...)
   ```
3. **Add** the file to the list of divisions:
   ```scheme
   (define division3-file '(division3 ...))
   (set! all-files (cons division3-file all-files))
   ```

**No changes** needed to existing headquarters procedures!

---

### **Key Takeaways**
1. **Data-Directed Design**:
   - **Tags** (e.g., `'division1`) enable polymorphic dispatch.
   - **Central table** maps operations to division-specific implementations.
2. **Minimal Coupling**:
   - Divisions retain autonomy in file/record structure.
   - Headquarters works with a consistent interface.
3. **Extensibility**:
   - New divisions can be added without modifying core logic.

This strategy balances **centralized control** with **decentralized implementation**. 🌐