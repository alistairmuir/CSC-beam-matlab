# CSC-beam-matlab
A test-bed implementation of CSC-beam using Matlab and CST Suite results files.

Introduction
====

This repository contains three main scripts:

   - ``GeneralizedMatrix_Script.m``
   - ``Scsc_Script.m`` 
   - ``OrthogonalMatrices_Script.m``

Two plotting scripts are also present, but are not integral to the workflow.
Please note the three dependent subdirectories:
   - **Functions**: all proprietary functions are stored this folder.
   - **Configs**: all configuration files are stored in this folder.
   - **Plotting Scripts**: all plotting called by the main scripts are stored in this
     folder, along with other scripts which can be used to analyse results manually.

The three main scripts are described below.

``GeneralizedMatrix_Script.m``
----
This script generates the generalized S-parameter matrices from CST results
files specified by the user in the configuration file, ``Config_GeneralizedMatrix.m``.

The script has the following sections, which call the given functions:

   - *Add dependent paths*:\
         The directories containing required functions, configuration files
         and subscripts are all added to the working directory.
   - *Run configuration script*:\
         Run the configuration script that contains all user-specified variables.
      - ``Config_GeneralizedMatrix``
   - *Import physical constants*:\
         Physical constants needed for calculations are loaded from a library function.
      - ``func_EM_PhysicalConstants``
   - *CST export directories*:\
         Directories for all needed CST files are constructed.
   - *Convert to SI units*:\
         Frequencies and lengths given in CST units are converted to SI units.
   - *Initialize all matrices*:\
         All matrices to be populated later are initialized.
   - *Load direct wake impedance and corresponding frequency samples*:\
       Load results from time-domain (TD) CST simulation.
      - ``func_Import_CSTdata``
   - *Populate S-parameter matrix*:\
         Loops through all modes from both ports, and populates a complete
         S-parameter matrix from the frequency-domain (FD) CST simulation results.
      - ``func_Import_CSTdata``
   - *Calculate beam voltages for all modes*:\
         Retrieves the Ez field for each mode and calculate the induced voltage.
      - ``func_CalcVoltage_Ez_CSTdata``
      - ``func_Import_CSTdata`` (called in ``func_CalcVoltage_Ez_CSTdata``)
   - *Fourier transforms*:\
         Carries out fourier transform on all TD data.
      - ``func_Import_CSTdata``
      - ``func_FFT_CSTdata``
   - *Interpolations*:\
         Interpolates all results to user-specified frequency values, ensuring each
         'leaf' of a generalized matrix represents the same frequency.
      - ``func_Interpolate_CSTdata``
   - *Calculate k and h*:\
         Beam coupling parameters are calculated using the respective functions.
      - ``func_CalcBeamCoupling_k``
      - ``func_CalcBeamCoupling_h``
   - *Construct generalized S-matrix for all frequencies*:\
         The final generalized matrix is constructed from all the interpolated data.
      - ``func_ConstructGeneralizedMatrix``
   - *Save the matrix and corresponding frequencies*:\
       Save the generalized matrix for the entire structure.
      - ``func_SaveGM``
   - *Plot*:\
       Runs a script which plots the whole matrix when only 1 or 2 modes are included,
       and only plots the direct impedance for larger matrices.
      - ``Plot_GeneralizedMatrix``

``Scsc_Script.m``
----
This script carries out CSC-beam on the generalized S-parameter
matrices of several segments, outputting the generalized S-parameter matrix
for the entire beam path represented by the input matrices.

The script has the following sections:

   - *Add dependent paths*:\
        The directories containing required functions, configuration files
        and subscripts are all added to the working directory.
   - *Run configuration script*:\
        Run the configuration script that contains all user-specified variables.
      - ``Config_Scsc_Pillbox`` (the use may wish to change to a different config
        file, but must ensure the file defines all the necessary variables).
   - *Carry out CSC-beam*:\
        The new GM is calculated from the given sequence of GMs.
      - ``func_CalcScsc``
      - ``func_EM_PhysicalConstants`` (called in ``func_CalcScsc``)
      - ``func_CalcPhase`` (called in ``func_CalcScsc``)
   - *Save new GM*:\
       Save the generalized matrix for the entire structure.
      - ``func_SaveGM``
   - *Plot*:\
        Runs a script which plots the whole matrix when only 1 or 2 modes are included,
        and only plots the direct impedance for larger matrices.
      - ``Plot_GeneralizedMatrix``

``OrthogonalMatrices_Script.m``
----
This script generates the orthogonal matrices from the parameters specified in a
configuration file (namely, the number of segments, the number of internal and
external port modes, and the save directory).

The script has the following sections:

   - *Add dependent paths*:\
        Adds the configuration file folder to the working path.
   - *Load config file*:\
        Loads the configuration file which specifies the number of internal and
        external modes, and the number sections.
   - *Call Function*:\
          Returns the orthogonal matrices P and F. 
        - ``func_OrthoMatrices``
   - *Save P and F matrices*:\
        The matrices are saved in the directory set in the config file.
        
