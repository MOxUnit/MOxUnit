function obj=setTestNode(obj, i, t)
% Add MOxUnitTestNode instance to the suite
%
% obj=setTestNode(obj, i, t)
%
% Inputs:
%   obj             MoxUnitTestSuite instance
%   i               Index of where the test must be added
%   t               MOxUnitTestNode instance to be added to the suite.
%
% Output:
%   obj             MoxUnitTestSuite instance with the MOxUnitTestNode
%                   instance set as the i-th test
%
% See also: initTestSuite
%
% NNO 2015
    if ~is_scalar_integer(i)
        error('index must be scalar integer');
    end

    max_i=countTestNodes(obj);
    if i>max_i
        error('index %d exceeds the number of tests %d',i,max_i);
    end

    obj.tests{i}=t;


function tf=is_scalar_integer(i)
    tf=isnumeric(i) && ...
            numel(i)==1 && ...
            i>0 && ...
            round(i)==i;

