function assertExceptionThrown(func, expected_id, message)
% assert that an exception is thrown
%
% assertExceptionThrown(func,expected_id[,msg])
%
% Inputs:
%   func            function handle that should take no inputs and should
%                   raise an exception
%   expected_id     the idenitifier of the exception that func should
%                   raise
%   msg             optional custom message
%
% Throws:
%   'moxunit:exceptionNotRaised'    func() does not raise an exception
%   'moxunit:wrongExceptionRaised'  func() does raise an exception but with
%                                       an identifier different from
%                                       expected_id
%
%
% Raises:
%
    exception_was_raised=false;
    if moxunit_util_platform_is_octave()
        try
            func()
        catch
            exception_was_raised=true;
            [unused,found_id]=lasterr();
        end
    else
        try
            func()
        catch mexception
            exception_was_raised=true;
            found_id=mexception.identifier;
        end
    end

    if ~exception_was_raised
        whatswrong=sprintf('expected exception ''%s'' was not raised',...
                                expected_id);
        error_id='moxunit:exceptionNotRaised';
    elseif ~isequal(expected_id, found_id)
        whatswrong=sprintf(['exception ''%s'' was raised, '...
                                'expected ''%s'''],...
                                found_id, expected_id);
        error_id='moxunit:wrongExceptionRaised';
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

