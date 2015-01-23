function obj=addFromDirectory(obj,directory,pat)
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



