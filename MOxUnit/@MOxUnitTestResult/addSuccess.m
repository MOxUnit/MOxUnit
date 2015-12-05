function obj=addSuccess(obj,t)
% Add test case success (pass) to a MoxUnitTestResult instance
%
% obj=addError(obj,t,e)
%
% Inputs:
%   obj             MOxUnitTestResult instance.
%   t               MoxUnitTestCase that gave a success.
%
% Output:
%   obj             MOxUnitTestResult instance with the test success added.
%
% NNO 2015

    obj.successes{end+1}=t;
    obj.testsRun=obj.testsRun+1;
    report(obj,'.','passed',t);
    % Append this XML report to the list of testcase reports
    obj.xml_reports{end+1}=report_xml(obj,'.',t,'passed');