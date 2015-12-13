function test_suite=test_test_node
    initTestSuite;

function test_test_node_basics
    rand_str=@()char(20*rand(1,10)+65);

    name=rand_str();
    nd=MOxUnitTestNode(name);

    assertEqual(getName(nd),name);
    assertFalse(isempty(findstr(str(nd), 'MOxUnitTestNode')));

