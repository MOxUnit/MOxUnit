function moxunit_set_path()
% sets the search path for MOxUnit
%
% moxunit_set_path()
%
% This adds the current directory and the 'util' test directory to the
% search path

    root_dir=fileparts(mfilename('fullpath'));

    sub_dirs={'','util'};

    % Cannot use moxunit_util_strjoin because it may not be in the path.
    % Instead construct the path to be added by adding the pathsep() after
    % each subdirectory
    make_full_path_with_sep=@(sub_dir)[fullfile(root_dir,sub_dir) ...
                                        pathsep()];

    full_dirs=cellfun(make_full_path_with_sep,sub_dirs,...
                        'UniformOutput',false);

    addpath(cat(2,full_dirs{:}));

