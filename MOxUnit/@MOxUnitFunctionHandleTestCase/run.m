function result=run(obj,result)
% Run test associated with MoxUnitFunctionHandleTestCase
%
% result=run(obj,result)
%
% Inputs:
%   obj             MoxUnitFunctionHandleTestCase object
%   result          MoxUnitTestResult instance to which test results are to
%                   be reported.
%
% Output:
%   result          MoxUnitTestResult containing tests results
%                   after running the test associated with obj.
%
% See also: MoxUnitTestResult
%
% NNO 2015

    start_tic = tic;
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
                result=addSkip(result, obj, toc(start_tic), reason);
            else
                result=addFailure(result, obj, toc(start_tic), e);
            end
        end

        if passed
            result=addSuccess(result, obj, toc(start_tic));
        end
    catch
        e=lasterror();
        result=addError(result, obj, toc(start_tic), e);
    end
