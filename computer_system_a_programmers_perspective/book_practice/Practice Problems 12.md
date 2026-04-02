## Problem 1
Whentheparent process on the concurrent server starts executing, the reference counter increments from 0 to 1 for the associated file table. When this parent process forks the child process, the reference counter is incremented from 1 to 2. When the parent closes its copy of the descriptor, the reference count is decremented from 2 to 1. Similarly, when the child’s end of connection closes, the reference counter is decremented from 1 to 0.
## Problem 2
Whenaprocess terminates for any reason, the kernel closes all open descriptors. Thus,theparent’scopyoftheconnectedfiledescriptorwillbeclosedautomatically when the parent exits
## Problem 3
Recall that the echo function from Figure 11.22 echoes each line from the client until the client loses its end of the connection. If Ctrl+D is typed when the echo function is under execution, the server would consider it to be the EOF and may assumethattheclienthascloseditsendofconnectionandhence,maystopechoing back to the client.
## Problem 4
pool.nreadyisanintegervariable.Wereinitialize the pool.nreadyvariablewith the value obtained fromthecalltoselectsoastostorethetotalnumberofready descriptors returned by select.
## Problem 5
Yes
## Problem 6
![[Pasted image 20260402104736.png]]
## Problem 7
![[Pasted image 20260402104748.png]]
## Problem 8
A. H1,L1,U1,S1,H2,L2,U2,S2,T2,T1: safe 
B. H2,L2,H1,L1,U1,S1,T1,U2,S2,T2: unsafe 
C. H1,H2,L2,U2,S2,L1,U1,S1,T1,T2: safe
## Problem 9
A. p=1, c=1, n>1: Yes, the mutex semaphore is necessary because the producer and consumer can concurrently access the buffer. 
B. p=1, c=1, n=1: No, the mutex semaphore is not necessary in this case, because a nonempty buffer is equivalent to a full buffer. When the buffer contains an item, the producer is blocked. When the buffer is empty, the consumer is blocked. So at any point in time, only a single thread can access thebuffer, andthusmutualexclusionisguaranteedwithoutusingthemutex. 
C. p>1, c>1, n=1: No, the mutex semaphore is not necessary in this case either, by the same argument as the previous case.
## Problem 10
SupposethataparticularsemaphoreimplementationusesaLIFOstackofthreads for eachsemaphore.WhenathreadblocksonasemaphoreinaP operation,itsID is pushed onto the stack. Similarly, the V operation pops the top thread ID from the stack andrestarts that thread. Giventhisstackimplementation, anadversarial writer in its critical section could simply wait until another writer blocks on the semaphore before releasing the semaphore. In this scenario, a waiting reader might wait forever as two writers passed control back and forth. Notice that although it might seem moreintuitive to use a FIFOqueuerather than a LIFO stack, using such a stack is not incorrect and does not violate the semantics of the P and V operations.
## Problem 11
![[Pasted image 20260402104756.png]]
## Problem 12
The rand_rfunction is implicitly reentrant function, because it passes the param eter by reference; i.e., the parameter nextp and not by value. Explicit reentrant functions pass arguments only by value and all data references are to local auto matic stack variables.
## Problem 13
If we free the block immediately after the call to pthread_create in line 14, then wewill introduce a newrace, this time betweenthecallto freeinthemainthread and the assignment statement in line 24 of the thread routine.
## Problem 14
![[Pasted image 20260402104820.png]]
## Problem 15
A. Theprogress graph for the original program is shown in Figure 12.48 on the next page. 
B. The program always deadlocks, since any feasible trajectory is eventually trapped in a deadlock state. 
C. To eliminate the deadlock potential, initialize the binary semaphore t to 1 instead of 0. 
D. Theprogress graph for the corrected program is shown in Figure 12.49.