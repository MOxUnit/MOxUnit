# Usage

## Determining coverage

Coverage can be determined for evaluating a single expression or evaluation of a single function handle;
for typical use cases this invokes running a test suite.

There are two methods to generate coverage while evaluating such an expression or function handle.

### Coverage using the 'file' method

This is the default method used.

- Coverage information is stored internally by the function `mocov_line_covered`, which keeps this information through the use of persistent variables. Initially the coverage information is reset to being empty.
- This method considers all files in a directory (and its subdirectories).
- A temporary directory is created where modified versions of each file is stored.
- Prior to evaluating the expression or function handle, for each file, MOcov determines which of its lines can be executed. Each line that can be executed is prefixed by a call to `mocov_line_covered`, which cause it to update internal state to record the filename and line number that was executed, and the result stored in the temporary directory.
- The search path is updated to include the new temporary directory.

After evaluating the expression or function handle, the temporary directory is deleted and the search path restored. Line coverage information is then extracted from the internal state of `mocov_line_covered`.

This method runs on both GNU Octave and Matlab, but is typically slow.

### Coverage using the 'profile' method

-   It uses the Matlab profiler.
-   This method runs on Matlab only (not on GNU Octave), but is generally faster.

## Use cases

Typical use cases for MOcov are:

-   Locally run code with coverage for code in a unit test framework on GNU Octave or Matlab.
    Use

    ```matlab
    mocov(  '-cover','path/with/code', ...
            '-expression','run_test_command', ...
            '-cover_json_file','coverage.json', ...
            '-cover_xml_file','coverage.xml', ...
            '-cover_html_dir','coverage_html', ...
            '-method','file');
    ```

    to generate coverage reports for all files in the `'path/with/code'` directory
    when `running eval('run_test_command')`.
    Results are stored in JSON, XML and HTML formats.

-   As a specific example of the use case above,
    when using the [MOxUnit] unit test platform such tests can be run as

    ```matlab
    success = moxunit_runtests( 'path/with/tests', ...
                                '-with_coverage', ...
                                '-cover','/path/with/code', ...
                                '-cover_xml_file','coverage.xml', ...
                                '-cover_html_dir','coverage_html');
    ```

    where `'path/with/tests'` contains unit tests.
    In this case, `moxunit_runtests` will call the `mocov` function to generate coverage reports.

-   On the Matlab platform, results from `profile('info')`
    can be stored in JSON, XML or HTML formats directly.
    In the following:

    ```matlab
    % enable profiler
    profile on;

    % run code for which coverage is to be determined
    <your code here>

    % write coverage based on profile('info')
    mocov(  '-cover','path/with/code',...
            '-profile_info',...
            '-cover_json_file','coverage.json',...
            '-cover_xml_file','coverage.xml',...
            '-cover_html_dir','coverage_html');
    ```

    coverage results are stored in JSON, XML and HTML formats.

-   Use with continuous integration service,
    such as [Shippable] or [travis-ci] combined with [coveralls.io].
    See the [travis.yml configuration file] in the [MOxUnit] project for an example.

### Use with travis-ci and Shippable

MOcov can be used with the [Travis-ci] and [Shippable] services for continuous integration testing.
This is achieved by setting up a `travis.yml` file.
Due to recursiveness issues, MOcov cannot use these services to generate coverage reports for itself;
for an example in the related [MOxUnit] project,
see the [travis.yml configuration file] file.
