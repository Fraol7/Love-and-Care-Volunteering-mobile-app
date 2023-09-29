class Solution:
    def lastStoneWeightII(self, stones: List[int]) -> int:
        total = sum(stones)
        mid = total // 2
        maxSum = 0
        memo = {}
        def dp(idx,curSum):
            nonlocal maxSum
            if idx == len(stones):
                if curSum <= mid:
                    maxSum = max(maxSum, curSum)
                return

            if curSum > mid:
                return

            curSum += stones[idx]
            dp(idx + 1, curSum)
            curSum -= stones[idx]
            dp(idx + 1, curSum)
        dp(0,0)
        return total - maxSum - maxSum        
