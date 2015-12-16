function test_suite=test_test_case
    initTestSuite;

function test_test_case_basics
    rand_str=@()char(20*rand(1,10)+65);

    name=rand_str();
    location=rand_str;
    case_=MOxUnitTestCase(name,location);

    assertEqual(location,getLocation(case_));
    assertEqual(name,getName(case_));

    assert(~isempty(strfind(str(case_),'MOxUnitTestCase')));
