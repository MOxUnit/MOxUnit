function test_suite=test_moxunit_util_elem2str
    initTestSuite;

function test_moxunit_util_elem2str_tiny
    aeq=@assert_expected_output;
    % empty string
    aeq('''''','');

    % string in row vector form
    aeq('''abc''','abc');

    % matrix
    aeq('[4 3 2;3 4 1]',[4 3 2; 3 4 1]);
    x=randn(2);
    aeq(mat2str(x),x);

function test_moxunit_util_elem2str_big_matrix
    aeq=@assert_expected_output;
    aeq(sprintf(['[0.99999999 -1e-08 -1e-08 -1e-08;-1e-08 0.99999999\n'...
                 '...\n'...
                 '0.99999999 -1e-08;-1e-08 -1e-08 -1e-08 0.99999999]']),...
                 eye(4)-1e-8);

function test_moxunit_util_elem2str_big_cell
    aeq=@assert_expected_output;

    aeq('100x2(cell)',cell(100,2))

function test_moxunit_util_elem2str_tiny_with_evalc
    aeq=@assert_expected_output_evalc_if_present;

    % string with non-row vector form
    aeq(sprintf('abc\ndef'),...
            '2x3(char)',...
            ['abc';'def']);

    % 3D string array
    aeq(sprintf('\n(:,:,1) =\n\nabc\ncde\n\n(:,:,2) =\n\nefg\nghi'),...
                '2x3x2(char)',...
                cat(3,['abc';'cde'],['efg';'ghi']))

    % logical array
    aeq('     0     1','1x2(logical)',[false true]);

    % cell array
    aeq('    ''foo''    [1]','1x2(cell)',{'foo',1});


function test_moxunit_util_elem2str_custom_class
% Make a temporary class with a size function that throws an error;
% This tests the functionality of util_elem2str for the case that not
% even a class' 'size' function is available
    tmpdir=tempname(tempdir);
    cleaner=onCleanup(@()remove_path_directory(tmpdir));

    classname=sprintf('my_class');
    classdir=fullfile(tmpdir,sprintf('@%s',classname));

    if ~exist(tmpdir,'dir')
        % GNU Octave returns a temporary directory that does not exist;
        % so create it first
        mkdir(tmpdir);
    end

    % make subdirectory for the class
    mkdir(classdir);

    write_contents(classdir,classname,...
                    ['function obj=%s()\n'...
                            'obj=class(struct(),''%s'');'],...
                            classname,classname);
    write_contents(classdir,'size',...
                    ['function size(obj)\n'...
                            'error(''raises error'');']);
    addpath(tmpdir);
    constructor=str2func(classname);

    % make object instance
    obj=constructor();

    aeq=@assert_expected_output;
    aeq(sprintf('(%s)',classname),obj);

function write_contents(dirname,fname,pat,varargin)
% helper function to write .m file
    fn=fullfile(dirname,sprintf('%s.m',fname));

    fid=fopen(fn,'w');
    cleaner=onCleanup(@()fclose(fid));
    fprintf(fid,pat,varargin{:});


function remove_path_directory(dir_name)
    % removes dir_name from the search path and from the file system

    rmpath(dir_name);
    if moxunit_util_platform_is_octave()
        % GNU Octave requires, by defaualt, confirmation when using rmdir.
        % The state of confirm_recursive_rmdir is stored, and set back
        % to its original value when leaving this function.
        confirm_val=confirm_recursive_rmdir(false);
        cleaner=onCleanup(@()confirm_recursive_rmdir(confirm_val));
    end

    rmdir(dir_name,'s');


function assert_expected_output_evalc_if_present(a,b,varargin)
    result=moxunit_util_elem2str(varargin{:});

    if exist('evalc','builtin')
        assertEqual(result,a);
    else
        assertEqual(result,b);
    end


function assert_expected_output(to_compare,varargin)
    result=moxunit_util_elem2str(varargin{:});

    assertEqual(result,to_compare);

