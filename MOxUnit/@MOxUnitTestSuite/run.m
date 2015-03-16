function result=run(obj,result)
    if nargin<2
        result=MOxUnitTestResult();
    end

    for j=1:numel(obj.tests)
        test_case=obj.tests{j};
        result=run(test_case, result);
    end

