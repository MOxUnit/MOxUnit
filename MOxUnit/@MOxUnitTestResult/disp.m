function disp(obj)
    fprintf(obj.stream,'\n\n');

    horline=sprintf('%s\n\n',repmat('-',1,50));

    keys={'errors','failures','skips','successes'};

    % define minimum verbosity level for each key to show result
    required_verbosity=[1 1 2 Inf];

    counts=cellfun(@(x)numel(obj.(x)),keys);

    % only has non successes if either error or failure
    has_non_successes=sum(counts(1:3));

    for j=1:numel(keys)
        if obj.verbosity>=required_verbosity(j) && counts(j)>0
            fprintf(obj.stream, horline);
            show_non_successes(obj,keys{j});
        end
    end

    if obj.verbosity>0
        fprintf(obj.stream,horline);

        is_ok=sum(counts(1:2))==0;
        if is_ok
            prefix='OK';
        else
            prefix='FAILED';
        end

        if has_non_successes
            postfix=' (';
            non_success_indices=find(counts(1:3)>0);
            for k=1:numel(non_success_indices)
                non_success_index=non_success_indices(k);
                if k>1
                    postfix=sprintf('%s, ',postfix);
                end


                postfix=sprintf('%s%s=%d',postfix,...
                                        keys{non_success_index},...
                                        counts(non_success_index));
            end
            postfix=sprintf('%s)', postfix);
        else
            postfix='';
        end

        fprintf('%s%s\n', prefix, postfix);
    end
