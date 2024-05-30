function tf=isSuccess(obj)
% return whether this test was a success
%
% tf=isSuccess(obj)
%
% Input:
%   obj                     MoxUnitPassedTestOutcome object
%
% Output:
%   tf                      set to false, because a failed test is not a
%                           success
%
% See also: @MoxUnitTestOutcome

    tf=true;