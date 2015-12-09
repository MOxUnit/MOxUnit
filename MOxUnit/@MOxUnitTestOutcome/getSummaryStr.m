function str=getSummaryStr(obj, format)

    formatters=struct();
    formatters.text=@obj2text;
    formatters.xml=@obj2xml;

    f=formatters.(format);

    str=f(obj);


function str=obj2text(obj)
    content=getSummaryContent(obj);

    % set outcome to 'failure', 'error', 'skipped', or 'passed'
    outcome_verbosity=2;
    outcome=getOutcomeStr(obj, outcome_verbosity);

    if isstruct(content)
        % error or failure
        n_stack=numel(content.stack);
        n_lines=1+n_stack;

        lines=cell(n_lines,1);
        lines{1}=sprintf('%s: %s',outcome,content.message);

        for k=1:n_stack
            str=content.stack(k);
            lines{k+1}=sprintf('  %s:%d (%s)\n', ...
                            str.name, str.line, str.file);
        end

        str=strjoin(lines,sprintf('\n'));

    elseif ischar(content)
        % skipped
        str=sprintf('%s: %s', outcome, content);

    elseif isequal(content,[])
        % passed
        str='';

    else
        assert(false,'this should not happen');
    end


function str=obj2xml(obj)
    str=[];
    % TODO
    %
    % Should use isNonFailure, isSuccess, getOutcomeStr and
    % getSummaryContent
    error('not implemented');