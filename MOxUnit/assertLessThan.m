function assertLessThan(a, b, message)
% assert that a is less than b
%
% assertLessThan(a,b,[msg])
%
% Inputs:
%   a           first input  } of any
%   b           second input } type
%   msg             optional custom message
%
% Raises:
%   'moxunit:differentSize'         a and b are of different size
%   'moxunit:differentClass         a and b are of different class
%   'moxunit:differentSparsity'     a is sparse and b is not, or
%                                         vice versa
%   'moxunit:elementsNotEqual'      values in a and b are not equal
%
% Examples:
%   assertLessThan(1,2);
%   %|| % passes without output
%
%   assertLessThan(2,1);
%   %|| error('first input argument in not smaller than the second');
%
%   assertLessThan([1 2],[1;2]);
%   %|| error('inputs are not of the same size');
%
% Notes:
%   - If a custom message is provided, then any error message is prefixed
%     by this custom message
%   - This function attempts to show similar behaviour as in
%     Steve Eddins' MATLAB xUnit Test Framework (2009-2012)
%     URL: http://www.mathworks.com/matlabcentral/fileexchange/
%                           22846-matlab-xunit-test-framework
%
% NNO Jan 2014

    % Note: although it may seem more logical to compare class before size,
    % for compatibility reasons the order of tests matches that of the
    % MATLAB xUnit framework

    if ~isequal(size(a), size(b))
        whatswrong='inputs are not of the same size';
        error_id='assertLessThan:nonEqual';

    elseif ~isequal(class(a), class(b))
        whatswrong='inputs are not of the same class';
        error_id='assertLessThan:classNotEqual';

    elseif issparse(a)~=issparse(b)
        whatswrong='inputs do not have the same sparsity';
        error_id='assertLessThan:sparsityNotEqual';

    elseif a >= b
        whatswrong='first input argument in not smaller than the second';
        error_id='assertLessThan:nonEqual';

    else
        % assertion passed
        return;
    end

    if nargin<3
        message='';
    end

    full_message=moxunit_util_input2str(message,whatswrong,a,b);

    if moxunit_util_platform_is_octave()
        error(error_id,'%s',full_message);
    else
        throwAsCaller(MException(error_id, '%s', full_message));
    end