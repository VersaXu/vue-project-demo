import { bubbleSort } from './bubbleSort';

describe('bubbleSort', () => {
    test('should sort an array of numbers in ascending order', () => {
        const input = [64, 34, 25, 12, 22, 11, 90];
        const expectedOutput = [11, 12, 22, 25, 34, 64, 90];
        expect(bubbleSort(input)).toEqual(expectedOutput);
    });

    test('should handle an empty array', () => {
        const input = [];
        const expectedOutput = [];
        expect(bubbleSort(input)).toEqual(expectedOutput);
    });

    test('should handle an array with one element', () => {
        const input = [42];
        const expectedOutput = [42];
        expect(bubbleSort(input)).toEqual(expectedOutput);
    });

    test('should handle an array with duplicate elements', () => {
        const input = [5, 3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 4, 1, 2];
        const expectedOutput = [1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 5, 6, 9];
        expect(bubbleSort(input)).toEqual(expectedOutput);
    });

    test('should handle an array with negative numbers', () => {
        const input = [-5, -3, -1, 0, 4, 2, -2];
        const expectedOutput = [-5, -3, -2, -1, 0, 2, 4];
        expect(bubbleSort(input)).toEqual(expectedOutput);
    });
});

describe('bubbleSort', () => {
    it('should sort an array in ascending order', () => {
        const arr = [5, 3, 8, 4, 6];
        const sortedArr = bubbleSort(arr);
        expect(sortedArr).toEqual([3, 4, 5, 6, 8]);
    });

    it('should handle an empty array', () => {
        const arr = [];
        const sortedArr = bubbleSort(arr);
        expect(sortedArr).toEqual([]);
    });

    it('should handle an array with duplicate elements', () => {
        const arr = [5, 3, 3, 8, 4, 6, 6];
        const sortedArr = bubbleSort(arr);
        expect(sortedArr).toEqual([3, 3, 4, 5, 6, 6, 8]);
    });

    it('should handle an array with negative numbers', () => {
        const arr = [5, -3, 8, 4, 6];
        const sortedArr = bubbleSort(arr);
        expect(sortedArr).toEqual([-3, 4, 5, 6, 8]);
    });

    it('should handle an array with one element', () => {
        const arr = [5];
        const sortedArr = bubbleSort(arr);
        expect(sortedArr).toEqual([5]);
    });
});