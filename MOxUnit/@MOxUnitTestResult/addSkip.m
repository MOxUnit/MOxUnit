function obj=addSkip(obj,t,reason)
    obj.skips{end+1}={t,reason};
    obj.testsRun=obj.testsRun+1;
    report(obj,'s','SKIP',t);

