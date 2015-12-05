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
% NNO Jan 2014

    if nargin<2
        max_chars=100;
    end

    if moxunit_util_platform_is_octave()
        elem_str=sprintf('%s\n',class(elem));
    else
        % Octave does not support evalc
        elem_str=evalc('disp(elem)');

        % remove trailing newlines
        elem_str=elem_str(1:(end-2));
    end

    if numel(elem_str)>max_chars
        n=floor(max_chars/2);
        infix=sprintf('\n...\n');
        elem_str=[elem_str(1:n) infix elem_str(end+((1-n):0))];
    end
