## Problem 1
AB - asynch
AC - synch
BC - asynch

## Problem 2
A. 8 9
B. 10

## Problem 3
936036 or 9036364

## Problem 4
A 7
B Start 0 1 Child Stop 1 Stop

## Problem 5
unsigned int wakeup(unsigned int secs) {
	unsigned int rc = sleep(secs);
	printf("Woke up at %d secs.\n", secs-rc+1);
	return rc;
}

## Problem 6
#include "csapp.h"

int main(int argc, char *argv[], char *envp[])
{
	int i;
	printf("Command-line arguments:\n");
	for (I = 0; argv[I] != NULL; I++) {
		printf(«	argv[%2d]: $s \n», I, argv[I] );
	} 
	printf(«\n»);
	printf(«Environment variables: \n»);
	for (I = 0; envp[I] != NULL; I++) {
		printf(«	envp[%2d]: $s \n», I, argv[I] );
	} 
	exit(0);
}

## Problem 7
#include «csapp.h»


Void handler(int sig)
{
	return;
}

Unsigned int snooze(unsigned int secs)
{
	unsigned int rc = sleep(secs);
	printf(«Slept for $d of $d secs.\n» secs - rc, secs);
	return rc;
}

Int main (int args, char **argv)
{
	if ( argc != 2) {
		fprintf(stderr, «usage: %s <secs>\n»,argv[0]);
		exit(0);
	}

	if(signal(SIGINT, handler) == SIG_ERR)
		unix_error(«signal error\n»);
	
    (void) snooze (atoi(argv[1]));

	exit(0);
}

## Problem 8
213