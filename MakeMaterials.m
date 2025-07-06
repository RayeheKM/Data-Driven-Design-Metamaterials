function MakeMaterials(nmat, directory)
    
    % Import the data from the Excel file
    [data, ~, ~] = xlsread('C:\Users\BrinsonLab\Desktop\DigitalMetamaterial\Codes\PETMP-TATATO OLD wide bar.xls', 3);
    CurveData = data(:,[14,7,8, 3]); % mastercurve at 29-30 C
    
    T = [30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90];
    T = T + 273.15;  % Convert to Kelvin
    a_T = [1.00E+00, 3.07E-01, 1.85E-02, 6.59E-04, 3.00E-05, 1.96E-06, 1.95E-07, 3.10E-08, 6.93E-09, 1.96E-09, 6.60E-10, 2.52E-10, 1.15E-10];
    
    shiftFactors = interp1(T, a_T, (CurveData(:,4)+273.15), 'pchip', 'extrap');
    MasterCurveData = CurveData(:,1:3);
    freq = MasterCurveData(:,1);
    freq = log10(freq) + log10(shiftFactors);
    freq = 10.^freq;
    MasterCurveData(:,1) = freq;
    % Sort the MasterCurveData based on the first column (frequency)
    MasterCurveData = sortrows(MasterCurveData, 1);

    %changing the frequency range for the master curve
    freq = log10(MasterCurveData(:,1)) + log10(10^8);
    freq = 10.^freq;
    MasterCurveData(:,1) = freq;

    figure
    hold on
    % Set colors for multiple materials
    colors = lines(nmat); % MATLAB's built-in color palette
    for i = 1:nmat
        % write into a file
        fileID = fopen([directory, 'material', num2str(i),'.txt'], 'w');
        fprintf(fileID, 'Frequency (Hz)\tStorage (Pa)\tLoss (Pa)\n');
        
        % Create new data by applying different transformations
        data = MasterCurveData;
        
        % Randomly choose a transformation
        transformation = randi(4);
        switch transformation
            case 1
                % Mirror properties with respect to frequency within the same range
                data(:,2:3) = flipud(data(:,2:3));
            case 2
                % Scale properties
                scaleFactor = rand() * 2; % Random scale factor between 0 and 2
                data(:,2:3) = data(:,2:3) * scaleFactor;
            case 3
                % Shift frequency in log scale within the same range
                freqShift = rand()*0.5 - 0.25; % Smaller shift factor to keep within range
                data(:,1) = 10.^(log10(data(:,1)) + freqShift);
            case 4
                % Combination of mirroring, scaling, and shifting within the same range
                data(:,2:3) = flipud(data(:,2:3));
                scaleFactor = rand() * 2; % Random scale factor between 0 and 2
                data(:,2:3) = data(:,2:3) * scaleFactor;
                freqShift = rand()*0.5 - 0.25; % Smaller shift factor to keep within range
                data(:,1) = 10.^(log10(data(:,1)) + freqShift);
        end
        
        fprintf(fileID, '%.6g\t%.6g\t%.6g\n', data.');  % .' is used for non-conjugate transpose which is the same as ' when we have real numbers
        fclose(fileID);
        
        loglog(data(:, 1), data(:, 2), '-', 'Color', colors(i, :), ...
            'LineWidth', 1.5, 'MarkerSize', 8, 'DisplayName', ['E'' ', num2str(i)]);
        loglog(data(:, 1), data(:, 3), '--', 'Color', colors(i, :), ...
            'LineWidth', 1.5, 'MarkerSize', 8, 'DisplayName', ['E" ', num2str(i)]);
    end
    set(gca, 'XScale', 'log', 'YScale', 'log');
    xlabel('Frequency (Hz)', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Modulus (Pa)', 'FontSize', 12, 'FontWeight', 'bold');
    legend('show', 'Location', 'northeastoutside', 'Orientation', 'horizontal', 'NumColumns', 4, 'FontSize', 8);
    grid on;
    grid minor;
    box on
end
