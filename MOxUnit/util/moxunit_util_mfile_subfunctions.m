function names=moxunit_util_mfile_subfunctions(fn)
% find the names of subfunctions defined in an .m file
%
% names=moxunit_util_mfile_subfunctions(fn)
%
% Input:
%   fn                  filename of .m file
%
% Output:
%   names               1xP cell with the names of subfunctions in fn.
%
% Notes:
%   - this function uses a simple pattern matching algorithm which may
%     not work correctly if some weird unexpected syntax is used
%   - nested subfunctions are returned by this funtion as well
%   - in matlab, which('-subfun',fn) can be used as an alternative to
%     this function; Octave does not support this usage of which
%
% NNO Jan 2014

    text_with_line_continuation=read_file(fn);

    % remove line continuation
    newline=sprintf('\n');
    line_continuation=['...' newline];

    % prepend with newline
    text=[newline ...
          strrep(text_with_line_continuation,line_continuation,' ')];

    % sequence of patterns of a function definition:
    % - newline
    % - optionally: some whitespace
    % - optionally: the input arguments and an '=' sign
    % - optionally: some whitespace
    % - the function name (which we want to capture)
    % - optionally: the output arguments

    pat=[newline '\s*function([\[\]\w ,~]*=)?[ ]*'...
                 '(?<name>[a-zA-Z]\w*)(\([^\)]*\))?'];

    match=regexp([' ' text ' '],pat,'names');

    if isempty(match)
        names=cell(0);
    else
        all_names={match.name};
        if iscell(all_names{1})
            % octave returns a cell in a cell
            assert(numel(all_names)==1);
            all_names=all_names{1};
        end

        % remove first function, because that is the main one
        names=all_names(2:end);
    end

function s = read_file(fn)
    fid = fopen(fn);

    if fid==-1
        error('Error reading from file %s\n', fn);
    end

    cleaner = onCleanup(@()fclose(fid));
    s = fread(fid,[1 inf],'char=>char');
