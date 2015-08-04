function obj=addError(obj,t,e)
% Add test case error to a MoxUnitTestResult instance
%
% obj=addError(obj,t,e)
%
% Inputs:
%   obj             MOxUnitTestResult instance.
%   t               MoxUnitTestCase that gave an error.
%   e               Exception associated with the error.
%
% Output:
%   obj             MOxUnitTestResult instance with the error added.
%
% NNO 2015


    obj.failures{end+1}={t,e};
    obj.testsRun=obj.testsRun+1;
    report(obj,'e','Error',t);
