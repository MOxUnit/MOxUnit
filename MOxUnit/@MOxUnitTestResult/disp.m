function disp(obj)
% Display test results
%
% disp(obj)
%
%   obj             MOxUnitTestResult instance.
%
% Notes:
%   - this function writes results to the file descriptor provided when
%     obj was instantiated, and with the provided verbosity level
%
% NNO 2015


    horizontal_line=sprintf('%s\n\n',repmat('-',1,50));


    if obj.verbosity>0
        % write white-space
        fprintf(obj.stream,'\n\n');
    end

    % define minimum verbosity level for each test outcome to show result
    required_verbosity=struct();
    required_verbosity.errors=1;
    required_verbosity.failures=1;
    required_verbosity.skips=2;
    required_verbosity.successes=Inf; % never show summary of success

    % define keys for non-success, and for failure
    % (skips are not a success but not a failure either)
    non_success_keys={'errors','failures','skips'};
    failure_keys={'errors','failures'};

    all_keys=fieldnames(required_verbosity);
    get_counts=@(key_cell) cellfun(@(x)numel(obj.(x)),key_cell);

    % show all errors, failures, and skips (if any).
    % skips are only shown with verbose output; errors and failures are
    % always shown.
    all_counts=get_counts(all_keys);
    for j=1:numel(all_keys)
        key=all_keys{j};
        if obj.verbosity>=required_verbosity.(key) && ...
                    all_counts(j)>0
            fprintf(obj.stream, horizontal_line);
            show_non_successes(obj,key);
        end
    end

    % show summary of result
    if obj.verbosity>0
        fprintf(obj.stream,horizontal_line);

        is_ok=sum(get_counts(failure_keys))==0;
        if is_ok
            % only successes and skips
            prefix='OK';
        else
            % at least one error or failure
            prefix='FAILED';
        end

        non_success_counts=get_counts(non_success_keys);
        has_non_successes=sum(non_success_counts)>0;

        if has_non_successes
            % build string showing number of errors, failures, and skips,
            % for example '(failures=1, skips=3)'

            % start with open parenthesis
            postfix=' (';
            non_success_indices=find(non_success_counts>0);
            for k=1:numel(non_success_indices)
                non_success_index=non_success_indices(k);
                if k>1
                    % add comma
                    postfix=sprintf('%s, ',postfix);
                end

                % add string 'key=count'
                postfix=sprintf('%s%s=%d',postfix,...
                                    non_success_keys{non_success_index},...
                                    non_success_counts(non_success_index));
            end
            % close parenthesis
            postfix=sprintf('%s)', postfix);
        else
            postfix='';
        end

        fprintf(obj.stream,'%s%s\n', prefix, postfix);
    end
