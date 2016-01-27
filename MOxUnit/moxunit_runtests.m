function result=moxunit_runtests(varargin)
% Run MOxUnit tests suite
%
% result=moxunit_runtests(...)
%
% Inputs:
%   '-verbose'              show verbose output. If not provided,
%                           non-verbose output is shown.
%   '-quiet'                do not show output
%   filename                } test the unit tests in filename
%   directory               } (which must initialize a test suite through
%                           } initTestSuite) or in directory. Multiple
%                           filename or directory arguments can be
%                           provided. If there are no filename or directory
%                           arguments, then all tests in the current
%                           directory are run.
%   '-recursive'            If this option is present, then files are added
%                           recursively from any directory. If absent, then
%                           only files from each directory (but not their
%                           subdirectories) are added.
%   '-logfile', output      store the output in file output. If not
%                           provided, then output is directed to the
%                           command window
%   '-with_coverage'        record coverage using MOCov
%   '-cover', cd            record code coverage in directory cd
%   '-cover_json_file', cj  store coverage report in json file cj for
%                           processing by coveralls.io
%   '-cover_xml_file', cx   store coverage XML output in file cx
%   '-cover_html_dir, ch    store coverage HTML output in directory ch
%   '-junit_xml_file', jx   store test results in junit XML file jx
%
% Output:
%   result                  true if no test failed or raised an error. In
%                           other words, true if all tests were either
%                           successful or skipped. Result is true if
%                           no tests were run.
%
% Notes:
%   - This function can be run without the function syntax. For example,
%
%       moxunit_runtests
%
%     runs all tests in the current directory, and
%
%       moxunit_runtests ../tests -verbose -logfile my_log.txt
%
%     runs all tests in the tests sub-directory of the parent directory,
%     and stores verbose output in the file my_log.txt
%   - This function attempts to show similar behaviour as in
%     Steve Eddins' MATLAB xUnit Test Framework (2009-2012)
%     URL: http://www.mathworks.com/matlabcentral/fileexchange/
%                           22846-matlab-xunit-test-framework
%   - To define tests, functions can be written that use initTestSuite.
%
% See also: initTestSuite, mocov
%
% NNO Jan 2014


    params=get_params(varargin{:});

    if params.fid>2
        % not standard or error output; file most be closed
        % afterwards
        cleaner=onCleanup(@()fclose(params.fid));
    end

    suite=MOxUnitTestSuite();
    for k=1:numel(params.filenames)
        % add files to the test suite
        filename=params.filenames{k};
        if isdir(filename)
            suite=addFromDirectory(suite,filename,[],params.add_recursive);
        else
            suite=addFromFile(suite,filename);
        end
    end

    % show summary of test suite
    if params.verbosity>0
        fprintf(params.fid,'%s\n',str(suite));
    end

    % initialize test results
    suite_name=class(suite);
    test_report=MOxUnitTestReport(params.verbosity,params.fid,suite_name);

    % run all tests with helper
    test_report=run_all_tests(suite, test_report, params);

    % show summary of test result
    disp(test_report);

    if ~isempty(params.junit_xml_file)
        write_junit_xml(params.junit_xml_file, test_report);
    end


    % return true if no errors or failures
    result=wasSuccessful(test_report);


function test_report=run_all_tests(suite, test_report, params)
    f_handle=@()run(suite, test_report);

    with_coverage=params.with_coverage;

    if with_coverage
        pkg='mocov';
        if isempty(which(pkg))
            error(['command ''%s'' not found, '...
                    'coverage is not supported'],pkg);
        end

        mocov_expr_param={'-expression',f_handle};

        all_keys=fieldnames(params);
        msk=cellfun(@(x)~isempty(regexp(x,'^cover','once')),all_keys);
        keys=all_keys(msk);
        n_keys=numel(keys);

        mocov_params=cell(1,2*n_keys);
        for k=1:n_keys
            key=keys{k};
            mocov_params{k*2-1}=['-' key];
            mocov_params{k*2}=params.(key);
        end

        all_params=[mocov_expr_param, mocov_params];

        test_report=mocov(all_params{:});
    else
        test_report=f_handle();
    end




function write_junit_xml(fn, test_report)
    fid=fopen(fn,'w');
    file_closer=onCleanup(@()fclose(fid));

    xml_preamble='<?xml version="1.0" encoding="utf-8"?>';
    xml_header='<testsuites>';
    xml_body=getSummaryStr(test_report,'xml');
    xml_footer='</testsuites>';

    fprintf(fid,'%s\n%s\n%s\n%s',...
                xml_preamble,...
                xml_header,...
                xml_body,...
                xml_footer);


function params=get_params(varargin)
    % set defaults
    params.verbosity=1;
    params.fid=1;
    params.junit_xml=[];
    params.add_recursive=false;
    params.cover=[];
    params.cover_xml_file=[];
    params.junit_xml_file=[];
    params.cover_json_file=[];
    params.cover_html_dir=[];
    params.cover_method=[];
    params.with_coverage=false;

    % allocate space for filenames
    n=numel(varargin);
    filenames=cell(n,1);

    k=0;
    while k<n
        k=k+1;
        arg=varargin{k};
        if ~ischar(arg)
            error('moxunit:illegalParameter',...
                    'Illegal argument at position %d', k);
        end
        switch arg
            case '-verbose'
                params.verbosity=params.verbosity+1;

            case '-quiet'
                params.verbosity=params.verbosity-1;


            case '-logfile'
                if k==n
                    error('moxunit:missingParameter',...
                           'Missing parameter after option ''%s''',arg);
                end
                k=k+1;
                fn=varargin{k};

                params.fid=fopen(fn,'w');
                if params.fid==-1
                    error('Could not open file %s for writing', fn);
                end

             case '-cover'
                 if k==n
                    error('moxunit:missingParameter',...
                           'Missing parameter after option ''%s''',arg);
                end
                k=k+1;
                params.cover=varargin{k};

             case '-cover_xml_file'
                if k==n
                    error('moxunit:missingParameter',...
                           'Missing parameter after option ''%s''',arg);
                end
                k=k+1;
                params.cover_xml_file=varargin{k};

            case '-junit_xml_file'
                if k==n
                    error('moxunit:missingParameter',...
                           'Missing parameter after option ''%s''',arg);
                end
                k=k+1;
                params.junit_xml_file=varargin{k};

            case '-cover_json_file'
                if k==n
                    error('moxunit:missingParameter',...
                           'Missing parameter after option ''%s''',arg);
                end
                k=k+1;
                params.cover_json_file=varargin{k};

            case '-cover_html_dir'
                if k==n
                    error('moxunit:missingParameter',...
                           'Missing parameter after option ''%s''',arg);
                end
                k=k+1;
                params.cover_html_dir=varargin{k};

            case '-cover_method'
                if k==n
                    error('moxunit:missingParameter',...
                           'Missing parameter after option ''%s''',arg);
                end
                k=k+1;
                params.cover_method=varargin{k};

            case '-recursive'
                params.add_recursive=true;


            case '-with_coverage'
                params.with_coverage=true;

            otherwise

                if ~isempty(dir(arg))
                    filenames{k}=arg;
                else
                    error('moxunit:illegalParameter',...
                    'Parameter not recognised or file missing: %s', arg);
                end
        end
    end

    filenames=filenames(~cellfun(@isempty,filenames));

    if numel(filenames)==0
        me_name=mfilename();
        if isequal(pwd(), fileparts(which(me_name)))
            error('moxunit:illegalParameter',...
                        ['Cannot run from the MOxUnit directory ',...
                            'because this would lead to recursive '...
                            'calls to %s. To run unit tests '...
                            'on MOxUnit itself, use:\n\n'...
                            '  %s ../tests'], me_name, me_name);
        end
        filenames={pwd()};
    end

    params.filenames=filenames;

    check_cover_consistency(params)

function check_cover_consistency(params)
    keys=fieldnames(params);

    n=numel(keys);

    with_coverage=params.with_coverage;
    for k=1:n
        key=keys{k};

        if ~isempty(regexp(key,'^cover','once'))
            value=params.(key);
            if ~isempty(value) && ~with_coverage
                error('Option ''%s'' requires -with_coverage');
            end
        end
    end

    if with_coverage && isempty(params.cover)
        error('Option ''-with_coverage'' requires ''-cover''');
    end







