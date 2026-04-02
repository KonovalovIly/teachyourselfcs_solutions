## Problem 1

| Dotted-decimal address | Hex address |
| ---------------------- | ----------- |
| 107.212.122.205        | 0x6BD47ACD  |
| 64.12.149.13           | 0x400C950D  |
| 107.212.96.29          | 0x6BD4601D  |
| 0.0.0.128              | 0x00000080  |
| 255.255.255.0          | 0xFFFFFF00  |
| 10.1.1.64              | 0x0A010140  |

## Problem 2
``` c
#include "csapp.h"

int main(int argc, char **argv)
{
	struct in_addr inaddr; /* Address in network byte order */
	uint16_t addr; /* Address in host byte order */
	char buf[MAXBUF]; /* Buffer for dotted-decimal string */
	
	if (argc != 2) {
		fprintf(stderr, "usage: %s <hex number>\n", argv[0]);
		exit(0);
	}
	
	sscanf(argv[1], "%x", &addr);
	inaddr.s_addr = htons(addr);
	if (!inet_ntop(AF_INET, &inaddr, buf, MAXBUF))
	{
		unix_error("inet_ntop");
	}
	printf("%s\n", buf);
	exit(0);
}
```
## Problem 3
``` c
#include "csapp.h"

int main(int argc, char **argv)
{
	struct in_addr inaddr; /* Address in network byte order */
	int rc;
	
	if (argc != 2) {
		fprintf(stderr, "usage: %s <network byte order>\n", argv[0]);
		exit(0);
	}
	rc = inet_pton(AF_INET, argv[1], &inaddr);
	if (rc == 0)
		app_error("inet_pton error: invalid network byte order");
	else if (rc < 0)
		unix_error("inet_pton error");
	
	printf("0x%x\n", ntohs(inaddr.s_addr));
	exit(0);
}
```
## Problem 4
```c
#include "csapp.h"

int main(int argc, char **argv)
{
	struct addrinfo *p, *listp, hints;
	struct sockaddr_in *sockp;
	char buf[MAXLINE];
	int rc;
	
	if (argc != 2) {
		fprintf(stderr, "usage: %s <domain name>\n", argv[0]);
		exit(0);
	}
	
	/* Get a list of addrinfo records */
	memset(&hints, 0, sizeof(struct addrinfo));
	hints.ai_family = AF_INET; /* IPv4 only */
	hints.ai_socktype = SOCK_STREAM; /* Connections only */
	if ((rc = getaddrinfo(argv[1], NULL, &hints, &listp)) != 0) {
		fprintf(stderr, "getaddrinfo error: %s\n", gai_strerror(rc));
		exit(1);
	}
	
	/* Walk the list and display each associated IP address */
	for (p = listp; p; p = p->ai_next) {
		sockp = (struct sockaddr_in *)p->ai_addr;
		Inet_ntop(AF_INET, &(sockp->sin_addr), buf, MAXLINE);
		printf("%s\n", buf);
	}
	
	Freeaddrinfo(listp);
	exit(0);
}
```

## Problem 5
Before the process that runs the CGI program is loaded, a Linux dup2 function
is used to redirect standard output to the connected descriptor that is associated
with the client. Thus, anything that the CGI program writes to standard output
goes directly to the client.

