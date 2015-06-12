function test_suite=test_assert_exception_thrown()
    initTestSuite;

function test_assert_exception_thrown_exceptions
    try
        assertExceptionThrown(@()error('moxunit:error','msg'),...
                                    'moxunit:failed','msg');
        did_throw=false;
    catch
        caught_error=lasterror();
        did_throw=true;
    end

    if did_throw
        if ~strcmp(caught_error.identifier,'moxunit:wrongExceptionRaised')
            error('moxunit:wrongExceptionRaised',...
                    'Expected exception moxunit: error but got ''%s''',...
                        caught_error.identifier);
        end
    else
        error('moxunit:exceptionNotRaised',...
                'Expected exception ''moxunit:error'' but not thrown');
    end

function test_assert_exception_thrown_exceptions_not_thrown

    try
        assertExceptionThrown(@()disp(''),'moxunit:failed','msg');
        did_throw=false;
    catch
        caught_error=lasterror();
        did_throw=true;
    end

    if did_throw
        if ~strcmp(caught_error.identifier,'moxunit:exceptionNotRaised')
            error('moxunit:wrongExceptionRaised',...
                    'Expected exception ''moxunit:error'' but got %s',...
                        caught_error.identifier);
        end
    else
        error('moxunit:exceptionNotRaised',...
                'Expected exception ''moxunit:error'' but not thrown');
    end


function test_assert_exception_thrown_passes
    assertExceptionThrown(@()error('moxunit:error','msg'),...
                                            'moxunit:error');
    assertExceptionThrown(@()error('moxunit:error','msg'),...
                                            'moxunit:error','message');
