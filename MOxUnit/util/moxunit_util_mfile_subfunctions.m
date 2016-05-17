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
% Example:
%    Running this function on itself returns two subfunctions,
%    'read_file' and 'apply_text_replacements'
%
% Notes:
%   - this function uses a simple pattern matching algorithm which may
%     not work correctly if some weird unexpected syntax is used
%   - nested subfunctions are returned by this funtion as well
%   - in matlab, "which('-subfun',fn)" can be used as an alternative to
%     this function; Octave does not support this usage of "which"
%
% NNO Jan 2014

    raw_text=read_file(fn);

    newline=sprintf('\n');
    dos_newline=sprintf('\r\n');

    % simplify the contents of the file
    % - convert DOS-style newlines to Unix-style newlines
    % - remove line continuations
    % - replace newlines by double newlines, so that the end of a function
    %   name can be detected through the presence of whitespace
    replacements={dos_newline, newline;...
                  ['...' newline],'';...
                  newline,[newline newline]};
    text=apply_text_replacements(replacements, raw_text);

    % function outputs can be specifed in three ways, namely with zero,
    % one, or more than one output
    single_argout_pat='\s+[\w~]+';                      % ' aa'
    argument_argout_pat='\s*\[[\w~,\s]*\]';             % '[aa, bb]'
    with_argout_pat=sprintf('((%s)|(%s))\\s*=\\s*',...  % '<argin> = '
                                    single_argout_pat,...
                                    argument_argout_pat);
    without_argout_pat='\s+';                          % '  ' (whitespace)
    argout_pat=sprintf('(%s|%s)',with_argout_pat,without_argout_pat);

    % function name that we are after
    func_name_pat='(?<name>\w*)';

    % input arguments and function name
    prefix=[newline '\s*'];
    postfix='([\W$])';

    % complete pattern of a function (excluding input arguments)
    pat=sprintf('%sfunction%s%s%s',...
                        prefix,argout_pat,func_name_pat,postfix);

    match=regexp([newline text newline],pat,'names');

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

function text=apply_text_replacements(replacements, text)
    for k=1:size(replacements,1)
        row=replacements(k,:);
        text = strrep(text, row{1}, row{2});
    end

