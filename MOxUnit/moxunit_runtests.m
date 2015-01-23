function result=moxunit_runtests(varargin)
% Run MOxUnit tests suite
%
% result=moxunit_runtests(...)
%
% Inputs:
%   '-verbose'          show verbose output. If not provided, non-verbose
%                       output is shown
%   filename            } test the unit tests in filename
%   directory           } (which must initialize a test suite through
%                       } initTestSuite) or in directory. Multiple filename
%                       or directory arguments can be provided. If there
%                       are no filename or directory arguments, then tests
%                       in the current directory are run.
%   '-logfile', output  store the output in file output. If not provided,
%                       output id directed to the terminal window
%
% Output:
%   result              true if no test failed or raises an error.
%                       (therefore, result is true if no tests were run)
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
%
% NNO Jan 2014


    [verbosity, filenames, fid]=get_params(varargin{:});
    if fid>2
        cleaner=onCleanup(@()fclose(fid));
    end

    suite=MOxUnitTestSuite();
    for k=1:numel(filenames)
        filename=filenames{k};
        if isdir(filename)
            suite=addFromDirectory(suite,filename);
        else
            suite=addFromFile(suite,filename);
        end
    end
    fprintf(fid,'%s\n',str(suite));

    test_init=MOxUnitTestResult(verbosity, fid);

    test_result=run(suite, test_init);
    disp(test_result);

    result=wasSuccessful(test_result);


function [verbosity,filenames,fid]=get_params(varargin)
    n=numel(varargin);

    % set defaults
    verbosity=1;
    filenames=cell(n,1);
    fid=1;

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
                verbosity=verbosity+1;

            case '-logfile'
                if k==n
                    error('moxunit:missingParameter',...
                           'Missing parameter after option ''%s''',arg);
                end
                k=k+1;
                fn=varargin{k};

                fid=fopen(fn,'w');
                if fid==-1
                    error('Could not open file %s for writing', fn);
                end

            otherwise

                if ~isempty(dir(arg))
                    filenames{k}=arg;
                else
                    error('moxunit:illegalParameter',...
                    'File not found: %s', arg);
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

