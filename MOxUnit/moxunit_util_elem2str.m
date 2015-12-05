function elem_str=moxunit_util_elem2str(elem, max_chars)
% Convert element to string representation
%
% expr_str=moxunit_util_elem2str(expr[, max_chars])
%
% Inputs:
%   expr            value of any type
%   max_chars       optional maximum size of the output (default: 100)
%
% Output:
%   elem_str        string representation of expr. If the platform is
%                   Octave, it contains the name of the class of expr.
%                   If the platform is Matlab. it shows the results of
%                   disp(expr)
%
% Note:
%   - because evalc is not implemented in Octave (yet), it is not possible
%     to capture the output from disp in a variable; hence only the class
%     of the first input is shown
%
% NNO, SCL 2014-2015

    if nargin<2
        max_chars=100;
    end

    if ischar(elem)
        % Strings are trivally supported by leaving them as-is
        % We just encapsulate in quotation marks to make it clear they
        % are a string.
        elem_str=['''' elem ''''];

    elseif isnumeric(elem) && numel(elem) < max_chars
        % If the element is numeric, we can use mat2str
        elem_str=mat2str(elem);

    elseif exist('evalc', 'builtin')
        % If we have `evalc`, we can just trust the `display` function
        % provided by the environment to format the string correctly
        % and capture it with `evalc`.
        elem_str=evalc('disp(elem)');

        % remove trailing newlines
        elem_str=elem_str(1:(end-2));

        if iscell(elem)
            % Encapsulate output in curly braces if it is a cell.
            % These are not included by disp.
            elem_str = ['{ ' strtrim(elem_str) ' }'];
        end

    else
        % Octave does not support evalc, so we need a work around.
        % As a fall back, we just show the class of the element
        % with the size, if we can get it.
        try
            siz = arrayfun(@num2str, size(elem), 'UniformOutput', false);
            sizstr = strjoin(siz, 'x');
            sizstr = [sizstr ' '];
        catch
            sizstr = '';
        end
        elem_str = sprintf('%s%s\n', sizstr, class(elem));
        % NB: we can't return '<class CLASSNAME>' because the < >
        % characters will wreck havok with the XML output and
        % escaping them causes problems when outputting them in
        % MATLAB/Octave.

    end

    if numel(elem_str)>max_chars
        n=floor(max_chars/2);
        infix=sprintf('\n...\n');
        elem_str=[elem_str(1:n) infix elem_str(end+((1-n):0))];
    end
