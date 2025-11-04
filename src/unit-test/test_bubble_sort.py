import pytest
from sorting_algorithms import bubble_sort


def test_bubble_sort():
    assert bubble_sort([5, 3, 8, 6, 7, 2]) == [2, 3, 5, 6, 7, 8]
    assert bubble_sort([1, 2, 3, 4, 5]) == [1, 2, 3, 4, 5]
    assert bubble_sort([]) == []
    assert bubble_sort([1]) == [1]
    assert bubble_sort([2, 1]) == [1, 2]
    assert bubble_sort([5, 3, 2, 1]) == [1, 2, 3, 5]
    assert bubble_sort([1, 2, 3, 4, 5]) == [1, 2, 3, 4, 5]
