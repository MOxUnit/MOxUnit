# Usage

## Writing documentation tests

Documentation tests can be defined in the help section of a Matlab / Octave .m file.
The help section of a function "foo" is the text shown when running "help foo".

Documentation tests must be placed in an example section starting with a header
that consists of exactly one of the strings (optionally surrounded by whitespace):

-   `Example`
-   `Examples`
-   `Example:`
-   `Examples:`

Subsequent lines, if indented (by being prefixed by more whitespace than the example header),
are used to construct documentation tests.

The examples section ends when the indentation is back to the original level.

Multiple test sections can be defined by separating them by whitespace.

Each tests contains one or more Matlab epxressions, and one or more lines containing expected output.
Expected output is prefixed by `%||`;
this ensures that documentation tests can be run by using copy-pasting code fragments.

If a potential test section does not have expected output, then it is ignored (and not used to construct a test).

In the following example, a file "foo.m" defines two documentation tests:

```matlab
function foo()
    % This function illustrates a documentation test defined for MOdox.
    % Other than that it does absolutely nothing
    %
    % Examples:
    %   a=2;
    %   disp(a)
    %   % Expected output is prefixed by '%||' as in the following line:
    %   %|| 2
    %   %
    %   % The test continues because no interruption through whitespace,
    %   % as the previous line used a '%' comment character;
    %   % thus the 'a' variable is still in the namespace and can be
    %   % accessed.
    %   b=3+a;
    %   disp(a+[3 4])
    %   %|| [5 6]
    %
    %   % A new test starts here because the previous line was white-space
    %   % only. Thus the 'a' and 'b' variables are not present here anymore.
    %   % The following expression raises an error because the 'b' variable
    %   % is not defined (and does not carry over from the previous test).
    %   % Because the expected output indicates an error as well,
    %   % the test passes
    %   disp(b)
    %   %|| error('Some error')
    %
    %   % A set of expressions is ignored if there is no expected output
    %   % (that is, no lines starting with '%||').
    %   % Thus, the following expression is not part of any test,
    %   % and therefore does not raise an error.
    %   error('this is never executed)
    %
    %
    % tests end here because test indentation has ended
```

## Running documentation tests

Tests can be run using the ``modox`` function.
For example, to run the documentation test defined above (in file foo.m):

```matlab
modox foo.m
```

The ``modox`` accepts as input arguments both single .m files and directories with m files.
If no .m files or directories are given, it runs tests on all .m files in the current directory.
