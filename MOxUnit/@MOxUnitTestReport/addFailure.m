function obj=addFailure(obj,t,dur,e)
% Add test case failure to a MoxUnitTestResult instance
%
% obj=addError(obj,t,e)
%
% Inputs:
%   obj             MOxUnitTestReport instance.
%   t               MoxUnitTestCase that gave a failure.
%   dur             Duration of runtime until failure (in seconds).
%   e               Exception associated with the failure.
%
% Output:
%   obj             MOxUnitTestReport instance with the failure added.
%
% NNO 2015

    obj.failures{end+1}={t,dur,e};
    obj.testsRun=obj.testsRun+1;
    obj.duration=obj.duration+dur;
    report(obj,'F','FAILED',t);
