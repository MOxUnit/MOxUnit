function result=run(obj,result)
    for j=1:numel(obj.tests)
        test_case=obj.tests{j};
        result=run(test_case, result);
    end

