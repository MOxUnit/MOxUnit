function obj=addFailure(obj,t,e)
    obj.failures{end+1}={t,e};
    obj.testsRun=obj.testsRun+1;
    report(obj,'F','FAILED',t);
