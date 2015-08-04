function obj=MOxUnitTestSuite()
% Initialize empty test suite
%
% Output:
%   obj             MoxUnitTestSuite instance with no tests.
%
% Notes:
%   MOxUnitTestSuite is a subclass of MoxUnitTestNode.
%
% See also: MoxUnitTestNode
%
% NNO 2015

    s=struct();
    s.tests=cell(0);
    obj=class(s,'MOxUnitTestSuite',MOxUnitTestNode());


