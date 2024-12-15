# Installation

## Installation using the shell

!!! warning -- "requirements"

    This requires a Unix-like operating system such as GNU/Linux or Apple OSX.

```bash
git clone https://github.com/MOxUnit/MOxUnit.git
cd MOxUnit
make install
```

This will add the MOxUnit directory to the Matlab and/or GNU Octave searchpath.
If both Matlab and GNU Octave are available on your machine, it will install MOxUnit for both.

## Manual installation

-   Download the [MOxUnit zip archive] from the MOxUnit repository, and extract it.
    This should result in a directory called ``MOxUnit-master``.

-   Start Matlab or GNU Octave.

-   On the Matlab or GNU Octave prompt, go to the directory that contains the new ``MOxUnit-master`` directory, then run:

    ```matlab
    % change to the MOxUnit subdirectory
    %
    % Note: if MOxUnit was retrieved using 'git', then the name of
    %       top-level directory is 'MOxUnit', not 'MOxUnit-master'
    cd MOxUnit-master/MOxUnit

    % add the current directory to the Matlab/GNU Octave path
    moxunit_set_path()

    % save the path
    savepath
    ```
