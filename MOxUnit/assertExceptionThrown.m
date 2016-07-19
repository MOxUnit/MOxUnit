% assertExceptionThrown - Assert that an exception is thrown
%{ 
%-------------------------------------------------------------------------------
% SYNTAX:
%   assertExceptionThrown(func, <expectedID>, <message>)
%
% PURPOSE:
%   This function allows one to test for exceptions being thrown, and
%   optionally, pass a custome message in response to a failure.
%
%   e.g.
%   % Assert that sin will throw when its argument is a struct
%   >> assertExceptionThrown( @()sin( struct([]) ) )
%
%   % Assert that sin throws AND that the ID is 'MATLAB:UndefinedFunction'
%   >> assertExceptionThrown( @()sin( struct([]) ), 'MATLAB:UndefinedFunction')
%  
% INPUT:
%   func        - Function handle that is expected to throw, with the prototype
%                   [varargout{:}] = func()
%   expectedID  - Idenitifier of the expected exception.  When exactly two 
%                 inputs are passed an ambiguity arises between expectedID and
%                 message because these inputs share a common type.  By default,
%                 we resolve this ambiguity using
%                 moxunit_util_is_message_identifier().  If any exception is
%                 permitted, expectedID should be omitted or be set to '*'.
%                   Default: ''
%   message     - Custom message to be included when func fails to throw
%   
% THROWS:
%   'moxunit:exceptionNotRaised'    - func() does not raise an exception but was
%                                     expected to do so.
%   'moxunit:wrongExceptionRaised'  - func() does raise an exception but with
%                                     an identifier different from expected_id
%
% ASSUMPTIONS: 
%   All input variables are of the correct type, valid (if applicable), and 
%   given in the correct order. 
%
% See also moxunit_util_is_message_identifier
%-------------------------------------------------------------------------------
%}
function assertExceptionThrown(func, expectedID, message)

% Parse Inputs
switch nargin
    case 1
        expectedIDPassed = false;
        message = '';
        
    case 2
        if isequal(expectedID,'*')          % Any exception is permitted
            expectedIDPassed = false;
            message = '';
            
        elseif moxunit_util_is_message_identifier(expectedID)
            expectedIDPassed = true;
            message = '';
        else
            expectedIDPassed = false;
            message = expectedID;
        end
        
    case 3
        if isequal(expectedID,'*')
            expectedIDPassed = false;
        else
            expectedIDPassed = true;
        end
        % Do nothing
        
    otherwise
        error('assertExceptionThrown:unexpectedInput',...
            'Unexpected number of inputs');
end


% Check func for an exception and capture it.  The Matlab style exception offers
% no real benefits as of now.
try
    func();
    funcException = false;
catch
    funcException = true;
    [foundMsg,foundID] = lasterr();     % Avoiding '~' for compatibility
end


% Check for that exception meeting an id requirement
if ~funcException
    error_id = 'moxunit:exceptionNotRaised';
    if expectedIDPassed
        whatswrong = sprintf('expected exception ''%s'' was not raised',...
            expectedID);
    else
        whatswrong = 'exception was not raised';
    end
    
elseif expectedIDPassed && ~isequal(expectedID, foundID)
    whatswrong = sprintf(...
        'exception ''%s'' was raised, expected ''%s''',...
        foundID, expectedID);
    error_id = 'moxunit:wrongExceptionRaised';
else
    return;
end

if nargin<3
    message='';
end

full_message=moxunit_util_input2str(message,whatswrong);

if moxunit_util_platform_is_octave()
    error(error_id,full_message);
else
    throwAsCaller(MException(error_id, full_message));
end

end

