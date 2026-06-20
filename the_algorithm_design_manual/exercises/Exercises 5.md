1. https://leetcode.com/problems/median-of-two-sorted-arrays
```c
long long INF = (long long)2e18;

double findMedianSortedArrays(int* nums1, int nums1Size, int* nums2, int nums2Size) {
    // Всегда ищем по меньшему массиву
    if (nums1Size > nums2Size) {
        return findMedianSortedArrays(nums2, nums2Size, nums1, nums1Size);
    }
    
    long long l1, r1, l2, r2;
    int cut1, cut2;
    int left = 0, right = nums1Size;

    while (1) {
        cut1 = (left + right) / 2;
        cut2 = (nums1Size + nums2Size) / 2 - cut1;
        l1 = cut1 > 0 ? nums1[cut1 - 1] : -INF;
        r1 = cut1 < nums1Size ? nums1[cut1] : INF;
        l2 = cut2 > 0 ? nums2[cut2 - 1] : -INF;
        r2 = cut2 < nums2Size ? nums2[cut2] : INF;
        
        if (l1 > r2) {
            right = cut1 - 1;
        } else if (l2 > r1) {
            left = cut1 + 1;
        } else {
            break;
        }
    }
    long long maxLeft = l1 > l2 ? l1 : l2;
    long long minRight = r1 < r2 ? r1 : r2;

    if ((nums1Size + nums2Size) % 2 == 0) {
        return ((double) maxLeft + minRight) / 2;
    } else {
        return (double) minRight;
    }
}
```
2. https://leetcode.com/problems/count-of-range-sum
```c
long long mergeCount(long long* prefix, int left, int right, int lower, int upper) {
    if (right - left <= 1) return 0;
    int mid = (left + right) / 2;
    long long count = 0;
    count += mergeCount(prefix, left, mid, lower, upper);
    count += mergeCount(prefix, mid, right, lower, upper);
    
    int lo = left, hi = left;
    for (int j = mid; j < right; j++) {
        
        while (lo < mid && prefix[lo] < prefix[j] - upper) lo++;
        
        while (hi < mid && prefix[hi] <= prefix[j] - lower) hi++;
        
        count += hi - lo;
    }

    long long temp[right-left];
    int i = left, j = mid, k = 0;
    while (i < mid && j < right)
        temp[k++] = prefix[i] < prefix[j] ? prefix[i++] : prefix[j++];

    while (i < mid) temp[k++] = prefix[i++];
    while (j < right) temp[k++] = prefix[j++];

    for (int x = left; x < right; x++)
        prefix[x] = temp[x - left];

    return count;
}

int countRangeSum(int* nums, int numsSize, int lower, int upper) {
    // prefix sum
    long long prefixSums[numsSize + 1];
    prefixSums[0] = 0;
    for(int i = 1; i <= numsSize; i ++) {
        prefixSums[i] = prefixSums[i - 1] + nums[i - 1];
    }
    return mergeCount(prefixSums, 0, numsSize + 1, lower, upper);
}
```
3. https://leetcode.com/problems/maximum-subarray
```c
int maxSubArray(int* nums, int numsSize) {
    int current = nums[0];
    int best = nums[0];

    for (int i = 1; i < numsSize; i++) {
        if (current < 0)
            current = nums[i];        // начинаем заново
        else
            current = current + nums[i]; // продолжаем

        if (current > best)
            best = current;
    }

    return best;
}
```