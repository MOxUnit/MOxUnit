function tf=wasSuccessful(obj)
% Return whether running the tests were successful
%
% tf=wasSuccessful(obj)
%
%   obj             MOxUnitTestReport instance containg tests that have
%                   been run.
%   tf              true if there were no errors or failures; false
%                   otherwise.
%
% Notes:
%   - skipped tests are not considered a failure.
%
% NNO 2015

    tf=all([numel(obj.errors),...
            numel(obj.failures)]==0);