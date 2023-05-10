function test_suite=test_general_almost_equal()
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions=localfunctions();
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;

function is_eq=wrap_moxunit_util_floats_almost_equal(a,b,tol_type,tol)
    [unused,id]=moxunit_util_floats_almost_equal(a,b,@abs,true,tol_type,tol);
    assert(ischar(id));
    is_eq=strcmp(id,'');


function is_eq=wrap_assertElementsAlmostEqual(a,b,tol_type,tol)
    try
        assertElementsAlmostEqual(a,b,tol_type,tol)
        is_eq=true;
    catch
        is_eq=false;
    end

function is_eq=wrap_moxunit_assertEqual(a,b,tol_type,tol)
    try
        % from MoxUnit
        assertEqual(a,b,tol_type,tol)
        is_eq=true;
    catch
        is_eq=false;
    end


function is_eq=wrap_matlab_assertEqual(a,b,tol_type,tol)
    import matlab.unittest.FunctionTestCase
    tc = FunctionTestCase.fromFunction(@(unused)0);

    f=@assertEqual;

    args={a,b,tol_type,tol};
    try
        f(tc,args{:})
        is_eq=true;
    catch
        is_eq=false;
    end


function test_moxunit_util_floats_almost_equal()
    helper(@wrap_moxunit_util_floats_almost_equal,...
                {'relative', 'absolute', 'AbsTol', 'RelTol'});


function test_assertElementsAlmostEqual()
    helper(@wrap_assertElementsAlmostEqual,...
                {'relative', 'absolute'});


function test_moxunit_assertEqual()
    helper(@wrap_assertElementsAlmostEqual,...
                {'AbsTol', 'RelTol'});


function test_matlab_assertEqual()
    s='matlab.unittest.FunctionTestCase';
    if isempty(which(s))
        msg=sprintf('Not supported: %s', s);
        moxunit_throw_test_skipped_exception(msg);
        return
    end
    helper(@wrap_matlab_assertEqual,...
                {'AbsTol', 'RelTol'});


function helper(eq_func, tol_names)
    n_tol_names = numel(tol_names);

    n = ceil(rand()*5+2);

    tiny=1e-5;
    while true
        xs = rand(n)-0.5;
        delta = rand(size(xs));
        if max(abs(xs))>tiny
            break;
        end
    end


    for k=1:n_tol_names
        tol_name = tol_names{k};

        for exceeds=[true,false]
            ys = xs + delta;

            switch tol_name
                case 'relative'
                    nominator = abs(xs(:)-ys(:));
                    denominator = max(abs(xs(:)),abs(ys(:)));
                    thr = max(bsxfun(@rdivide,nominator,denominator));

                case {'absolute','AbsTol'}
                    thr = max(abs(xs(:)-ys(:)));

                case 'RelTol'
                    nominator = abs(xs(:)-ys(:));
                    denominator = abs(ys(:));
                    thr = max(bsxfun(@rdivide,nominator,denominator));

                otherwise
                    error('this should not happen')
            end

            if exceeds
                tol = thr - tiny;
            else
                tol = thr + tiny;
            end

            args = {xs,ys,tol_name,tol};
            result = eq_func(args{:});

            expected = ~exceeds;
            if expected ~= result
                error('%s result is %d, expected %d for %s\n',...
                            func2str(eq_func),result,expected,tol_name);

            end
        end

    end
