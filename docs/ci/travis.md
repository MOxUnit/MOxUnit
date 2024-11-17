# Travis-CI

MOxUnit can be used with the [Travis-ci] service for continuous integration (CI) testing.
This is achieved by setting up a [.travis.yml configuration file](.travis.yml).
This file is also used by [Shippable].
As a result, the test suite is run automatically on both [Travis-ci] and [Shippable] every time it is pushed to the github repository, or when a pull request is made.
If a test fails, or if all tests pass after a test failed before, the developers are notified by email.

## Octave

The easiest test to set up on Travis and/or Shippable is with [GNU Octave].
Make sure your code is Octave compatible.
Note that many Matlab projects tend to use functionality not present in Octave (such as particular functions), whereasand writing code that is both Matlab- and Octave-compatible may require some additional efforts.

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

In this case `make test` is used to run the tests.
To avoid a Makefile and run tests directly through Octave, the script has to call Octave directly to run the tests:

  ```yaml
  # ...
  before_script:
  - git clone https://github.com/MOxUnit/MOxUnit.git

  script:
    - octave --no-gui --eval "addpath('~/git/MOxUnit/MOxUnit');moxunit_set_path;moxunit_runtests('tests')"
  ```

Note that MOxUnit tests **itself** on travis, with [this](https://github.com/MOxUnit/MOxUnit/blob/master/.travis.yml) travis file.

## Matlab

Travis [supports Matlab](https://docs.travis-ci.com/user/languages/matlab/) directly.
You can use MOxUnit with it, but its tricky because:

1.  Travis only supports Matlab 2020a and, presumably, higher (at the time of writing 2020a is the newest version).

1.  Makefile installation does not work with Matlab on travis.

1.  Nor does calling Matlab from the command line in a usual way - with ` matlab -nodesktop -nosplash ...` . Instead it has to be called with the `-batch` flag.
  
    Therefore, `.travis.yml` file looks as follows:

    ```yaml
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

<!--  -->

[Travis-ci]: https://travis-ci.org
[GNU Octave]: http://www.gnu.org/software/octave/
[Matlab]: http://www.mathworks.com/products/matlab/
[MOdox]: https://github.com/MOdox/MOdox
[MOxUnit]: https://github.com/MOxUnit/MOxUnit
[MOxUnit zip archive]: https://github.com/MOxUnit/MOxUnit/archive/master.zip
[MOcov]: https://github.com/MOcov/MOcov
[Shippable]: https://app.shippable.com/