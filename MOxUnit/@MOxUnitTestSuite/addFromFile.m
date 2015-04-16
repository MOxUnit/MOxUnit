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
        % ignore silently, assuming that the file was not a test case
    end

