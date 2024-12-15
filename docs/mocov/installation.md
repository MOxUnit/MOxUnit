# Installation

!!! warning -- "requirements"

    -   Working installation of [MOxUnit](../moxunit/installation.md).

## Installation using the shell

!!! warning -- "requirements"

    This requires a Unix-like operating system such as GNU/Linux or Apple OSX.

```bash
git clone https://github.com/MOcov/MOcov.git
cd MOcov
make install
```

This will add the MOcov directory to the Matlab and/or GNU Octave search path.
If both Matlab and GNU Octave are available on your machine, it will install MOcov for both.

## Manual installation

-   Download the zip archive from the [MOcov] repository.
-   Start Matlab or GNU Octave.
-   On the Matlab or GNU Octave prompt, `cd` to the `MOcov` root directory, then run:

    ```matlab
    cd MOcov            % cd to MOcov subdirectory
    addpath(pwd)        % add the current directory to the Matlab/GNU Octave path
    savepath            % save the path
    ```
