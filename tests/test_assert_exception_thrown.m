function test_suite=test_assert_exception_thrown()
    initTestSuite;

% Test cases where exceptions are thrown and that is OK
function test_assert_exception_thrown_passes
    assertExceptionThrown(@()error('Throw w/o ID'));
    assertExceptionThrown(@()error('moxunit:error','msg'),...
        'moxunit:error');
    assertExceptionThrown(@()error('moxunit:error','msg'),...
        'moxunit:error','message');
    assertExceptionThrown(@()error('moxunit:error','msg'),...
        'message');
    
% Test cases where func throws exceptions and we need to throw as well
function test_assert_exception_thrown_exceptions
    % Verify that when func throws but the wrong exception comes out, we respond
    % with the correct exception (assertExceptionThrown:wrongException)
    try
        assertExceptionThrown(@()error('moxunit:error','msg'),...
                                    'moxunit:failed','msg');
        did_throw = false;
    catch
        caught_error = lasterror();
        did_throw = true;
    end

    if did_throw
        if ~strcmp(caught_error.identifier,'moxunit:wrongExceptionRaised')
            error('moxunit:wrongExceptionRaised',...
                    ['Expected exception ''moxunit:wrongExceptionRaised'', ',...
                     'but got ''%s'''], caught_error.identifier);
        end
    else
        error('moxunit:exceptionNotRaised',...
                'Expected exception, ''moxunit:error'', not thrown');
    end
    
    
% Test cases where func does not throw but was expected to do so
function test_assert_exception_thrown_exceptions_not_thrown

    % For all combination of optional arguments we expect the same behavior.
    % We will loop, testing all combinations here
    argArray = {...
        {},...                  % No arguments
        {'moxunit:failed'},...  % Identifier only
        {'Some message'},...    % Message only
        {'a:b','msg'}};         % Identifier and message
    
    for argCell = argArray
        % Strip the wrapping cell array
        argCell = argCell{1};
        
        % Run the test
        try
            assertExceptionThrown(@do_nothing,argCell{:});
            did_throw=false;
        catch
            caught_error=lasterror();
            did_throw=true;
        end
        
        if did_throw
            if ~strcmp(caught_error.identifier,'moxunit:exceptionNotRaised')
                error('moxunit:exceptionNotRaised',...
                    ['Expected exception ''moxunit:exceptionNotRaised'' ',...
                    'but got ''%s'''], caught_error.identifier);
            end
        else
            error('moxunit:exceptionNotRaised',...
                'Expected exception, ''moxunit:error'', not thrown');
        end
        
    end
    

function do_nothing
    % do nothing