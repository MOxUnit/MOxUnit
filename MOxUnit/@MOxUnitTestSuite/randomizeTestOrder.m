function obj = randomizeTestOrder(obj)
    % Randomize the order of the tests
    %
    % obj=randomizeTestOrder(obj)
    %
    % Inputs:
    %   obj             MoxUnitTestSuite instance
    %
    % Output:
    %   obj             MoxUnitTestSuite instance with the tests in random
    %                   order.
    %
    % NNO 2023

    n = countTestNodes(obj);

    rnd_tests = cell(n, 1);
    [unused, idxs] = sort(rand(n, 1));

    for k = 1:n
        nd = getTestNode(obj, k);

        if isa(nd, '@MOxUnitTestSuite')
            % recursive call
            nd = randomizeTestOrder(nd);
        end

        rnd_tests{idxs(k)} = nd;
    end

    for k = 1:n
        obj = setTestNode(obj, k, rnd_tests{k});
    end
