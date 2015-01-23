function obj=MOxUnitFunctionHandleTestCase(name,location,function_handle)
    s=struct();
    s.name=name;
    s.location=location;
    s.function_handle=function_handle;

    obj=class(s,'MOxUnitFunctionHandleTestCase',MOxUnitTestCase);


