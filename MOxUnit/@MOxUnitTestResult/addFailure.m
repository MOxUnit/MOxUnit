function obj=addFailure(obj,t,e)
% Add test case failure to a MoxUnitTestResult instance
%
% obj=addError(obj,t,e)
%
% Inputs:
%   obj             MOxUnitTestResult instance.
%   t               MoxUnitTestCase that gave a failure.
%   e               Exception associated with the failure.
%
% Output:
%   obj             MOxUnitTestResult instance with the failure added.
%
% NNO 2015

    obj.failures{end+1}={t,e};
    obj.testsRun=obj.testsRun+1;
    report(obj,'F','FAILED',t);
    % Append this XML report to the list of testcase reports
    obj.xml_reports{end+1}=report_xml(obj,'F',t,e);