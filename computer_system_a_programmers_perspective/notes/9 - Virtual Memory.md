# Chapter 9 Virtual Memory
[[Practice Problems 9]]
Virtual memory key abstraction between hardwary memory and programm 
9.1 Physical and Virtual Addressing
    Difference between virtual and physical adresses
9.2 Address Spaces
    Naming concept
9.3 VM as a Tool for Caching
    Virtual Memory helps with caching our data from disk
    9.3.1 DRAM Cache Organization
        How DRAM caches work
    9.3.2 Page Tables
        Data stored by buckets
    9.3.3 Page Hits
        When cpu read a word witch contains in virtual page
    9.3.4 Page Faults
        What happends when cpu read a word witch doesnt contains in virtual page
    9.3.5 Allocating Pages
        How MMU allocate new page
    9.3.6 Locality to the Rescue Again
        Programs naturally exhibit spatial and temporal locality, which makes virtual memory caching effective because most accesses are to a small working set of pages.
9.4 VM as a Tool for Memory Management
    Virtual memory simplifies memory management by allowing the operating system to map disjoint physical pages into contiguous virtual address spaces, enabling efficient sharing and allocation.
9.5 VM as a Tool for Memory Protection
    Virtual memory enforces protection by adding permission bits (read, write, execute) to page table entries, preventing processes from accessing unauthorized memory.
9.6 Address Translation
    Address translation is the process by which the MMU converts a virtual address to a physical address using page tables, a process that must be fast and efficient.
    9.6.1 Integrating Caches and VM
        Modern systems integrate caches with virtual memory by using physical addresses for cache lookups after translation, or by using virtual addresses in specialized caches.
    9.6.2 Speeding Up Address Translation with a TLB
        The TLB is a small, fast cache inside the MMU that stores recent virtual-to-physical address translations to avoid slow page-table walks.
    9.6.3 Multi-Level Page Tables
        Multi-level page tables compress the page table structure by keeping only the levels that are actually needed, drastically reducing memory overhead for sparse address spaces.
    9.6.4 Putting It Together: End-to-End Address Translation
        The complete address translation path involves the CPU generating a virtual address, the TLB checking for a cached translation, a page-table walk if needed, and finally accessing the physical memory or handling a page fault.
9.7 Case Study: The Intel Core i7/Linux Memory System
    The Core i7 uses a combination of multi-level page tables, TLBs, and hardware-managed caches to efficiently implement the Linux virtual memory model.
    9.7.1 Core i7 Address Translation
        The Core i7 performs address translation using a four-level page table structure, with dedicated TLBs for instructions and data.
    9.7.2 Linux Virtual Memory System
        The Linux kernel organizes a process’s virtual memory into regions (e.g., heap, stack, code) and manages page tables, page faults, and memory mapping through a unified interface.
9.8 Memory Mapping
    Memory mapping allows files or devices to be mapped directly into a process’s virtual address space, enabling efficient file I/O and shared memory.
    9.8.1 Shared Objects Revisited
        Shared objects (like shared libraries) can be mapped into multiple processes’ address spaces at once, with page tables pointing to the same physical frames to save memory.
    9.8.2 The fork Function Revisited
        The fork function uses copy-on-write semantics, where the child’s page tables point to the parent’s pages until either one modifies a page, at which point a private copy is made.
    9.8.3 The execve Function Revisited
        The execve function replaces the current process’s virtual memory layout by mapping in the new program’s code, data, and stack segments.
    9.8.4 User-Level Memory Mapping with the mmap Function
        The mmap function provides a portable way for user programs to create new memory regions by mapping files or anonymous memory directly into their address space.
9.9 Dynamic Memory Allocation
    Dynamic memory allocation manages the heap at runtime, allowing programs to request and release memory blocks through interfaces like malloc and free.
    9.9.1 The malloc and free Functions
        malloc allocates a block of memory from the heap, while free releases it back to the allocator for reuse
    9.9.2 Why Dynamic Memory Allocation?
        Dynamic allocation is essential when the size of data structures is not known until runtime, such as for linked lists, trees, or variable-sized inputs.
    9.9.3 Allocator Requirements and Goals
        Allocators must balance throughput, memory utilization, and fragmentation while maintaining alignment and handling arbitrary request patterns.
    9.9.4 Fragmentation
        Fragmentation occurs when free memory is broken into small, unusable pieces—internal fragmentation from overhead and external fragmentation from scattered free blocks.
    9.9.5 Implementation Issues
        Key allocator design choices include placement policies, splitting, coalescing, tracking free blocks, and requesting more heap memory from the OS.
    9.9.6 Implicit Free Lists
        An implicit free list uses a header in each block to store its size and allocation status, and traverses memory sequentially to find free blocks.
    9.9.7 Placing Allocated Blocks
        Placement policies (e.g., first fit, best fit, next fit) determine which free block is selected for an allocation request, affecting fragmentation and speed.
    9.9.8 Splitting Free Blocks
        When a free block is larger than needed, the allocator splits it into an allocated portion and a smaller free remainder.
    9.9.9 Getting Additional Heap Memory
        When no free block is large enough, the allocator requests more memory from the operating system (e.g., using sbrk or mmap) and appends it to the heap.
    9.9.10 Coalescing Free Blocks
        Coalescing merges adjacent free blocks to form larger contiguous free regions, mitigating external fragmentation.
    9.9.11 Coalescing with Boundary Tags
        Boundary tags add headers and footers to each block so that the allocator can easily check the status of adjacent blocks when freeing memory.
    9.9.12 Putting It Together: Implementing a Simple Allocator
        A simple allocator combines an implicit free list, first-fit placement, splitting, and boundary-tag coalescing to create a functional heap manager.
    9.9.13 Explicit Free Lists
        An explicit free list stores pointers to the next and previous free blocks within the free blocks themselves, allowing O(1) traversal of only free blocks for faster allocations.
    9.9.14 Segregated Free Lists
        Segregated free lists maintain separate lists for blocks of different size classes, improving allocation speed and reducing fragmentation by matching requests to appropriately sized pools.
9.10 Garbage Collection
    Garbage collection automatically reclaims memory that is no longer reachable by the program, freeing the programmer from explicit deallocation.
    9.10.1 Garbage Collector Basics
        A garbage collector treats memory as a directed graph of objects and identifies reachable (live) objects starting from a set of roots (e.g., registers, stack pointers).
    9.10.2 Mark&Sweep Garbage Collectors
        The mark phase traverses the object graph to mark reachable objects, and the sweep phase returns unmarked blocks to the free list.
    9.10.3 Conservative Mark&Sweep for C Programs
        Conservative garbage collectors for C assume that any value that looks like a pointer might be one, allowing them to operate without perfect type information.
9.11 Common Memory-Related Bugs in C Programs
    This section catalogs typical pitfalls that lead to crashes, corruption, or security vulnerabilities in C programs.
    9.11.1 Dereferencing Bad Pointers
        Using an uninitialized, NULL, or invalid pointer causes undefined behavior and often a segmentation fault.
    9.11.2 Reading Uninitialized Memory
        Accessing heap or stack memory before writing to it yields unpredictable values, leading to subtle bugs.
    9.11.3 Allowing Stack Buffer Overflows
        Writing past the bounds of a stack-allocated array can overwrite return addresses, enabling security exploits.
    9.11.4 Assuming That Pointers and the Objects They Point to Are the Same Size
        Misusing sizeof on a pointer instead of the pointed-to type leads to insufficient allocation or incorrect pointer arithmetic.
    9.11.5 Making Off-by-One Errors
        Iterating one element too far past the end of an array results in buffer overflows or corrupted data.
    9.11.6 Referencing a Pointer Instead of the Object It Points To
        Accidentally using a pointer’s address (e.g., forgetting *) causes logical errors or memory corruption.
    9.11.7 Misunderstanding Pointer Arithmetic
        Adding integers to pointers scales by the pointed-to type size, leading to unexpected offsets if misapplied.
    9.11.8 Referencing Nonexistent Variables
        Returning the address of a local variable from a function leaves the caller with a dangling pointer to invalid stack memory.
    9.11.9 Referencing Data in Free Heap Blocks
        Using a pointer after it has been passed to free can cause corruption or crashes if the memory has been reallocated.
    9.11.10 Introducing Memory Leaks
        Failing to free heap-allocated memory causes the process’s memory footprint to grow unbounded, potentially exhausting system resources.
9.12 Summary
    Virtual memory provides a powerful abstraction that decouples programs from physical memory, enabling efficient caching, simplified memory management, and robust protection, while dynamic memory management and careful programming are essential to avoid common pitfalls.