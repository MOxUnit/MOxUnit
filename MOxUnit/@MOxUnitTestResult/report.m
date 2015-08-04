function report(obj,c,s,t)
% Report single test case result (error, failure, skip, or success)
%
% report(obj,c,s,t)
%
% Inputs:
%   obj             MOxUnitTestResult instance.
%   c               Single character representation of test case result;
%                   Typically, the following characters are used:
%                   'e' : error
%                   'F' : failure
%                   's' : skip
%                   '.' : success
%   s               String description of test case result.
%   t               MOxUnitTestNode instance with the test.
%
% Notes:
%   - This is a helper function for addError, addFailure, addSkip and
%     addSuccess to indicate a test result after a test has been run.
%
% See also: addError, addFailure, addSkip, addSuccess
%
% NNO 2015

    stream=obj.stream;

    if obj.verbosity>=2
        % verbose output
        fprintf(stream,'%10s: %s\n', s, str(t));

    elseif obj.verbosity>=1
        % single character output
        fprintf(stream,c);
        if mod(obj.testsRun,60)==0
            fprintf('\n');
        end
    end

