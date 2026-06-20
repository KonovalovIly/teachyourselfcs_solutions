1. https://leetcode.com/problems/random-pick-with-blacklist
```c
#include <stdlib.h>
#include <string.h>

typedef struct {
    int valid_count;          // количество разрешенных чисел = n - blacklistSize
    int* sorted_blacklist;    // отсортированный черный список (нужен для isBlack)
    int* map_keys;            // черные числа из левой части (ключи)
    int* map_values;          // соответствующие белые числа из хвоста (значения)
    int map_size;             // размер маппинга (сколько черных чисел в левой части)
    int blacklist_size;       // размер черного списка
} Solution;

int compare(const void* a, const void* b) {
    return *(int*)a - *(int*)b;
}

int isBlack(int* arr, int size, int target) {
    int left = 0, right = size - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] == target) return 1;
        if (arr[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return 0;
}

int findKey(int* keys, int size, int target) {
    int left = 0, right = size - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (keys[mid] == target) return mid;
        if (keys[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return -1;
}

Solution* solutionCreate(int n, int* blacklist, int blacklistSize) {
    Solution* obj = (Solution*)malloc(sizeof(Solution));
    obj->blacklist_size = blacklistSize;
    obj->valid_count = n - blacklistSize;
    obj->map_size = 0;
    
    obj->sorted_blacklist = (int*)malloc(blacklistSize * sizeof(int));
    memcpy(obj->sorted_blacklist, blacklist, blacklistSize * sizeof(int));
    qsort(obj->sorted_blacklist, blacklistSize, sizeof(int), compare);
    
    int* white_tail = (int*)malloc(blacklistSize * sizeof(int));
    int white_count = 0;
    
    for (int i = obj->valid_count; i < n; i++) {
        if (!isBlack(obj->sorted_blacklist, blacklistSize, i)) {
            white_tail[white_count++] = i;
        }
    }
    
    obj->map_keys = (int*)malloc(blacklistSize * sizeof(int));
    obj->map_values = (int*)malloc(blacklistSize * sizeof(int));
    
    int white_pos = 0;
    for (int i = 0; i < blacklistSize; i++) {
        int black_num = obj->sorted_blacklist[i];
        if (black_num < obj->valid_count) {
            obj->map_keys[obj->map_size] = black_num;
            obj->map_values[obj->map_size] = white_tail[white_pos++];
            obj->map_size++;
        }
    }
    
    free(white_tail);
    return obj;
}

int solutionPick(Solution* obj) {
    int r = rand() % obj->valid_count;
    
    int index = findKey(obj->map_keys, obj->map_size, r);
    
    if (index != -1) {
        return obj->map_values[index];
    }
    return r;
}

void solutionFree(Solution* obj) {
    free(obj->sorted_blacklist);
    free(obj->map_keys);
    free(obj->map_values);
    free(obj);
}
```
1. https://leetcode.com/problems/find-the-index-of-the-first-occurrence-in-a-string
``` c
void buildLPS(char* needle, int m, int* lps) {
    lps[0] = 0;
    int len = 0;
    int i = 1;
    while (i < m) {
        if (needle[i] == needle[len]) {
            len++;
            lps[i] = len;
            i++;
        } else {
            if (len > 0) {
                len = lps[len - 1];
            } else {
                lps[i] = 0;
                i++;
            }
        }
    }
}

int kmpSearch(char* haystack, char* needle, int* lps) {
    int n = strlen(haystack), m = strlen(needle);
    int i = 0, j = 0;
    while (i < n) {
        if (haystack[i] == needle[j]) {
            i++; j++;
        }
        if (j == m) return i - j;
        else if (i < n && haystack[i] != needle[j]) {
            if (j > 0) j = lps[j - 1];
            else i++;
        }
    }
    return -1;
}

int strStr(char* haystack, char* needle) {
    int n = strlen(haystack), m = strlen(needle);
    int lps[m];
    buildLPS(needle, m, lps);
    return kmpSearch(haystack, needle, lps);
}
```
3. https://leetcode.com/problems/random-point-in-non-overlapping-rectangles
```c
#include <stdlib.h>


typedef struct {
    int* weights;     // префиксные суммы
    int** rects;      // сами прямоугольники
    int rectsSize;    // количество прямоугольников
} Solution;


Solution* solutionCreate(int** rects, int rectsSize, int* rectsColSize) {
    Solution* sol = malloc(sizeof(Solution));
    sol->rects = rects;
    sol->rectsSize = rectsSize;
    sol->weights = malloc(sizeof(int) * rectsSize);
    
    int lastWeight = 0;
    for (int i = 0; i < rectsSize; i ++) {
        int weight = (rects[i][2] - rects[i][0] + 1) * (rects[i][3] - rects[i][1] + 1);
        lastWeight += weight;
        sol->weights[i] = lastWeight;
    }
    
    return sol;
}

int* solutionPick(Solution* obj, int* retSize) {
    int lastIndex = obj->weights[obj->rectsSize - 1];
    int r = rand() % lastIndex + 1;
    int lo = 0, hi = obj->rectsSize - 1;
    while (lo < hi) {
        int mid = (lo + hi) / 2;
        if (obj->weights[mid] < r) {
            lo = mid + 1;
        } else {
            hi = mid;  // возможно этот, ищем левее
        }
    }
    int* res = malloc(sizeof(int) * 2);
    *retSize = 2;

    res[0] = rand() % (obj->rects[lo][2] - obj->rects[lo][0] + 1) + obj->rects[lo][0];
    res[1] = rand() % (obj->rects[lo][3] - obj->rects[lo][1] + 1) + obj->rects[lo][1];
    return res;
}

void solutionFree(Solution* obj) {
    free(obj->weights);
    free(obj);
}
```