function duration=getDuration(obj)
% get the duration of the test
%
% duration=getDuration(obj)
%
% Input:
%   obj                 MOxUnitTestReport instance
%
% Output:
%   duration            total time in seconds that it took to run all tests
%                       in the obj instance

    duration=0;

    for i=1:countTestOutcomes(obj)
        test_outcome=getTestOutcome(obj,i);
        duration=duration+getDuration(test_outcome);
    end