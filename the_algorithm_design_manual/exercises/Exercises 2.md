# LeetCode
1. https://leetcode.com/problems/remove-k-digits/
``` c
char* removeKdigits(char* num, int k) {
    int n = strlen(num);
    int i;
    if (n == k){
        char* res = malloc(2);
        strcpy(res, "0");
        return res;
    }

    char* stack = (char*) malloc(n+1);
    int top = -1;
    int popped = 0;
  
    for (i = 0; i < n; i++) {
        while(top >= 0 && stack[top] > num[i] && popped < k) {
            top --;
            popped ++;
        }
        stack[++top] = num[i];
    }

    while (popped <k) {
        top --;
        popped ++;
    }

    i = 0;
    while (i <= 0 && stack[i] == '0') i++;

    if(i>top) {
        char* res = malloc(2);
        strcpy(res, "0");
        free(stack);
        return res;
    }
    char* res = (char*)malloc(top - i + 2);
    strncpy(res, stack + i, top - i + 1);
    res[top - i + 1] = '\0';
  
    free(stack);
    return res;

}
```
2.  https://leetcode.com/problems/counting-bits/
``` c
int* countBits(int n, int* returnSize) {
    int* result = (int*) calloc(sizeof(int), n+1);
    for(int i = 1; i<=n; ++i) {
        result[i] = result[i/2] + i%2;
    }
    *returnSize = n+1;
    return result;
}
```
3. https://leetcode.com/problems/4sum/
``` c
int compare(const void* a, const void *b) {
    return (*(int*)a - *(int*)b);
 }
int** fourSum(int* nums, int numsSize, int target, int* returnSize, int** returnColumnSizes) {
    int** ans = NULL;
    *returnSize = 0;
    qsort(nums, numsSize, sizeof(int), compare);
    for (int i = 0; i < numsSize - 3; i++) {
        if (i > 0 && nums[i] == nums[i - 1]) continue;
        for (int j = i + 1; j < numsSize - 2; j++) {
            if (j > i + 1 && nums[j] == nums[j - 1]) continue;
            long long newTarget = (long long)target - nums[i] - nums[j];
            int low = j + 1, high = numsSize - 1;
            while(low < high) {
                long long sum = (long long)nums[low] + nums[high];
                if(sum < newTarget) {
                    low++;
                } else if (sum > newTarget) {
                    high--;
                }    else {
                    (*returnSize)++;
                    ans =(int**)realloc(ans, (*returnSize) * sizeof(int*));
                    ans[*returnSize - 1] = (int*)malloc(4 * sizeof(int*));
                    ans[*returnSize - 1][0] = nums[i];
                    ans[*returnSize - 1][1] = nums[j];
                    ans[*returnSize - 1][2] = nums[low];
                    ans[*returnSize - 1][3] = nums[high];
                    while(low < high && nums[low] == nums[low + 1]) low++;
                    while(low < high && nums[high] == nums[high - 1]) high--;
                    low++;
                    high--;
                }        
        }
    }
    }
    *returnColumnSizes = (int*)malloc(*returnSize * sizeof(int));
    for(int i = 0; i < *returnSize; i++) {
        (*returnColumnSizes)[i] = 4;
    }
    return ans;
}
```

