function obj=addError(obj,t,e,dur)
% Add test case error to a MoxUnitTestResult instance
%
% obj=addError(obj,t,e)
%
% Inputs:
%   obj             MOxUnitTestResult instance.
%   t               MoxUnitTestCase that gave an error.
%   e               Exception associated with the error.
%   dur             Duration of runtime until error (in seconds).
%
% Output:
%   obj             MOxUnitTestResult instance with the error added.
%
% NNO 2015


    obj.failures{end+1}={t,dur,e};
    obj.testsRun=obj.testsRun+1;
    obj.duration=obj.duration+dur;
    report(obj,'e','Error',t);
