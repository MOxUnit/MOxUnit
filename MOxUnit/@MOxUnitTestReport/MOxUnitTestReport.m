function obj=MOxUnitTestReport(verbosity,stream)
% Initialize empty MOxUnitTestReport instance
%
% obj=MOxUnitTestReport([verbosity[,stream]])
%
% Inputs:
%   verbosity       Integer indicating how verbose the output is when
%                   tests are run using this instance (default: 1).
%   stream          File descriptor into which output results are written
%                   (default: 1, corresponding to standard output in the
%                   Command Window).
%
% Returns:
%   obj             Empty MOxUnitTestReport instance, with no test errors,
%                   failures, skips, or successes stored.
%
% See also: addError, addFailure, addSkip, addSuccess, report
%
% NNO 2015

    if nargin<1
        verbosity=1;
    end

    if nargin<2
        stream=1;
    end

    s=struct();
    s.verbosity=verbosity;
    s.stream=stream;
    s.errors=cell(0);
    s.failures=cell(0);
    s.skips=cell(0);
    s.successes=cell(0);
    s.testsRun=0;
    s.duration=0;
    obj=class(s,'MOxUnitTestReport');

