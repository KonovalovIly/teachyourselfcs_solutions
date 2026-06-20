# LeetCode
1. https://leetcode.com/problems/daily-temperatures/
``` c
int* dailyTemperatures(int* temperatures, int temperaturesSize, int* returnSize) {

    int* answer = (int*)calloc(temperaturesSize, sizeof(int));
    int* stack = (int*)malloc(sizeof(int) * temperaturesSize);
    int top = -1;

    for (int i = 0; i < temperaturesSize; i++) {
        while (top >= 0 && temperatures[i] > temperatures[stack[top]]) {
            int prevIndex = stack[top--];
            answer[prevIndex] = i - prevIndex;
        }
        stack[++top] = i;
    }

    free(stack);
    *returnSize = temperaturesSize;
    return answer;
}
```
2.  https://leetcode.com/problems/rotate-list/
``` c
struct ListNode* rotateRight(struct ListNode* head, int k) {
    int count = 0;
    struct ListNode* temp = head;
    int total = 0;
  
    while(temp != NULL) {
        temp = temp->next;
        total ++;
    }

    if (total == 0 || total == k) {
        return head;
    }

    k = k % total;

    while (count < k) {
        temp = head;
        while (temp->next->next != NULL) {
            temp = temp->next;
        }
        struct ListNode* final = temp->next;
        temp->next = NULL;
        final->next = head;
        head = final;
        count++;
    }
    return head;

}
```
3. https://leetcode.com/problems/wiggle-sort-ii/
``` c
#include <stdio.h>
#include <stdlib.h>

int compare_ints(const void *a, const void *b) {
    int arg1 = *(const int *)a;
    int arg2 = *(const int *)b;
    if (arg1 < arg2) return -1;
    if (arg1 > arg2) return 1;
    return 0;
}

  

void wiggleSort(int* nums, int numsSize) {
    qsort(nums, numsSize, sizeof(int), compare_ints);
    int i = 1;
    int j = numsSize - 1;
    int* temp = (int*) calloc(numsSize, sizeof(int));
    while(i < numsSize) {
        temp[i] = nums[j];
        i+=2;
        j --;
    }

    i=0;
    while(i < numsSize) {
        temp[i] = nums[j];
        i+=2;
        j--;
    }

    for(int it = 0; it < numsSize; it++){
        nums[it] = temp[it];
    }
}
```
# HackerRank
