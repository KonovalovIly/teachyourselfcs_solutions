#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#define LISTENQ 1024
#define MAXLINE 8192
#define MAXHEADERS 1024

/* User-Agent header as required */
#define USER_AGENT "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120305 Firefox/10.0.3\r\n"

/* Read a line from a socket (used for reading request headers) */
ssize_t readline(int fd, char *buf, size_t maxlen) {
    size_t n = 0;
    char c;
    while (n < maxlen - 1) {
        if (recv(fd, &c, 1, 0) == 1) {
            buf[n++] = c;
            if (c == '\n')
                break;
        } else {
            return -1; // error or EOF
        }
    }
    buf[n] = '\0';
    return n;
}

/* Parse request line: method, URL, version */
int parse_request_line(char *line, char *method, char *url, char *version) {
    char *p = line;
    char *start = p;
    // method
    while (*p && *p != ' ') p++;
    if (!*p) return -1;
    strncpy(method, start, p - start);
    method[p - start] = '\0';
    // skip space
    while (*p == ' ') p++;
    start = p;
    while (*p && *p != ' ') p++;
    if (!*p) return -1;
    strncpy(url, start, p - start);
    url[p - start] = '\0';
    // skip space
    while (*p == ' ') p++;
    start = p;
    while (*p && *p != '\r' && *p != '\n') p++;
    strncpy(version, start, p - start);
    version[p - start] = '\0';
    return 0;
}

/* Parse URL into host, port, path */
void parse_url(char *url, char *host, int *port, char *path) {
    char *p = url;
    // skip http:// if present
    if (strncasecmp(p, "http://", 7) == 0)
        p += 7;
    
    // find host part (until '/' or ':')
    char *host_start = p;
    char *host_end = p;
    while (*host_end && *host_end != '/' && *host_end != ':')
        host_end++;
    
    strncpy(host, host_start, host_end - host_start);
    host[host_end - host_start] = '\0';
    
    // check for port
    *port = 80; // default
    if (*host_end == ':') {
        p = host_end + 1;
        char *port_start = p;
        while (*p && *p != '/') p++;
        char port_str[16];
        strncpy(port_str, port_start, p - port_start);
        port_str[p - port_start] = '\0';
        *port = atoi(port_str);
    } else {
        p = host_end;
    }
    
    // path
    if (*p == '\0')
        strcpy(path, "/");
    else
        strcpy(path, p);
}

/* Build new request to send to origin server */
void build_request(char *orig_request, char *host, int port, char *path, char *out) {
    char line[MAXLINE];
    char method[16], url[MAXLINE], version[16];
    char *saveptr;
    
    // parse first line of original request
    char *first_line = strtok_r(orig_request, "\r\n", &saveptr);
    if (!first_line) return;
    if (parse_request_line(first_line, method, url, version) != 0) return;
    
    // start with new request line: GET /path HTTP/1.0
    sprintf(out, "GET %s HTTP/1.0\r\n", path);
    
    // track whether we have seen a Host header
    int has_host = 0;
    
    // copy remaining headers, skip Proxy-Connection and Connection, but add our own later
    char *next_line;
    while ((next_line = strtok_r(NULL, "\r\n", &saveptr)) != NULL) {
        if (strncasecmp(next_line, "Proxy-Connection:", 17) == 0 ||
            strncasecmp(next_line, "Connection:", 11) == 0) {
            continue; // skip these, we will add our own
        }
        if (strncasecmp(next_line, "Host:", 5) == 0) {
            has_host = 1;
        }
        strcat(out, next_line);
        strcat(out, "\r\n");
    }
    
    // add required headers
    if (!has_host) {
        sprintf(line, "Host: %s\r\n", host);
        strcat(out, line);
    }
    strcat(out, USER_AGENT);
    strcat(out, "Connection: close\r\n");
    strcat(out, "Proxy-Connection: close\r\n");
    strcat(out, "\r\n");
}

/* Forward request to origin server and return response as a malloc'd string */
char *forward_request(char *host, int port, char *request) {
    int sockfd;
    struct sockaddr_in serveraddr;
    struct hostent *hp;
    char buf[MAXLINE];
    char *response = malloc(MAXLINE * 100); // large enough for typical responses
    if (!response) return NULL;
    response[0] = '\0';
    size_t total = 0;
    
    // create socket
    if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("socket error");
        free(response);
        return NULL;
    }
    
    // get server IP
    if ((hp = gethostbyname(host)) == NULL) {
        fprintf(stderr, "unknown host: %s\n", host);
        close(sockfd);
        free(response);
        return NULL;
    }
    
    bzero((char *) &serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_port = htons(port);
    
    // connect
    if (connect(sockfd, (struct sockaddr *)&serveraddr, sizeof(serveraddr)) < 0) {
        perror("connect error");
        close(sockfd);
        free(response);
        return NULL;
    }
    
    // send request
    if (send(sockfd, request, strlen(request), 0) != (ssize_t)strlen(request)) {
        perror("send error");
        close(sockfd);
        free(response);
        return NULL;
    }
    
    // read response until EOF
    int n;
    while ((n = recv(sockfd, buf, MAXLINE - 1, 0)) > 0) {
        buf[n] = '\0';
        size_t newlen = total + n + 1;
        char *newresp = realloc(response, newlen);
        if (!newresp) {
            free(response);
            close(sockfd);
            return NULL;
        }
        response = newresp;
        strcpy(response + total, buf);
        total += n;
    }
    close(sockfd);
    response[total] = '\0';
    return response;
}

/* Handle a single client connection */
void handle_client(int client_fd) {
    char request_buf[MAXHEADERS];
    char line[MAXLINE];
    char method[16], url[MAXLINE], version[16];
    char host[256], path[MAXLINE];
    int port;
    char *response;
    
    // read request headers until empty line
    request_buf[0] = '\0';
    while (1) {
        if (readline(client_fd, line, MAXLINE) <= 0) {
            close(client_fd);
            return;
        }
        strcat(request_buf, line);
        if (strcmp(line, "\r\n") == 0 || strcmp(line, "\n") == 0)
            break;
    }
    
    // parse first line
    char *first_line = strtok(request_buf, "\r\n");
    if (!first_line || parse_request_line(first_line, method, url, version) != 0) {
        const char *err = "HTTP/1.0 400 Bad Request\r\n\r\n";
        send(client_fd, err, strlen(err), 0);
        close(client_fd);
        return;
    }
    
    // only GET is allowed
    if (strcasecmp(method, "GET") != 0) {
        const char *err = "HTTP/1.0 501 Not Implemented\r\n\r\n";
        send(client_fd, err, strlen(err), 0);
        close(client_fd);
        return;
    }
    
    // parse URL
    parse_url(url, host, &port, path);
    
    // build new request for origin server
    char new_request[MAXLINE * 10];
    build_request(request_buf, host, port, path, new_request);
    
    // forward
    response = forward_request(host, port, new_request);
    if (response == NULL) {
        const char *err = "HTTP/1.0 502 Bad Gateway\r\n\r\n";
        send(client_fd, err, strlen(err), 0);
    } else {
        send(client_fd, response, strlen(response), 0);
        free(response);
    }
    close(client_fd);
}

int main(int argc, char **argv) {
    int listen_fd, client_fd;
    socklen_t client_len;
    struct sockaddr_in server_addr, client_addr;
    int port;
    
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <port>\n", argv[0]);
        exit(1);
    }
    port = atoi(argv[1]);
    
    // create listening socket
    listen_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (listen_fd < 0) {
        perror("socket error");
        exit(1);
    }
    
    // allow address reuse
    int optval = 1;
    setsockopt(listen_fd, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(optval));
    
    bzero((char *)&server_addr, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    server_addr.sin_port = htons(port);
    
    if (bind(listen_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("bind error");
        exit(1);
    }
    
    if (listen(listen_fd, LISTENQ) < 0) {
        perror("listen error");
        exit(1);
    }
    
    printf("Proxy listening on port %d\n", port);
    
    // sequential loop
    while (1) {
        client_len = sizeof(client_addr);
        client_fd = accept(listen_fd, (struct sockaddr *)&client_addr, &client_len);
        if (client_fd < 0) {
            perror("accept error");
            continue;
        }
        printf("Accepted connection from %s:%d\n",
               inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));
        handle_client(client_fd);
    }
    
    close(listen_fd);
    return 0;
}