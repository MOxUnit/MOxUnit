# MOxUnit testing framework

MOxUnit is a lightweight testing framework for Matlab and GNU Octave,
that comes with optional toolboxes for coverage
and testing of 'doc strings'.

!!! note -- "Features"

    - Runs on both the [Matlab] and [GNU Octave] platforms.
    - Uses object-oriented TestCase, TestSuite and TestResult classes, allowing for user-defined extensions.
    - Can be used directly with continuous integration services, such as [GitHub](./ci/github.md), [Travis-ci](./ci/travis.md) and [Shippable].
    - Supports JUnit-like XML output for use with Shippable and other test results visualization approaches.
    - Supports the generation of code coverage reports using [MOCov]
    - Provides compatibility with the (now unsupported) Steve Eddin's [Matlab xUnit test framework], and with recent Matlab test functionality.
    - Distributed under the MIT license, a permissive free software license.

!!! warning -- "Limitations"

    Currently MOxUnit does not support:

    - Documentation tests require [MOdox].
    - Support for setup and teardown functions in `TestCase` classes.
    - Subclasses of MOxUnit's classes (`MOxUnitTestCase`, `MOxUnitTestSuite`, `MOxUnitTestReport`) have to be defined using "old-style" object-oriented syntax.
    - Subtests

<!--  -->

[GNU Octave]: http://www.gnu.org/software/octave/
[Matlab]: http://www.mathworks.com/products/matlab/
[MOdox]: https://github.com/MOdox/MOdox
[MOxUnit]: https://github.com/MOxUnit/MOxUnit
[MOxUnit zip archive]: https://github.com/MOxUnit/MOxUnit/archive/master.zip
[MOcov]: https://github.com/MOcov/MOcov
[Shippable]: https://app.shippable.com/
