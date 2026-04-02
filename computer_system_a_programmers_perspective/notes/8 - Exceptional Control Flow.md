# Chapter 8 Exceptional Control Flow
[[Practice Problems 8]]
8.1 Exceptions
    8.1.1 Exception Handling
    8.1.2 Classes of Exceptions
    8.1.3 Exceptions in Linux/x86-64 Systems
8.2 Processes
    8.2.1 Logical Control Flow
    8.2.2 Concurrent Flows
    8.2.3 Private Address Space
    8.2.4 User and Kernel Modes
    8.2.5 Context Switches
8.3 System Call Error Handling
    System functions return -1 to programm then error accured
8.4 Process Control
    Important functions for manipulating process
    8.4.1 Obtaining Process IDs
        Each function has pid witch represent unique nonzero process ID
    8.4.2 Creating and Terminating Processes
        We can create child which will execute the same code or the special one by calling fork.
    8.4.3 Reaping Child Processes
        When Child is terminated it became a zombie and we can call it again. 
    8.4.4 Putting Processes to Sleep
        We can put process in sleep
    8.4.5 Loading and Running Programs
        We can load anouther program and run it inside our
    8.4.6 Using fork and execve to Run Programs
        Shell comands execution is example
8.5 Signals
    Signal for interrupt and terminate our program
    8.5.1 Signal Terminology
        Signal handling an sending terminology
    8.5.2 Sending Signals
        How we send signals to gpid or pid
    8.5.3 Receiving Signals
        We can redefine some actions on signal if it not terminate signal
    8.5.4 Blocking and Unblocking Signals
        Interrupting and wait the signal
    8.5.5 Writing Signal Handlers
        Way to write handlers then it neaded and then it nessasary
    8.5.6 Synchronizing Flows to Avoid Nasty Concurrency Bugs
        You should keep in mind all asynchronys hadlers of process.
    8.5.7 Explicitly Waiting for Signals
        Bast way to wait then some action happend in child process
8.6 Nonlocal Jumps
    Jumps allways were complex instruction and we should be more attended them
8.7 Tools for Manipulating Processes
    Usefull tools for manipulating process like trace
8.8 Summary
    From this chapter our focuse moved from hardware to software and how our programms interact with OS