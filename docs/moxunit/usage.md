# Usage

## Defining MOxUnit tests

To define unit tests, write a function with the following header:

```matlab
function test_suite=test_of_abs
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions=localfunctions();
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
```

## Important

-   It is crucial that the output of the main function is a variable named `test_suite`, and that the output of `localfunctions` is assigned to a variable named `test_functions`.
-   As of Matlab 2016b, Matlab scripts (such as `initTestSuite.m`) do not have access to subfunctions in a function if called from that function. Therefore it requires using localfunctions to obtain function handles to local functions. The "try-catch-end" statements are necessary for compatibility with older versions of GNU Octave, which do not provide the `localfunctions` function.
-   Alas, the call to `localfunctions` **cannot** be incorporated into `initTestSuite` so the entire code snippet above has to be the header of each test file

Then, define subfunctions whose name start with `test` or end with `test` (case-insensitive). These functions can use the following `assert*` functions:

-   `assertTrue(a)`: assert that `a` is true.
-   `assertFalse(a)`: assert that `a` is false.
-   `assertEqual(a,b)`: assert that `a` and `b` are equal.
-   `assertElementsAlmostEqual(a,b)`: assert that the floating point arrays `a` and `b` have the same size, and that corresponding elements are equal within some numeric tolerance.
-   `assertVectorsAlmostEqual(a,b)`: assert that floating point vectors `a` and `b` have the same size, and are equal within some numeric tolerance based on their vector norm.
-   `assertExceptionThrown(f,id)`: assert that calling `f()` throws an exception with identifier `id`. (To deal with cases where Matlab and GNU Octave throw errors with different identifiers, use `moxunit_util_platform_is_octave`. Or use `id='*'` to match any identifier).

As a special case, `moxunit_throw_test_skipped_exception('reason')` throws an exception that is caught when running the test; `moxunit_run_tests` will report that the test is skipped for reason `reason`.

For example, the following function defines three unit tests that tests some possible inputs from the builtin `abs` function:

```matlab
function test_suite=test_of_abs
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions=localfunctions();
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;

function test_abs_scalar
    assertTrue(abs(-1)==1)
    assertEqual(abs(-NaN),NaN);
    assertEqual(abs(-Inf),Inf);
    assertEqual(abs(0),0)
    assertElementsAlmostEqual(abs(-1e-13),0)

function test_abs_vector
    assertEqual(abs([-1 1 -3]),[1 1 3]);

function test_abs_exceptions
    % GNU Octave and Matlab use different error identifiers
    if moxunit_util_platform_is_octave()
        assertExceptionThrown(@()abs(struct),'');
    else
        assertExceptionThrown(@()abs(struct),...
                             'MATLAB:UndefinedFunction');
    end
```

Examples of unit tests are in MOxUnit's `tests` directory, which test some of MOxUnit's functions itself.

## Running MOxUnit tests

-   `cd` to the directory where the unit tests reside. For MOxUnit itself, the unit tests are in the directory `tests`.

-   run the tests using `moxunit_runtests`. For example, running `moxunit_runtests` from MOxUnit's `tests` directory runs tests for MOxUnit itself, and should give the following output:

    ```matlab
    >> moxunit_runtests
    suite: 98 tests
    ............................................................
    ......................................
    --------------------------------------------------

      OK (passed=98)
      ans =
        logical
        1
    ```

-   `moxunit_runtests`, by default, gives non-verbose output and runs all tests in the current directory. This can be changed using the following arguments:
    -   `-verbose`: show verbose output.
    -   `-quiet`: suppress all output
    -   `directory`: run unit tests in directory `directory`.
    -   `file.m`: run unit tests in file `file.m`.
    -   `-recursive`: add files from directories recursively.
    -   `-logfile logfile.txt`: store the output in file `logfile.txt`.
    -   `-junit_xml_file xmlfile`: store JUnit-like XML output in file `xmlfile`.

-   To test MOxUnit itself from a terminal, run:

    ```bash
    make test
    ```

## Compatibility notes

-   Because GNU Octave 3.8 does not support `classdef` syntax, 'old-style' object-oriented syntax is used for the class definitions. For similar reasons, MOxUnit uses the `lasterror` function, even though its use in Matlab is discouraged.

-   Recent versions of Matlab (2016 and later) do not support tests defined just using "initTestSuite", that is without the use of `localfunctions` (see above). To ease the transition, consider using the Python script `tools/fix_mfile_test_init.py`, which can update existing .m files that do not use `localfunctions`.

    For example, the following command was used on a Unix-like shell to preview changes to MOxUnit's tests:

    ```bash
      find tests -iname 'test*.m' | xargs -L1 tools/fix_mfile_test_init.py
    ```

    and adding the `--apply` option applies these changes, meaning that found files are rewritten:

    ```bash
      find tests -iname 'test*.m' | xargs -L1 tools/fix_mfile_test_init.py --apply
    ```

-   Recent versions of Matlab define a `matlab.unittest.Test` class for unit tests. An instance `t` can be used with MOxUnit using the `MOxUnitMatlabUnitWrapperTestCase(t)`, which is a `MOxUnitTestCase` instance. Tests that are defined through

    ```matlab
    function tests=foo()
       tests=functiontests(localfunctions)

    function test_funcA(param)

    function test_funcA(param)
    ```

    can be run using MOxUnit as well (and included in an ``MOxUnitTestSuite`` instance using its with ``addFile``) instance, with the exception that currently setup and teardown functions are currently ignored.
