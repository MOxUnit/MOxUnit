function obj=MOxUnitTestNode()
% Initialize MOxUnitTestNode instance
%
% obj=MOxUnitTestNode()
%
% Output:
%   obj             empty MOxUnitTestNode instance
%
% Notes:
%   - This class is intended as an 'abstract' superclass, and should not
%     be initialized in typical use cases. Instead, use its subclasses,
%     MoxUnitTestSuite and MoxUnitTestCase.
%
% NNO 2015

    obj=class(struct,'MOxUnitTestNode');
