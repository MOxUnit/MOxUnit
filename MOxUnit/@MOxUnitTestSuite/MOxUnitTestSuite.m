function obj=MOxUnitTestSuite()
    s=struct();
    s.tests=cell(0);
    obj=class(s,'MOxUnitTestSuite',MOxUnitTestNode());


