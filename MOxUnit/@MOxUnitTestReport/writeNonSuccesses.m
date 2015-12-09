function writeNonSuccesses(obj, format, fid)
    if nargin<3
        fid=obj.stream;
    end

    for i=1:countTestOutcomes(obj)
        test_outcome=getTestOutcome(obj,i);
        test_outcome_summary=getSummaryStr(test_outcome,format);

        if ~isempty(test_outcome_summary)
            fprintf(fid,'%s\n',test_outcome_summary);
        end
    end

