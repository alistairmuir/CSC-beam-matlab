function V = func_integrate_Efield1D(Ez_filepath, freq, m_CST2SI)
% Function to retrieve the modal E-field along a beam path and 
% return the induced voltage on the beam.
%
% :param Efield_1D_filepath: Path to the file containing the E-field along the beamline.
% :type Ez_filepath: string
% :param freq: Frequency at which to measure induced voltage.
% :type freq: double
% :param m_CST2SI: Conversion factor for distance units in CST file.
% :type m_CST2SI: double

%%% Import physical constants
PhysicalConstants

%%% Retrieve E-field along beam path.
[z, E_z] = func_importCSTdata(Ez_filepath, m_CST2SI) ;

%%% Calculate E-field integrand for all positions.
dV_integrand = E_z.*exp(1i*2*pi*freq*z/c0) ;

%%% Integrate to retrieve beam voltage for this frequency.
V = trapz(z, dV_integrand) ;
        
end