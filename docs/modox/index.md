# Modox

MOdox is documentation test ("doctest") framework for Matlab and GNU Octave.

!!! note -- "Features"

    - Runs on both the [Matlab] and [GNU Octave] platforms.
    - Can be used directly with continuous integration services, such as [coveralls.io] and [Shippable].
    - Extends [MOxUnit], a unit test framework for Matlab and GNU Octave.
    - Is distributed under the MIT license, a permissive free software license.






### Use with travis-ci and Shippable
MOdox can be used with the [Travis-ci] and [Shippable] services for continuous integration testing. This is achieved by setting up a `travis.yml` file. For an example in the related [MOxUnit] project, see the [MOxUnit travis.yml] file.


### Compatibility notes
- Because GNU Octave 3.8 and 4.0 do not support `classdef` syntax, 'old-style' object-oriented syntax is used for the class definitions.

### Limitations
- Expressions with the "for" keyword are not supported in Octave because ``evalc`` does not seem to support it
- It is possible to indicate that an expression throws an exception, but not *which* exception.
