#include <getopt.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "cachelab.h"

// Cache line structure
typedef struct {
    int valid;
    int tag;
    int timestamp;  // For LRU
} CacheLine;

// Global variables
int hit_count = 0;
int miss_count = 0;
int eviction_count = 0;
int verbose = 0;
char* trace_file = NULL;

int s = 0;  // Number of set index bits
int E = 0;  // Number of lines per set
int b = 0;  // Number of block offset bits
int S = 0;  // Number of sets

CacheLine** cache = NULL;

// Function prototypes
void print_usage();
void parse_arguments(int argc, char* argv[]);
void init_cache();
void free_cache();
void access_cache(unsigned long long address);
void process_trace();

int main(int argc, char* argv[]) {
    // Parse command line arguments
    parse_arguments(argc, argv);
    
    // Calculate number of sets
    S = 1 << s;
    
    // Initialize cache
    init_cache();
    
    // Process the trace file
    process_trace();
    
    // Print summary statistics
    printSummary(hit_count, miss_count, eviction_count);
    
    // Free allocated memory
    free_cache();
    
    return 0;
}

void parse_arguments(int argc, char* argv[]) {
    int opt;
    
    // Check if no arguments provided
    if (argc < 2) {
        print_usage();
        exit(0);
    }
    
    // Parse command line options
    while ((opt = getopt(argc, argv, "hvs:E:b:t:")) != -1) {
        switch (opt) {
            case 'h':
                print_usage();
                exit(0);
            case 'v':
                verbose = 1;
                break;
            case 's':
                s = atoi(optarg);
                break;
            case 'E':
                E = atoi(optarg);
                break;
            case 'b':
                b = atoi(optarg);
                break;
            case 't':
                trace_file = optarg;
                break;
            default:
                print_usage();
                exit(1);
        }
    }
    
    // Validate required arguments
    if (s <= 0 || E <= 0 || b <= 0 || trace_file == NULL) {
        printf("Error: Missing required arguments\n");
        print_usage();
        exit(1);
    }
}

void print_usage() {
    printf("Usage: ./csim [-hv] -s <num> -E <num> -b <num> -t <file>\n");
    printf("Options:\n");
    printf("  -h         Print this help message\n");
    printf("  -v         Optional verbose flag\n");
    printf("  -s <num>   Number of set index bits\n");
    printf("  -E <num>   Number of lines per set\n");
    printf("  -b <num>   Number of block offset bits\n");
    printf("  -t <file>  Trace file\n");
}

void init_cache() {
    // Allocate memory for cache
    cache = (CacheLine**)malloc(sizeof(CacheLine*) * S);
    
    for (int i = 0; i < S; i++) {
        cache[i] = (CacheLine*)malloc(sizeof(CacheLine) * E);
        
        // Initialize each cache line
        for (int j = 0; j < E; j++) {
            cache[i][j].valid = 0;
            cache[i][j].tag = 0;
            cache[i][j].timestamp = 0;
        }
    }
}

void free_cache() {
    if (cache != NULL) {
        for (int i = 0; i < S; i++) {
            free(cache[i]);
        }
        free(cache);
    }
}

void access_cache(unsigned long long address) {
    // Extract set index and tag from address
    unsigned long long set_index = (address >> b) & ((1 << s) - 1);
    unsigned long long tag = address >> (b + s);
    
    // Check if address is in cache
    for (int i = 0; i < E; i++) {
        if (cache[set_index][i].valid && cache[set_index][i].tag == tag) {
            // Cache hit
            hit_count++;
            if (verbose) printf("hit ");
            cache[set_index][i].timestamp = hit_count + miss_count + eviction_count;
            return;
        }
    }
    
    // Cache miss
    miss_count++;
    if (verbose) printf("miss ");
    
    // Find an invalid line first
    for (int i = 0; i < E; i++) {
        if (!cache[set_index][i].valid) {
            // Use invalid line
            cache[set_index][i].valid = 1;
            cache[set_index][i].tag = tag;
            cache[set_index][i].timestamp = hit_count + miss_count + eviction_count;
            return;
        }
    }
    
    // Cache is full - need to evict using LRU
    eviction_count++;
    if (verbose) printf("eviction ");
    
    // Find LRU line
    int lru_index = 0;
    int min_timestamp = cache[set_index][0].timestamp;
    
    for (int i = 1; i < E; i++) {
        if (cache[set_index][i].timestamp < min_timestamp) {
            min_timestamp = cache[set_index][i].timestamp;
            lru_index = i;
        }
    }
    
    // Evict LRU line and load new block
    cache[set_index][lru_index].tag = tag;
    cache[set_index][lru_index].timestamp = hit_count + miss_count + eviction_count;
}

void process_trace() {
    FILE* file = fopen(trace_file, "r");
    
    if (file == NULL) {
        printf("Error: Could not open trace file '%s'\n", trace_file);
        exit(1);
    }
    
    char operation;
    unsigned long long address;
    int size;
    
    // Read trace file
    while (fscanf(file, " %c %llx,%d", &operation, &address, &size) == 3) {
        if (verbose) {
            printf("%s %llx,%d ", &operation, address, size);
        }   
        switch (operation) {
            case 'I':  // Instruction load
                // Skip instruction loads
                break;
            case 'L':  // Data load
            case 'S':  // Data store
                access_cache(address);
                break;
            case 'M':  // Data modify
                // Modify = data load + data store
                access_cache(address);
                access_cache(address);
                break;
        }
        
        if (verbose) {
            printf("\n");
        }
    }
    
    fclose(file);
}