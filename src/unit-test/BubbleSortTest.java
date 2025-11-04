import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

public class BubbleSortTest{

    @Test
    void testBubbleSortArrayWithDuplicates() {
        int[] arr = {4, 2, 4, 1, 2};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{1, 2, 2, 4, 4}, arr);
    }

    @Test
    void testBubbleSortNegativeNumbers() {
        int[] arr = {-3, -1, -2, -4};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{-4, -3, -2, -1}, arr);
    }

    @Test
    void testBubbleSortMixedNumbers() {
        int[] arr = {0, -1, 3, -2, 1};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{-2, -1, 0, 1, 3}, arr);
    }

    @Test
    void testBubbleSortEmptyArray() {
        int[] arr = {};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{}, arr);
    }

    @Test
    void testBubbleSortSingleElementArray() {
        int[] arr = {1};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{1}, arr);
    }

    @Test
    void testBubbleSortAlreadySortedArray() {
        int[] arr = {1, 2, 3, 4, 5};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{1, 2, 3, 4, 5}, arr);
    }

    @Test
    void testBubbleSortReverseSortedArray() {
        int[] arr = {5, 4, 3, 2, 1};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{1, 2, 3, 4, 5}, arr);
    }

    @Test
    void testBubbleSortRandomArray() {
        int[] arr = {3, 6, 1, 8, 4};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{1, 3, 4, 6, 8}, arr);
    }

    @Test
    void testBubbleSortWithAllSameElements() {
        int[] arr = {7, 7, 7, 7};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{7, 7, 7, 7}, arr);
    }

    @Test
    void testBubbleSortWithEmptyArray() {
        int[] arr = {};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{}, arr);
    }

    @Test
    void testBubbleSortWithSingleElementArray() {
        int[] arr = {5};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{5}, arr);
    }

    @Test
    void testBubbleSortWithSortedArray() {
        int[] arr = {1, 2, 3, 4, 5};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{1, 2, 3, 4, 5}, arr);
    }

    @Test
    void testBubbleSortWithReverseSortedArray() {
        int[] arr = {5, 4, 3, 2, 1};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{1, 2, 3, 4, 5}, arr);
    }

    @Test
    void testBubbleSortWithUnsortedArray() {
        int[] arr = {3, 6, 1, 8, 2};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{1, 2, 3, 6, 8}, arr);
    }

    @Test
    void testBubbleSortWithDuplicateElements() {
        int[] arr = {4, 2, 4, 1, 2};
        BubbleSort.bubbleSort(arr);
        assertArrayEquals(new int[]{1, 2, 2, 4, 4}, arr);
    }

}