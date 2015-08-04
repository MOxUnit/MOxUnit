function obj=addFromDirectory(obj,directory,pat)
% Add unit tests from directory
%
% obj=addFromFile(obj,directory[,pat])
%
% Inputs:
%   obj             MoxUnitTestSuite instance.
%   directory       name of directory that may contain files with top-level
%                   function that returns MOxUnitTestNode instances.
%   pat             File pattern to look for in directory (default: '*.m').
%                   Matching files are added using addFromFile.
%
% Output:
%   obj             MoxUnitTestSuite instance with MOxUnitTestNode
%                   instances  added, if present in the files in directory.
%
% Notes:
%   - this function does not add files recursively.
%
% See also: initTestSuite, addFromFile
%
% NNO 2015
    if nargin<3
        pat='*.m';
    end

    if isdir(directory)
        d=dir(fullfile(directory(),pat));
        n=numel(d);

        for k=1:n
            fn=d(k).name;
            path_fn=fullfile(directory,fn);

            if ~isdir(path_fn)
                obj=addFromFile(obj,path_fn);
            end
        end
    else
        error('moxunit:illegalParameter','Input is not a directory');
    end



