function test_suite=test_moxunit_util_mfile_subfunctions
    initTestSuite;

function s=rand_str()
    s=char(20*rand(1,10)+65);

function test_multiple_subfunctions
    % variable number of functions in body
    for count=0:5
        func_names=cell(1,count);
        lines=cell(count*2,1);

        for k=1:count
            func_name=rand_str();
            func_names{k}=func_name;

            lines{k*2-1}=[rand_str() rand_str()];
            lines{k*2}=sprintf('function %s',func_name);
        end

        helper_test_with_lines(func_names, lines);
    end

function test_commented_subfunction()
    helper_test_with_lines({},{',','% function foo',''});

function test_in_string_subfunction()
    helper_test_with_lines({},{'','''function foo''',''});

function test_no_whitespace_subfunction()
    helper_test_with_lines({},{'functionfoo'});

function test_newline_subfunction()
    helper_test_with_lines({'foo'},{sprintf('function ...\nfoo')});

function test_no_whitespace_newline_subfunction()
    helper_test_with_lines({},{sprintf('function...\nfoo')});

function test_tilde_newline_subfunction()
    helper_test_with_lines({'foo'},{sprintf('function ~=foo')});

function test_multiple_tilde_newline_subfunction()
    helper_test_with_lines({'foo'},{sprintf('function[~,~]=foo')});

function test_no_space_subfunction_long_vars
    helper_test_with_lines({'foo'},{sprintf('function aa=foo(bb, cc)')});

function test_no_space_subfunction_short_vars
    helper_test_with_lines({'foo'},{sprintf('function a=foo(b, c)')});

function test_different_args_subfunction
    % test with various types of whitespace, number of input arguments, and
    % number of output arguments
    whitespace_cell={' ',...
                     '  ',...
                     sprintf('\t'),...
                     sprintf(' ...\n'),...
                     sprintf(' ...\r\n')};
    for i_sp=1:numel(whitespace_cell)
        whitespace=whitespace_cell{i_sp};
        for n_out=-1:3
            arg_out=helper_build_arg_list(n_out,whitespace,'[',']','=');
            for n_in=-1:3
                arg_in=helper_build_arg_list(n_in,whitespace,'(',')','');
                func_name=rand_str();
                parts={'function',arg_out,func_name,arg_in};
                line=moxunit_util_strjoin(parts,whitespace);
                helper_test_with_lines({func_name},{line});
            end
        end
    end

function arg_list=helper_build_arg_list(n_args, whitespace, ...
                                left_paren, right_paren, suffix)
    if n_args<0
        arg_list='';
    else
        param_names=arrayfun(@(unused)rand_str,ones(1,n_args),...
                            'UniformOUtput',false);
        delim=[whitespace ',' whitespace];
        args=moxunit_util_strjoin(param_names,delim);
        arg_list_cell={left_paren,args,right_paren,suffix};
        arg_list=moxunit_util_strjoin(arg_list_cell, whitespace);
    end


function helper_test_with_lines(func_names, lines)
% func_names is expected cell output from
% moxunit_util_mfile_subfunctions
% when applied to a file containing the 'lines' data
    assert(iscell(func_names));
    assert(iscell(lines));

    tmp_fn=tempname();
    file_deleter=onCleanup(@()delete(tmp_fn));

    % try different line endings
    line_ending_cell={'\r\n',...  % MS Windows
                        '\n'};     % Unix-like / OSX

    header=['function ' rand_str];
    lines_with_header=[{header}; lines(:)];

    for k=1:numel(line_ending_cell)
        write_text_file(tmp_fn,lines_with_header,line_ending_cell{k});
        read_func_names=moxunit_util_mfile_subfunctions(tmp_fn);
        if isempty(func_names)
            assert(isempty(read_func_names))
        else
            assertEqual(func_names, read_func_names);
        end
    end


function fn=write_text_file(fn, lines, line_ending)
    fid=fopen(fn,'w');
    fprintf(fid,['%s' line_ending],lines{:});
    fclose(fid);
