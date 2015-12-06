function out=generate_xml(obj)
% Generate an XML report for the testsuite
%
% out=generate_xml(obj)
%
% Inputs:
%   obj             MOxUnitTestResult instance.
%
% Output:
%   out             String containing the formatted XML for the
%                   cumulative testsuite report.
%
% SCL 2015

    % We need a testsuite tag encompassing all the testcase nodes
    % in this suite of results. The testsuite tag needs to contain
    % the overall statistics for the suite.
    pre = sprintf(['<testsuite name="MOxUnit" tests="%d" ' ...
                   'errors="%d" failures="%d" skips="%d">'], ...
                  obj.testsRun, ...
                  length(obj.errors), ...
                  length(obj.failures), ...
                  length(obj.skips) ...
                  );
    post = '</testsuite>';

    % The testcase XML was generated during the testing and stored
    % as a cell arry in xml_reports
    out = strjoin(obj.xml_reports, '\n');
    % Surround the testcases with the testsuite tag
    out = ['\n', pre, '\n', out, '\n', post];