function obj=addFromFile(obj,fn)
    orig_pwd=pwd();
    cleaner=onCleanup(@()cd(orig_pwd));

    [fn_dir,name]=fileparts(fn);
    if ~isempty(fn_dir)
        cd(fn_dir);
    end

    try
        func=str2func(name);
        test_case=func();
        if isa(test_case,'MOxUnitTestNode')
            obj=addTest(obj,test_case);
        end
    catch
        caught_error=lasterror();

        if is_parse_error(caught_error)
            % add a test case that shows the parsing error
            subfunction_name='';
            func=@()rethrow(caught_error);
            test_case=MOxUnitFunctionHandleTestCase(subfunction_name,...
                                                    fn, func);
            obj=addTest(obj,test_case);
        else
            % ignore silently, assuming that the file was not a test case
        end
    end


function tf=is_parse_error(caught_error)
    tf=isempty(caught_error.identifier) && ...
            ~isempty(regexp(caught_error.message,'^parse error','once'));

