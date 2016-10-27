function test_suite=test_moxunit_util_input2str
    initTestSuite;


function test_moxunit_util_input2str_basics
    aeq=@(expected,varargin)assertEqual(sprintf(expected{:}),...
                        moxunit_util_input2str(varargin{:}));
    w=randstr();
    x=randstr();
    y=randstr();
    z=randstr();
    ys=moxunit_util_elem2str(y);
    zs=moxunit_util_elem2str(z);

    aeq({'%s\n%s\n',w,x},w,x);
    aeq({'%s\n%s\n\nInput: %s\n',w,x,ys},w,x,y);
    aeq({'%s\n%s\n\nFirst input: %s\n\nSecond input: %s\n',...
                                        w,x,ys,zs},w,x,y,z);


function s=randstr()
    s=char(rand(1,10)*24+65);


