[[Practice Problems 12]]
Why sync programms is bad idea
12.1 Concurrent Programming with Processes
	Base implementation of concurrent programming it creating a new process
	12.1.1 A Concurrent Server Based on Processes
		How it will be on our server implememntation
	12.1.2 Pros and Cons of Processes
		The main disadwantages is this memory heavy and we cant share memory between processes
12.2 Concurrent Programming with I/O Multiplexing
	Mechanizm from os wich build on top of discriptor availability
	12.2.1 A Concurrent Event-Driven Server Based on I/O Multiplexing
		How it will lock at our web server
	12.2.2 Pros and Cons of I/O Multiplexing
		Huge compexity of this code
12.3 Concurrent Programming with Threads
	More lightweight when process and more easy to impolement
	12.3.1 Thread Execution Model
		Schema how it execute
	12.3.2 Posix Threads
		 Standard interface for manipulating threads from C programs
	12.3.3 Creating Threads
		pthread_create function for create thread
	12.3.4 Terminating Threads
		pthread_exit for terminating process or pthread_cancel for terminating thread
	12.3.5 Reaping Terminated Threads
		pthread_join function for wait result of thread work
	12.3.6 Detaching Threads
		pthread_detach function for detach thread from current process
	12.3.7 Initializing Threads
		pthread_once function allows you to initialize the state associated with a thread routine
	12.3.8 A Concurrent Server Based on Threads
		Example of out service in thread implementation
12.4 Shared Variables in Threaded Programs
	Why it is important 
	12.4.1 Threads Memory Model
		A pool of concurrent threads runs in the context of a process
	12.4.2 Mapping Variables to Memory
		Types of variable and how they shared between threads
	12.4.3 Shared Variables
		Wich type of variable we can share
12.5 Synchronizing Threads with Semaphores
	Semaphore is basis for syncronization to variable
	12.5.1 Progress Graphs
		How it may locks like then two tread work together on graph
	12.5.2 Semaphores
		How semapthore lock in C
	12.5.3 Using Semaphores for Mutual Exclusion
		Mutex is binary semaphore
	12.5.4 Using Semaphores to Schedule Shared Resources
		Producer consumer and reader writer problems 
	12.5.5 Putting It Together: A Concurrent Server Based on Prethreading
		Result of combining rules for concurrent programm
12.6 Using Threads for Parallelism
	Is more threads allways better?
12.7 Other Concurrency Issues
	Other thing that should attract our attention
	12.7.1 Thread Safety
		Is class or function thread safe?
	12.7.2 Reentrancy
		What Reentrancy is?
	12.7.3 Using Existing Library Functions in Threaded Programs
		Is existed libraries thread safe and what we should do if not
	12.7.4 Races
		What race is in concurrent programming
	12.7.5 Deadlocks 
		When two treads or more locked on the same recourse and cant pass 
12.8 Summary
	We cover basis for concurrent programming in C lang