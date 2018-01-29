function test_suite=test_assert_greater_than()
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions=localfunctions();
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;

function test_assert_greater_than_exceptions
    assertExceptionThrown(@()assertGreaterThan([1],'a'), ...
                          'assertGreaterThan:classNotEqual');
    assertExceptionThrown(@()assertGreaterThan([1 2],[1,2,3]));
    assertExceptionThrown(@()assertGreaterThan(1,1), ...
                          'assertGreaterThan:notGreaterThan');
    assertExceptionThrown(@()assertGreaterThan([2,3,3],[1,2,3]), ...
                          'assertGreaterThan:notGreaterThan');

function test_assert_greater_than_passes
    assertGreaterThan(1,0);
    assertGreaterThan([1,1],[0,0]);
    assertGreaterThan([1,1],[0;0]);
