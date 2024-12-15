# Installation

!!! warning -- "requirements"

    -   Working installation of [MOxUnit](../moxunit/installation.md).
    -   The `evalc` function.
        This functoon is generally available in Matlab, and in GNU Octave from version 4.2 onwards.
        Older versions of Octave without `evalc` can compile the `evalc.cc` file from in the "externals" directory.
        This can be done by running `make build-octave` from the shell,
        or in Octave by running `mkoctfile('evalc.cc')` in the `externals` directory
        and then adding that directory to the search path.
        The `evalc.cc` implementation is Copyright 2015 Oliver Heimlich, distributed under the GPL v3+ license.

## Installation using the shell

!!! warning -- "requirements"

    This requires a Unix-like operating system such as GNU/Linux or Apple OSX.

```bash
git clone https://github.com/MOdox/MOdox.git
cd MOdox
make install
```

This will add the MOdox directory to the Matlab and/or GNU Octave search path.
If both Matlab and GNU Octave are available on your machine, it will install MOdox for both.

## Manual installation

-   Download the zip archive from the [MOdox repository](https://github.com/MOdox/MOdox).

-   Start Matlab or GNU Octave.

-   On the Matlab or GNU Octave prompt, `cd` to the `MOdox` root directory, then run:

    ```matlab
    cd MOdox            % cd to MOdox subdirectory
    addpath(pwd)        % add the current directory to the Matlab/GNU Octave path
    savepath            % save the path
    ```
