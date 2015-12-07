function obj=addSkip(obj,t,dur,reason)
% Add test case skip to a MoxUnitTestResult instance
%
% obj=addError(obj,t,e)
%
% Inputs:
%   obj             MOxUnitTestResult instance.
%   t               MoxUnitTestCase that gave an error.
%   dur             Duration of runtime until skipped (in seconds).
%   reason          String describing the reason why a test was skipped.
%
% Output:
%   obj             MOxUnitTestResult instance with the skipped test
%                   added.
%
% NNO 2015

    obj.skips{end+1}={t,dur,reason};
    obj.testsRun=obj.testsRun+1;
    obj.duration=obj.duration+dur;
    report(obj,'s','SKIP',t);


