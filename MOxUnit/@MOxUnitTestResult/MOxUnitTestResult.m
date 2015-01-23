function c=MOxUnitTestResult(verbosity,stream)
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
    c=class(s,'MOxUnitTestResult');

