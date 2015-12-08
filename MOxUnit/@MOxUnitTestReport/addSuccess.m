function obj=addSuccess(obj,t,dur)
% Add test case success (pass) to a MoxUnitTestResult instance
%
% obj=addError(obj,t,e)
%
% Inputs:
%   obj             MOxUnitTestReport instance.
%   t               MoxUnitTestCase that gave a success.
%   dur             Duration of runtime (in seconds).
%
% Output:
%   obj             MOxUnitTestReport instance with the test success added.
%
% NNO 2015

    obj.successes{end+1}={t,dur};
    obj.testsRun=obj.testsRun+1;
    obj.duration=obj.duration+dur;
    report(obj,'.','passed',t);

