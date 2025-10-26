# Github-CI

You can test your code with Octave or Matlab on Github.

To use it, create a YML file in your `.github/workflows`
with the content described in one of the following sections.

!!! warning

    The example shown below is the one we use for the MOxUnit repository
    and may need some tweaking to work on yours.

## Octave

### Using the moxunit Github action

There is a "preset" github action will test your code with Ubuntu and Octave.

<!-- see snippet injection
https://facelessuser.github.io/pymdown-extensions/extensions/snippets/#single-line-format
-->

```yaml
--8<-- ".github/workflows/CI_octave_action.yml"
```

### 'Manual' set up

If you do not use the [github action](#using-the-moxunit-github-action),
you have to install octave and all the relevant toolboxes.

<!-- see snippet injection
https://facelessuser.github.io/pymdown-extensions/extensions/snippets/#single-line-format
-->

```yaml
--8<-- ".github/workflows/CI_octave.yml"
```

## Matlab

You can test your code with Matlab with several operating systems and Matlab versions.

<!-- see snippet injection
https://facelessuser.github.io/pymdown-extensions/extensions/snippets/#single-line-format
-->

```yaml
--8<-- ".github/workflows/CI_matlab.yml"
```

Note that this wokflow calls the following script:

```matlab
--8<-- "run_tests_gh_ci.m"
```

!!! warning

    You may need to use a slightly different `run_tests_gh_ci.m`
    by updating the values for `path/to/src` and `path/to/tests`
    to make sure it points to where your source code and tests are.

    ```matlab
    cd('./MOxUnit/MOxUnit/');
    moxunit_set_path();
    cd ../..;

    addpath(fullfile(pwd, 'MOcov', 'MOcov'));

    moxunit_runtests path/to/tests -verbose -with_coverage -cover path/to/src -cover_xml_file coverage.xml;

    exit(double(~ans))
    ```

Alternatively, the commands can be part of a CI*.yaml file. For example, CoSMoMVPA
uses more or less the following configuration in `CI_matlab.yml` (for simplicity,
the documentation tests are left out):

```yaml
        steps:
        # use matlab-actions/setup-matlab to setup a specific version of MATLAB
        # https://github.com/matlab-actions/setup-matlab
        -   name: Install MATLAB
            uses: matlab-actions/setup-matlab@v2
            with:
                release: ${{ matrix.matlab_version }}

        -   name: Checkout repository
            uses: actions/checkout@v4

        -   name: Install CoSMoMVPA
            uses: matlab-actions/run-command@v2
            with:
                command: |
                    cd('mvpa')
                    cosmo_set_path()
                    savepath()

        -   name: Download MOxUnit, MOcov
            run: |
                git clone https://github.com/MOxUnit/MOxUnit.git --depth 1
                git clone https://github.com/MOcov/MOcov.git --depth 1

        -   name: Install MOxUnit, MOcov
            uses: matlab-actions/run-command@v2
            with:
                command: |
                    origin=pwd()
                    disp('Current working directory and contents:')
                    disp(origin)
                    dir
                    prefix=[origin '/']
                    cd([prefix 'MOxUnit/MOxUnit']); moxunit_set_path()
                    cd([prefix 'MOcov/MOcov']); addpath(pwd)
                    savepath()
                    disp('Path is now')
                    disp(path)

        -   name: Run unit tests (no documentation tests)
            uses: matlab-actions/run-command@v2
            with:
                command: |
                    result=moxunit_runtests('tests','-verbose', '-cover', 'mvpa', '-with_coverage', '-cover_xml_file', 'coverage.xml');
                    exit(~result);

        -   name: Code coverage
            uses: codecov/codecov-action@v5
            with:
                files: coverage.xml
                flags: ${{ matrix.os }}_matlab-${{ matrix.matlab_version }}
                name: codecov-matlab
                fail_ci_if_error: false
                token: ${{ secrets.CODECOV_TOKEN }}
```
