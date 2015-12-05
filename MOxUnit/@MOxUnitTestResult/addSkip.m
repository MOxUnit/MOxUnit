function obj=addSkip(obj,t,reason)
% Add test case skip to a MoxUnitTestResult instance
%
% obj=addError(obj,t,e)
%
% Inputs:
%   obj             MOxUnitTestResult instance.
%   t               MoxUnitTestCase that gave an error.
%   reason          String describing the reason why a test was skipped.
%
% Output:
%   obj             MOxUnitTestResult instance with the skipped test
%                   added.
%
% NNO 2015

    obj.skips{end+1}={t,reason};
    obj.testsRun=obj.testsRun+1;
    report(obj,'s','SKIP',t);
    % Append this XML report to the list of testcase reports
    obj.xml_reports{end+1}=report_xml(obj,'s',t,reason);