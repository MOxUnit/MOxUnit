function result=run(obj,result)
    try
        passed=false;
        try
            obj.function_handle();
            passed=true;
        catch
            e=lasterror();

            if moxunit_isa_test_skipped_exception(e)

                last_newline_pos=find(e.message==sprintf('\n'),1,'last');
                if isempty(last_newline_pos)
                    last_newline_pos=0;
                end

                reason=e.message((last_newline_pos+1):end);
                result=addSkip(result, obj, reason);
            else
                result=addFailure(result, obj, e);
            end
        end

        if passed
            result=addSuccess(result, obj);
        end
    catch
        e=lasterror();
        result=addError(result, obj, e);
    end
