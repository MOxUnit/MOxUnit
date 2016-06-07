function test_suite=test_assert_exception_thrown()
    initTestSuite;

% Test cases where exceptions are thrown and that is OK
function test_assert_exception_thrown_passes
    assertExceptionThrown(@()error('Throw w/o ID'));
    assertExceptionThrown(@()error('moxunit:error','msg'),...
        'moxunit:error');
    assertExceptionThrown(@()error('moxunit:error','msg'),...
        'moxunit:error','message');
    
% Test cases where func throws exceptions and we need to throw as well
function test_assert_exception_thrown_exceptions
    % Verify that when func throws but the wrong exception comes out, we respond
    % with the correct exception (assertExceptionThrown:wrongException)
    try
        assertExceptionThrown(@()error('moxunit:error','msg'),...
                                    'moxunit:failed','msg');
        did_throw=false;
    catch
        caught_error=lasterror();
        did_throw=true;
    end

    if did_throw
        if ~strcmp(caught_error.identifier,'assertExceptionThrown:wrongException')
            error('assertExceptionThrown:wrongException',...
                    'Expected exception moxunit: error but got ''%s''',...
                        caught_error.identifier);
        end
    else
        error('assertExceptionThrown:noException',...
                'Expected exception ''moxunit:error'' but not thrown');
    end
    
    
% Test cases where func does not throw but was expected to do so
function test_assert_exception_thrown_exceptions_not_thrown

    try
        assertExceptionThrown(@do_nothing,'moxunit:failed','msg');
        did_throw=false;
    catch
        caught_error=lasterror();
        did_throw=true;
    end

    if did_throw
        if ~strcmp(caught_error.identifier,'assertExceptionThrown:noException')
            error('assertExceptionThrown:wrongException',...
                    'Expected exception ''moxunit:error'' but got %s',...
                        caught_error.identifier);
        end
    else
        error('assertExceptionThrown:noException',...
                'Expected exception ''moxunit:error'' but not thrown');
    end
    

function do_nothing
    % do nothing