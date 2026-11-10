# OpenMP and MPI in VS Code

A Windows x64 practice workspace for single-file C or C++ exercises. The same shortcut builds and runs the active file.

## Install once

1. Install [VS Code](https://code.visualstudio.com/) and its Microsoft C/C++ extension. VS Code recommends the extension when you open this folder.
2. Install [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio) with **Desktop development with C++**, including the x64 MSVC tools and a Windows SDK. An existing Visual Studio installation with that workload also works.
3. For MPI, download and run both installers from [Microsoft MPI](https://www.microsoft.com/en-us/download/details.aspx?id=105289). Install `msmpisetup.exe` for the runtime and `msmpisdk.msi` for the SDK. OpenMP support comes with the C++ compiler.

## Clone and run

1. In VS Code, press **Ctrl+Shift+P**, choose **Git: Clone**, and paste `https://github.com/thillainirmal-tech/openmp-mpi.git`. Open the cloned folder.
2. Open `OpenMP/omp_hello.c` or `MPI/mpi-demo.c`. Save any edits.
3. Press **Ctrl+Shift+B** to compile and run. Read the output in the terminal.

For new exercises, save each source file directly in `OpenMP/` or `MPI/`. Use `MPI/process-count.txt` to change the number of MPI processes, then switch back to the source file before running. The MPI demo expects four processes and prints a sum of 40. The OpenMP demo prints four thread IDs.

If you already have a local copy of the Microsoft MPI SDK, you can place its `Include` and `Lib` folders inside `.vscode/mpi-sdk/`. The runner checks that location before the normal installation path. The SDK and generated programs are ignored by Git.
