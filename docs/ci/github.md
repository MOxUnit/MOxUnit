# Github-CI

You can test your code with Octave or Matlab on Github.

To use it, create a YML file in your `.github/workflows`
with the content described in one of the following sections.

!!! warning

    The example shown below is the one we use for own repository and may need some tweaking to work on yours.

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
--8<-- ".github/workflows/run_tests.m"
```

!!! warning

    You may need to use a slightly different run_test.m
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
