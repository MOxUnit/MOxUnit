function test_suite=test_test_suite
    initTestSuite;
    
function test_test_suite_default_name()
    suite=MOxUnitTestSuite();
    assertEqual('MOxUnitTestSuite',getName(suite));
    
function test_test_suite_name()
    name=rand_str();
    suite=MOxUnitTestSuite(name);
    
    assertEqual(name,getName(suite));
    
function test_test_suite_tests()
    suite=MOxUnitTestSuite();
    
    assertEqual(0,countTestNodes(suite));
    
    n_nodes=ceil(rand()*5+5);
    for k=1:n_nodes
        nd=MOxUnitTestNode(rand_str());
        
        suite=addTest(suite,nd);
        assertEqual(k,countTestNodes(suite))
        nd_again=getTestNode(suite,k);
        assertEqual(nd,nd_again);
    end
    
    s_double=addFromSuite(suite,suite);
    assertEqual(2*n_nodes,countTestNodes(s_double));
    
    
function s=rand_str()
    s=char(20*rand(1,10)+65);    
    