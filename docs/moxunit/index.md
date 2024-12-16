# MOxUnit

MOxUnit is a lightweight testing framework for Matlab and GNU Octave.

!!! note -- "Features"

    - Runs on both the [Matlab] and [GNU Octave] platforms.
    - Can be used directly with continuous integration services, such as [GitHub](../ci/github.md), [Travis-ci](../ci/travis.md) and [Shippable].
    - Uses object-oriented TestCase, TestSuite and TestResult classes, allowing for user-defined extensions.
    - Supports JUnit-like XML output for use with Shippable and other test results visualization approaches.
    - Supports the generation of code coverage reports using [MOCov](../mocov/index.md).
    - Supports documentation tests using [MOdox](../modox/index.md).
    - Provides compatibility with the (now unsupported) Steve Eddin's [Matlab xUnit test framework], and with recent Matlab test functionality.

!!! warning -- "Limitations"

    Currently MOxUnit does not support:

    - Support for setup and teardown functions in `TestCase` classes.
    - Subclasses of MOxUnit's classes (`MOxUnitTestCase`, `MOxUnitTestSuite`, `MOxUnitTestReport`) have to be defined using "old-style" object-oriented syntax.
    - Subtests
