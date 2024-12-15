# MOcov

MOcov is a coverage report generator for Matlab and GNU-Octave.

!!! note -- "Features"

    -   Runs on both the [Matlab] and [GNU Octave] platforms.
    -   Can be used directly with continuous integration services, such as [coveralls.io] and [Shippable].
    -   Integrates with [MOxUnit](../index.md), a unit test framework for Matlab and GNU Octave.
    -   Supports the Matlab profiler.
    -   Writes coverage reports in HTML, JSON and XML formats.
    -   Distributed under the MIT license, a permissive free software license.

!!! note -- "Compatibility notes"

    -   Because GNU Octave 3.8 and 4.0 do not support `classdef` syntax,
        'old-style' object-oriented syntax is used for the class definitions.

!!! warning -- "Limitations"

    -   The ['file' coverage method](./usage.md#coverage-by-the-file-method-default) uses a very simple parser, which may not work as expected in all cases.
    -   Currently there is only support to generate coverage reports for files in a single directory (and its subdirectory).
