function x = report_xml(obj,c,t,reason)
% Add an XML report of a single test case result
% (error, failure, skip, or success)
%
% report_xml(obj,c,s,t)
%
% Inputs:
%   obj             MOxUnitTestResult instance.
%   c               Single character representation of test case result;
%                   Typically, the following characters are used:
%                   'e' : error
%                   'F' : failure
%                   's' : skip
%                   '.' : success
%   t               MOxUnitTestCase instance with the test.
%   reason          Handle to the error, or a string if no error.
%
% Output:
%   x               The formatted XML report for this testcase.
%
% Notes:
%   - This is a helper function for addError, addFailure, addSkip and
%     addSuccess to add an XML report of a test result to the XML stack
%     in the result object after a test has been run.
%
% See also: report, addError, addFailure, addSkip, addSuccess
%
% SCL 2015

    % Set up the XML node for the testcase.
    % They all start the same way.
    x = '<testcase classname="%s" file="%s" name="%s"';

    % We need to include the classname although we don't rightly have
    % a classname to give. Instead, we use the path to the file.
    classpath = get(t,'location');
    % Remove out the path to the testing directory
    classpath = strrep(classpath, pwd, '');
    % Remove the extension
    [p,n] = fileparts(classpath);
    classpath = fullfile(p,n);
    % Remove the leading slash
    if strcmp(classpath(1), '/')
        classpath = classpath(2:end);
    end
    % Swap / separators for . separators, to resemble object oriented
    % languages which JUnit is initially for.
    %classpath = strrep(classpath, filesep, '.');

    % Inject the parameters into the template
    x = sprintf(x, classpath, get(t,'location'), get(t,'name'));

    switch lower(c(1))
        case 'e'
            % Fill the contents for an error
            es = reason.stack(1);
            x = [x, ' line="' num2str(es.line) '"' ...
                    '>' ...
                    '<system-err message="' ...
                        regexprep(reason.message , '<.*?>','') ...
                        '">' ...
                    reason.message ...
                    '</system-err>' ...
                    '</testcase>' ...
                    ];

        case 'f'
            % Fill the contents for a failure
            es = reason.stack(1);
            x = [x, ' line="' num2str(es.line) '"' ...
                    '>' ...
                    '<failure message="' ...
                        regexprep(reason.message , '<.*?>','') ...
                        '">' ...
                    reason.message ...
                    '</failure>' ...
                    '</testcase>' ...
                    ];

        case 's'
            % Fill the contents for a skipped test
            x = [x, '>' ...
                    '<skipped message="' reason '" />' ...
                    '</testcase>' ...
                    ];
	
        case '.'
            % There are no contents for a success, so we just close
            % the tag
            x = [x, ' />'];
	
        otherwise
            error('moxunit:notImplemented', ...
                  'Unrecognised test case result code: %s', lower(c(1)));

    end