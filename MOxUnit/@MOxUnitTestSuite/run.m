function result=run(obj,result)
% Run the test suite
%
% result=run(obj[,result])
%
% Inputs:
%   obj             MoxUnitTestSuite instance with tests to be run.
%   result          MoxUnitTestResult instance to which test results are to
%                   be reported (default: empty MoxUnitTestResult instance).
%
% Output:
%   result          MoxUnitTestResult containing tests results
%                   after running all tests in obj.
%
% See also: MoxUnitTestResult
%
% NNO 2015

    if nargin<2
        result=MOxUnitTestResult();
    end

    for j=1:numel(obj.tests)
        test_case=obj.tests{j};
        result=run(test_case, result);
    end

