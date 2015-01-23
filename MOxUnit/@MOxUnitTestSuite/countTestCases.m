function c=countTestCases(obj)
    c=0;
    for k=1:numel(obj.tests)
        t=obj.tests{k};
        c=c+countTestCases(t);
    end

