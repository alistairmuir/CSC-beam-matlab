function fco = func_ScrapeCutOffFreqs(felis_results_dir, nTE1, nTM1, nTE2, nTM2)
% A function that outputs all the cut-off frequencies as stored in a set of FELIS results files.
%
% :param felis_results_dir: String of directory containing FELIS results for one simulation.
% :type  felis_results_dir: string
% :param nTE1: Number of TE modes at port 1.
% :type  nTE1: integer
% :param nTE2: Number of TE modes at port 2.
% :type  nTE2: integer
% :param nTM1: Number of TM modes at port 1.
% :type  nTM1: integer
% :param nTM2: Number of TM modes at port 2.
% :type  nTM2: integer
%
% :returns: fco struct with fields fco.TE1, fco.TM1, fco.TE2, fco.TM2

    % Initialize output structure
    fco = struct('TE1', [], 'TM1', [], 'TE2', [], 'TM2', []) ;

    % Helper function to read first numeric value in a file
    function val = read_cutoff(fname)
        fid = fopen(fname, 'r') ;
        if fid == -1
            val = NaN;
            warning('Could not open file: %s', fname) ;
        else
            val = fscanf(fid, '%f', 1) ;  % read the first numeric value
            fclose(fid) ;
        end
    end

    % --- Port 1 TE modes ---
    for m = 1:nTE1
        filename = fullfile(felis_results_dir, sprintf('P1_TE%d.txt', m)) ;
        fco.TE1(m) = read_cutoff(filename) ;
    end

    % --- Port 1 TM modes ---
    for m = 1:nTM1
        filename = fullfile(felis_results_dir, sprintf('P1_TM%d.txt', m)) ;
        fco.TM1(m) = read_cutoff(filename) ;
    end

    % --- Port 2 TE modes ---
    for m = 1:nTE2
        filename = fullfile(felis_results_dir, sprintf('P2_TE%d.txt', m)) ;
        fco.TE2(m) = read_cutoff(filename) ;
    end

    % --- Port 2 TM modes ---
    for m = 1:nTM2
        filename = fullfile(felis_results_dir, sprintf('P2_TM%d.txt', m)) ;
        fco.TM2(m) = read_cutoff(filename) ;
    end
end
