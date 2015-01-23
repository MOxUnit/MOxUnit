function s=str(obj)
    s=sprintf('suite: %d tests', countTestCases(obj));
