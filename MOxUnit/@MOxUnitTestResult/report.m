function report(obj,c,s,t)
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

