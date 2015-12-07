function moxunit_set_path()
% sets the search path for MOxUnit
%
% moxunit_set_path()
%
% This adds the current directory and the 'util' test directory to the
% search path

    root_dir=fileparts(which(mfilename()));

    sub_dirs={'','util'};

    full_dirs=cellfun(@(sd)fullfile(root_dir,sd),sub_dirs,...
                        'UniformOutput',false);
    addpath(strjoin(full_dirs,pathsep()));

