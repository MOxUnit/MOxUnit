function obj=addSuccess(obj,t)
    obj.successes{end+1}=t;
    obj.testsRun=obj.testsRun+1;
    report(obj,'.','passed',t);

