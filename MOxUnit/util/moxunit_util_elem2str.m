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

    has_elem_str=false;
    try
        if numel(elem)<=max_chars
            % try pretty printing
            elem_str=tiny_elem2str(elem);
            has_elem_str=true;
        end
    catch
        % do nothing
    end

    if ~has_elem_str
        % As a fall back (for a big element, an element for which
        % size is not defined, or any element for which disp
        % throwns an exception), just show the class of the element

        % NB: we can't return '<class CLASSNAME>' because the < >
        % characters will wreck havok with the XML output and
        % escaping them causes problems when outputting them in
        % MATLAB/Octave.

        elem_str = sprintf('(%s)', class(elem));
    end

    if numel(elem_str)>max_chars
        n=floor(max_chars/2);
        infix=sprintf('\n...\n');
        elem_str=[elem_str(1:n) infix elem_str(end+((1-n):0))];
    end


function elem_str=tiny_elem2str(elem)
    siz=size(elem);
    if ischar(elem) && numel(siz)==2 && siz(1)==1
        % Strings as row vectors are trivially supported by leaving them
        % as-is. We just encapsulate in quotation marks to make it clear
        % they are a string.


        % (For compatibility with older Matlab versions, "isrow" is not
        %  used.)

        elem_str=['''' elem ''''];

    elseif isnumeric(elem)
        % If the element is numeric, we can use mat2str
        elem_str=mat2str(elem);

    elseif exist('evalc', 'builtin')
        % If we have `evalc`, we can just trust the `display` function
        % provided by the environment to format the string correctly
        % and capture it with `evalc`.
        elem_str=evalc('disp(elem)');

        % remove trailing newlines
        elem_str=regexprep(elem_str,sprintf('[\n]*$'),'');

    else
        % If evalc is not present (Octave), just show the size and
        % the class
        siz_cell = arrayfun(@num2str, siz, ...
                        'UniformOutput', false);
        sizstr = strjoin(siz_cell, 'x');
        elem_str = sprintf('%s(%s)', sizstr, class(elem));
    end
