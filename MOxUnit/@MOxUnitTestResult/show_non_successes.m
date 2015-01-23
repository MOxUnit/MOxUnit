function show_non_successes(obj, label)
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
        e=content{k}{2};
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



