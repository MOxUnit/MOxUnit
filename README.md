[![Build Status](https://travis-ci.org/nno/MOxUnit.svg?branch=master)](https://travis-ci.org/MOxUnit/MOxUnit)
[![CI matlab](https://github.com/MOxUnit/MOxUnit/actions/workflows/CI_matlab..yml/badge.svg)](https://github.com/MOxUnit/MOxUnit/actions/workflows/CI_matlab..yml)
[![CI octave](https://github.com/MOxUnit/MOxUnit/actions/workflows/CI_octave.yml/badge.svg)](https://github.com/MOxUnit/MOxUnit/actions/workflows/CI_octave.yml)
[![Coverage Status](https://coveralls.io/repos/github/MOxUnit/MOxUnit/badge.svg?branch=master)](https://coveralls.io/github/MOxUnit/MOxUnit?branch=master) <!-- omit in toc -->

# MOxUnit 

MOxUnit is a lightweight unit test framework for Matlab and GNU Octave.

- [Features](#features)
- [Installation](#installation)
- [Defining MOxUnit tests](#defining-moxunit-tests)
- [Running MOxUnit tests](#running-moxunit-tests)
- [Use with CI](#use-with-ci)
  - [Travis-CI](#travis-ci)
    - [Octave](#octave)
    - [Matlab](#matlab)
  - [Github-CI](#github-ci)
    - [Octave](#octave-1)
      - [Using the moxunit Github action](#using-the-moxunit-github-action)
    - [Matlab](#matlab-1)
- [Compatibility notes](#compatibility-notes)
- [Limitations](#limitations)

## Features

- Runs on both the [Matlab] and [GNU Octave] platforms.
- Uses object-oriented TestCase, TestSuite and TestResult classes, allowing for user-defined extensions.
- Can be used directly with continuous integration services, such as [Travis-ci] and [Shippable].
- Supports JUnit-like XML output for use with Shippable and other test results visualization approaches.
- Supports the generation of code coverage reports using [MOCov]
- Provides compatibility with the (now unsupported) Steve Eddin's [Matlab xUnit test framework], and with recent Matlab test functionality.
- Distributed under the MIT license, a permissive free software license.

## Installation

- Using the shell (requires a Unix-like operating system such as GNU/Linux or Apple OSX):

    ```bash
    git clone https://github.com/MOxUnit/MOxUnit.git
    cd MOxUnit
    make install
    ```
    This will add the MOxUnit directory to the Matlab and/or GNU Octave searchpath. If both Matlab and GNU Octave are available on your machine, it will install MOxUnit for both.

- Manual installation:

    + Download the [MOxUnit zip archive] from the [MOxUnit] website, and extract it. This should
      result in a directory called ``MOxUnit-master``.
    + Start Matlab or GNU Octave.
    + On the Matlab or GNU Octave prompt, go to the directory that contains the new ``MOxUnit-master`` directory, then run:

        ```matlab
        % change to the MOxUnit subdirectory
        %
        % Note: if MOxUnit was retrieved using 'git', then the name of
        %       top-level directory is 'MOxUnit', not 'MOxUnit-master'
        cd MOxUnit-master/MOxUnit

        % add the current directory to the Matlab/GNU Octave path
        moxunit_set_path()

        % save the path
        savepath
        ```

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

### Important <!-- omit in toc -->

- It is crucial that the output of the main function is a variable named `test_suite`, and that the output of `localfunctions` is assigned to a variable named `test_functions`.
- As of Matlab 2016b, Matlab scripts (such as `initTestSuite.m`) do not have access to subfunctions in a function if called from that function. Therefore it requires using localfunctions to obtain function handles to local functions. The "try-catch-end" statements are necessary for compatibility with older versions of GNU Octave, which do not provide the `localfunctions` function.
- Alas, the call to `localfunctions` **cannot** be incorporated into `initTestSuite` so the entire code snippet above has to be the header of each test file

Then, define subfunctions whose name start with `test` or end with `test` (case-insensitive). These functions can use the following `assert*` functions:

- `assertTrue(a)`: assert that `a` is true.
- `assertFalse(a)`: assert that `a` is false.
- `assertEqual(a,b)`: assert that `a` and `b` are equal.
- `assertElementsAlmostEqual(a,b)`: assert that the floating point arrays `a` and `b` have the same size, and that corresponding elements are equal within some numeric tolerance.
- `assertVectorsAlmostEqual(a,b)`: assert that floating point vectors `a` and `b` have the same size, and are equal within some numeric tolerance based on their vector norm.
- `assertExceptionThrown(f,id)`: assert that calling `f()` throws an exception with identifier `id`. (To deal with cases where Matlab and GNU Octave throw errors with different identifiers, use `moxunit_util_platform_is_octave`. Or use `id='*'` to match any identifier).

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

- `cd` to the directory where the unit tests reside. For MOxUnit itself, the unit tests are in the directory `tests`.
- run the tests using `moxunit_runtests`. For example, running `moxunit_runtests` from MOxUnit's `tests` directory runs tests for MOxUnit itself, and should give the following output:

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

- `moxunit_runtests`, by default, gives non-verbose output and runs all tests in the current directory. This can be changed using the following arguments:
  - `-verbose`: show verbose output.
  - `-quiet`: suppress all output
  - `directory`: run unit tests in directory `directory`.
  - `file.m`: run unit tests in file `file.m`.
  - `-recursive`: add files from directories recursively.
  - `-logfile logfile.txt`: store the output in file `logfile.txt`.
  - `-junit_xml_file xmlfile`: store JUnit-like XML output in file `xmlfile`.

- To test MOxUnit itself from a terminal, run:

  ```
  make test
  ```

## Use with CI

### Travis-CI

MOxUnit can be used with the [Travis-ci] service for continuous integration (CI) testing. This is achieved by setting up a [.travis.yml configuration file](.travis.yml). This file is also used by [Shippable]. As a result, the test suite is run automatically on both [Travis-ci] and [Shippable] every time it is pushed to the github repository, or when a pull request is made. If a test fails, or if all tests pass after a test failed before, the developers are notified by email.

#### Octave

The easiest test to set up on Travis and/or Shippable is with [GNU Octave]. Make sure your code is Octave compatible. Note that many Matlab projects tend to use functionality not present in Octave (such as particular functions), whereasand writing code that is both Matlab- and Octave-compatible may require some additional efforts.

A simple `.travis.yml` file for a project could look like that:

```yaml
language: generic
os: linux
      
before_install:
  - sudo apt-get install octave

before_script:
  - git clone https://github.com/MOxUnit/MOxUnit.git
  - make -C MOxUnit install

script:        
  - make test
```

In this case `make test` is used to run the tests. To avoid a Makefile and run tests directly through Octave, the script has to call Octave directly to run the tests:

  ```yaml
  # ...
  before_script:
  - git clone https://github.com/MOxUnit/MOxUnit.git

  script:
    - octave --no-gui --eval "addpath('~/git/MOxUnit/MOxUnit');moxunit_set_path;moxunit_runtests('tests')"
  ```

Note that MOxUnit tests **itself** on travis, with [this](https://github.com/MOxUnit/MOxUnit/blob/master/.travis.yml) travis file.

#### Matlab

Travis [now supports Matlab](https://docs.travis-ci.com/user/languages/matlab/) directly. You can use MOxUnit with it, but its tricky because:
  1) Travis only supports Matlab 2020a and, presumably, higher (at the time of writing 2020a is the newest version).
  2) Makefile installation does not work with Matlab on travis.
  3) Nor does calling Matlab from the command line in a usual way - with ` matlab -nodesktop -nosplash ...` . Instead it has to be called with the `-batch` flag.
  
  Therefore, `.travis.yml` file looks as follows:
  ```yml
  language: matlab
  matlab: R2020a
  os: linux

  # Just clone MOxUnit, `don't make install` it (!)
  before_script:
    - git clone https://github.com/MOxUnit/MOxUnit.git
      
  script: 
    - matlab -batch 'back=cd("./MOxUnit/MOxUnit/"); moxunit_set_path(); cd(back); moxunit_runtests tests -verbose; exit(double(~ans))'
  ```

  `exit(double(~ans))` ensures that the build fails if MOxUnit tests fail.

### Github-CI

#### Octave

##### Using the moxunit Github action

There is a "preset" github action will test your code with Ubuntu and Octave. 
To use it, create a YML file in your `.github/workflows` with the following content.

You will need to update the line

```yml
        src: FIXME
```

to make sure it points to where your source code is.

```yaml
name: CI octave action

# Controls when the action will run. 
# Triggers the workflow on push or pull request
# events but only for the master branch. 
# Update accordingly if you want to test other branches ('main', 'dev' or all with '*')
on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "unit-tests"
  unit-tests:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
    # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
    - uses: actions/checkout@v2

    # Use A Github Action to perform tests
    - name: run unit tests and documentation tests, generate coverage report
      uses: joergbrech/moxunit-action@v1.1
      with:
        tests: tests
        src: FIXME
        with_coverage: true
        doc_tests: true
        cover_xml_file: coverage.xml

    # Store the coverage report as an artifact
    - name: Store Coverage report as artifact
      uses: actions/upload-artifact@v1
      with:
        name: coverage_xml_file
        path: coverage.xml
    
    # Use a Github Action to publish coverage reports
    - name: Publish coverage report to codecov.io
      uses: codecov/codecov-action@v1
      with:
        file: ./coverage.xml
```

#### Matlab

You can test your code with Matlab on Github actions with several operating systems and Matlab versions.
To use it, create a YML file in your `.github/workflows` with the following content.

You will need to update the values for `path/to/src` and `path/to/tests` to make sure it points to where your source code and tests are.

```yml
name: CI matlab

# - Installs
#   - MATLAB github action
#   - MOXunit
#   - MOcov
# - Runs tests
# - If tests pass, uploads coverage to codecov

# Controls when the action will run. 
# Triggers the workflow:
#   - on push for the master branch 
#   - on pull request for all branches
on:
  push:
    branches: [master]
  pull_request:
    branches: ['*']

jobs:
  matlab_tests:

    strategy:
      matrix:
        # Note that some older versions (e.g R2020a, R2020b...) may not be available on all OS
        matlab_version: [R2022a, R2022b, R2023a]
        os: [ubuntu-latest, macos-latest, windows-latest]
      fail-fast: false  # Don't cancel all jobs if one fails

    runs-on: ${{ matrix.os }}

    steps:

    # use matlab-actions/setup-matlab to setup a specific version of MATLAB
    # https://github.com/matlab-actions/setup-matlab
    - name: Install MATLAB
      uses: matlab-actions/setup-matlab@v1.2.4
      with:
        release: ${{ matrix.matlab_version }}

    # Checkout your repository (or the one whose tests you want to run)
    # to the GitHub Actions runner.
    - name: Checkout repository
    - uses: actions/checkout@v3

    - name: Install Moxunit and MOcov
      run: |
        git clone https://github.com/MOxUnit/MOxUnit.git --depth 1
        git clone https://github.com/MOcov/MOcov.git --depth 1

    # use matlab-actions/setup-matlab to run a matlab command
    # https://github.com/matlab-actions/setup-matlab
    - name: Run tests
      uses: matlab-actions/run-command@v1.1.3
      # This command will
      # - add MOxUnit and MOcov to the path
      # - run the tests
      # - exit with the result
      with:
        command: "cd('./MOxUnit/MOxUnit/'); moxunit_set_path(); cd ../..; addpath(fullfile(pwd, 'MOcov', 'MOcov')); moxunit_runtests path/to/tests -verbose -with_coverage -cover path/to/src -cover_xml_file coverage.xml; exit(double(~ans))"

    - name: Upload code coverage
      uses: codecov/codecov-action@v3
      with:
        file: coverage.xml
        flags: ${{ matrix.os }}_matlab-${{ matrix.matlab_version }}
        name: codecov-umbrella 
        fail_ci_if_error: false
```

Note that MOxUnit and MOcov have to be added to the path as part of the command
before running the tests, which can make the one-liner command quite long and hard to read.

```yml
      uses: matlab-actions/run-command@v1.1.3
      with:
        command: "cd('./MOxUnit/MOxUnit/'); moxunit_set_path(); cd ../..; addpath(fullfile(pwd, 'MOcov', 'MOcov')); moxunit_runtests path/to/tests -verbose -with_coverage -cover path/to/src -cover_xml_file coverage.xml; exit(double(~ans))"
```

So you can instead create a `run_tests.m` file in your repository with the following content:

```matlab
cd('./MOxUnit/MOxUnit/');
moxunit_set_path();
cd ../..;

addpath(fullfile(pwd, 'MOcov', 'MOcov'));

moxunit_runtests path/to/tests -verbose -with_coverage -cover path/to/src -cover_xml_file coverage.xml;

exit(double(~ans))
```

And simplify your workflow like this.

```yml
      uses: matlab-actions/run-command@v1.1.3
      with:
        command: "run_tests"
```

## Compatibility notes

- Because GNU Octave 3.8 does not support `classdef` syntax, 'old-style' object-oriented syntax is used for the class definitions. For similar reasons, MOxUnit uses the `lasterror` function, even though its use in Matlab is discouraged.
- Recent versions of Matlab (2016 and later) do not support tests defined just using "initTestSuite", that is without the use of `localfunctions` (see above). To ease the transition, consider using the Python script `tools/fix_mfile_test_init.py`, which can update existing .m files that do not use `localfunctions`.

  For example, the following command was used on a Unix-like shell to preview changes to MOxUnit's tests:

  ```bash
    find tests -iname 'test*.m' | xargs -L1 tools/fix_mfile_test_init.py
  ```

  and adding the `--apply` option applies these changes, meaning that found files are rewritten:

  ```bash
    find tests -iname 'test*.m' | xargs -L1 tools/fix_mfile_test_init.py --apply
  ```
- Recent versions of Matlab define a `matlab.unittest.Test` class for unit tests. An instance `t` can be used with MOxUnit using the `MOxUnitMatlabUnitWrapperTestCase(t)`, which is a `MOxUnitTestCase` instance. Tests that are defined through

  ```matlab
  function tests=foo()
      tests=functiontests(localfunctions)

  function test_funcA(param)

  function test_funcA(param)
  ```

  can be run using MOxUnit as well (and included in an ``MOxUnitTestSuite`` instance using its with ``addFile``) instance, with the exception that currently setup and teardown functions are currently ignored.

## Limitations

Currently MOxUnit does not support:
- Documentation tests require [MOdox].
- Support for setup and teardown functions in `TestCase` classes.
- Subclasses of MOxUnit's classes (`MOxUnitTestCase`, `MOxUnitTestSuite`, `MOxUnitTestReport`) have to be defined using "old-style" object-oriented syntax.
- Subtests

## Acknowledgements <!-- omit in toc -->

- The object-oriented class structure was inspired by the [Python unit test] framework.
- The `assert*` function signatures are aimed to be compatible with Steve Eddin's [Matlab xUnit test framework].

## Contact <!-- omit in toc -->

Nikolaas N. Oosterhof, n dot n dot oosterhof at googlemail dot com.

## Contributions <!-- omit in toc -->

- Thanks to Scott Lowe, Thomas Feher, Joel LeBlanc, Anderson Bravalheri, Sven Baars, 'jdbancal', Marcin Konowalczyk for contributions.

[GNU Octave]: http://www.gnu.org/software/octave/
[Matlab]: http://www.mathworks.com/products/matlab/
[Matlab xUnit test framework]: http://it.mathworks.com/matlabcentral/fileexchange/22846-matlab-xunit-test-framework
[MOdox]: https://github.com/MOdox/MOdox
[MOxUnit]: https://github.com/MOxUnit/MOxUnit
[MOxUnit zip archive]: https://github.com/MOxUnit/MOxUnit/archive/master.zip
[MOcov]: https://github.com/MOcov/MOcov
[Python unit test]: https://docs.python.org/2.6/library/unittest.html
[Travis-ci]: https://travis-ci.org
[Shippable]: https://app.shippable.com/
