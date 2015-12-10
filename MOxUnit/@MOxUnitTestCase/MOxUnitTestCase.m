function obj=MOxUnitTestCase(name, location)
    s=struct();
    s.location=location;
    obj=class(s,'MOxUnitTestCase',MOxUnitTestNode(name));

