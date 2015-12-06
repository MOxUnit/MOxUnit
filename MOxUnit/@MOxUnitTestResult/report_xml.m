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
    if strncmp(classpath, pwd, length(pwd))
        classpath = classpath(min(length(pwd)+1,length(classpath)):end);
    end
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
            reason.message = strip_xml(reason.message);
            x = [x, ' line="' num2str(es.line) '"' ...
                    '>' ...
                    '<system-err message="' ...
                        get_first_line(reason.message) ...
                        '">' ...
                    reason.message ...
                    '</system-err>' ...
                    '</testcase>' ...
                    ];

        case 'f'
            % Fill the contents for a failure
            es = reason.stack(1);
            reason.message = strip_xml(reason.message);
            x = [x, ' line="' num2str(es.line) '"' ...
                    '>' ...
                    '<failure message="' ...
                        get_first_line(reason.message) ...
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


function string=strip_xml(string)
% Strip XML tags from a string
%
% string=strip_xml(string)
%
% Inputs:
%   string          A string which may contain XML tags Any '<' and '>'
%                   characters which are not part of an XML tag should
%                   be escaped as '\<' and '\>', otherwise they will be
%                   removed.
%
% Output:
%   string          The string with any XML tags removed. Any escaped
%                   characters ('\<', '\>') remain as they are - still
%                   escaped.
%
% SCL 2015

    % We check to make sure the character before the '<' isn't a '\' or
    % the start of the string. If it isn't, we capture until the next
    % non-escaped '>' character and remove the whole chunk. However,
    % we need to include the leading non-'\' character (the first group)
    % in the replacement output.
    string = regexprep(string , '(^|[^\\])(<.*?[^\\]>)', '$1');


function string=get_first_line(string)
% Get the first line (before newline character) of a string
%
% string=get_first_line(string)
%
% Inputs:
%   string          A string, possibly multiline.
%
% Output:
%   string          The string with any XML tags removed. Any escaped
%                   characters ('\<', '\>') remain as they are - still
%                   escaped.
%
% SCL 2015

    % Trim off any newlines from the start of the string
    % NB: sprintf('\n')==10
    string = strtrim(string);
    start_index = find(string(2:end)~=10, 1);
    if isempty(start_index)
        % Only line feed characters are present.
        string = '';
        return;
    end
    string = string(start_index:end);

    % Find the first new line character.
    % The index returned is the index of the character before
    % the newline.
    term_index = find(string(2:end)==10, 1);
    % If the index is empty, there are no new lines so we include the whole
    % string in the output
    if isempty(term_index)
        return;
    end
    % Otherwise we can trim down to just before the first new line.
    string = string(1:term_index);
