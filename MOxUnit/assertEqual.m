function assertEqual(a, b, varargin)
% assert that two inputs are equal
%
% assertEqual(a,b,[msg],[tol_name,tol])
%
% Inputs:
%   a           first input  } of any
%   b           second input } type
%   msg             optional custom message
%   tol_name,tol  optional tolerance when comparing numeric arrays a and b.
%               tol_name can be 'RelTol' or 'AbsTol'
%               Note: currently nested arrays are not supported
%
% Raises:
%   'assertEqual:nonEqual'             a and b are of different
%                                      size or values are not equal
%   'assertEqual:classNotEqual         a and b are of different class
%   'assertEqual:sparsityNotEqual'     a is sparse and b is not, or
%                                      vice versa
%   'assertElementsAlmostEqual:tolExceeded' a and b are not equal numeric
%                                      arrays with the specified tolerance
%
% Examples:
%   assertEqual('foo','foo');
%   %|| % passes without output
%
%   assertEqual('foo','bar');
%   %|| error('elements are not equal');
%
%   assertEqual([1 2],[1;2]);
%   %|| error('inputs are not of the same size');
%
% Notes:
%   - If tol_name is 'AbsTol', a and b are considered equal if
%
%           all(abs(a(:)-b(:))<=tol);
%
%   - If tol_type is 'RelTol', a and b are considered equal if
%
%           all(abs(a(:)-b(:))<=tol.*f(b(:)))
%
%     *** note the assymetry in the first two arguments in this case ***
%     *** (it is possible that a is equal to b, but b not to a)      ***
%   - If a custom message is provided, then any error message is prefixed
%     by this custom message.
%   - In this function, NaN values are considered equal.
%   - This function attempts to show similar behaviour as in
%     Steve Eddins' MATLAB xUnit Test Framework (2009-2012)
%     URL: http://www.mathworks.com/matlabcentral/fileexchange/
%                           22846-matlab-xunit-test-framework
%   - TODO: support recursive comparisons with tolerance
%
% NNO Jan 2014

    % Note: although it may seem more logical to compare class before size,
    % for compatibility reasons the order of tests matches that of the
    % MATLAB xUnit framework

    [message, tol_name, tol] = parse_extra_args(varargin{:});

    error_id='';
    if isempty(tol_name)
        if ~isequal(size(a), size(b))
            whatswrong='inputs are not of the same size';
            error_id='assertEqual:nonEqual';

        elseif ~isequal(class(a), class(b))
            whatswrong='inputs are not of the same class';
            error_id='assertEqual:classNotEqual';

        elseif issparse(a)~=issparse(b)
            whatswrong='inputs do not have the same sparsity';
            error_id='assertEqual:sparsityNotEqual';

        elseif ~isequaln_wrapper(a, b)
            whatswrong='elements are not equal';
            error_id='assertEqual:nonEqual';
        end
    else
        % if tolerance given: check if they do not deviate too much
        metric=@abs;
        [unused,error_id,whatswrong]=moxunit_util_floats_almost_equal(...
                                             a,b,metric,true,tol_name,tol);
    end

    if isempty(error_id)
        return
    end

    full_message=moxunit_util_input2str(message,whatswrong,a,b);

    if moxunit_util_platform_is_octave()
        error(error_id,'%s',full_message);
    else
        throwAsCaller(MException(error_id, '%s', full_message));
    end

function tf=isequaln_wrapper(a,b)
% wrapper to support old versions of Matlab
    persistent has_equaln;

    if isempty(has_equaln)
        has_equaln=~isempty(which('isequaln'));
    end

    if has_equaln
        tf=isequaln(a,b);
    else
        tf=isequalwithequalnans(a,b);
    end

function [message, tol_name, tol] = parse_extra_args(varargin)
    message='';
    tol_name='';
    tol=NaN;
    n=numel(varargin);
    k=0;
    while k<n
        k=k+1;
        arg=varargin{k};

        switch arg
            case 'AbsTol'
                if k==n
                    error('Missing argument after %s', arg);
                end
                tol_name='absolute';
                k=k+1;
                tol=varargin{k};

            case 'RelTol'
                tol_name='relative';
                if k==n
                    error('Missing argument after %s', arg);
                end
                k=k+1;
                tol=varargin{k};

            otherwise
                if ~strcmp(message,'')
                    error('multiple message arguments');
                end
                message=arg;
        end
    end

