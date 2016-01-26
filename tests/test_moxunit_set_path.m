function test_suite=test_moxunit_set_path
    initTestSuite;

function test_moxunit_set_path_root
    helper_test_with_subdir('');

function test_moxunit_set_path_util
    helper_test_with_subdir('util');

function helper_test_with_subdir(subdir)
    orig_path=path();
    path_resetter=onCleanup(@()path(orig_path));

    func=@moxunit_set_path;
    func_name=func2str(func);

    % remove from path
    root_dir=fileparts(which(func_name));
    relative_dir=fullfile(root_dir,subdir);
    rmpath(relative_dir);

    % should not be in path
    assert(~is_elem(path(),relative_dir,pathsep()));

    % must be now in path
    func();
    assert(is_elem(path(),relative_dir,pathsep()));



function tf=is_elem(haystack, needle, sep)
    tf=~isempty(findstr([sep haystack sep], [sep needle sep]));



