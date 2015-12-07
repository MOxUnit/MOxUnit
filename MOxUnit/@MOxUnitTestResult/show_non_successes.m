function show_non_successes(obj, label)
% Produce output describing test errors, failures, or skips
%
% show_non_successes(obj, label)
%
% Inputs:
%   obj             MOxUnitTestResult instance containing tests that have
%                   been run.
%   label           One of 'errors',' 'failures', or 'skips'
%
% Notes:
%   - This function provides output to the file descriptor provided when
%     obj was instantiated (default: 1, Command Window output)
%   - This function is typically called after all tests are run, in order
%     to show a summary of tests that did not pass.
%   - If no tests with label are present in obj, then no output is
%     produced.
%
% NNO 2015

    if obj.verbosity<1
        return;
    end

    content=obj.(label);
    n=numel(content);
    if n==0
        return;
    end

    stream=obj.stream;

    label_singular=label(1:(end-1));

    for k=1:n
        e=content{k}{3};
        if isstruct(e)
            fprintf(stream,'%s: %s\n',label_singular,e.message);
            for j=1:numel(e.stack)
                s=e.stack(j);
                fprintf(stream,'%s:%d (%s)\n', s.name, s.line, s.file);
            end
            fprintf(stream,'\n');
        elseif ischar(e)
            fprintf(stream,'%s: %s\n',label_singular,e);
        else
            assert(false,'this should not happen');
        end
        fprintf(stream,'\n');
    end



