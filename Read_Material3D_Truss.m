function [allMasterCurves, mat_inf] = Read_Material3D_Truss(nmat, directory)
    
    mat_inf = zeros(nmat, 3); % It will keep the properties of all the materials at lowest frequency as their long term properties
    allMasterCurves = cell(nmat, 1); % Cell array to store all master curves
    for i=1:nmat
        MasterCurveData=readmatrix([directory, 'materials/Material', num2str(i),'.txt'], 'NumHeaderLines', 1);
        MasterCurveData = sortrows(MasterCurveData, 1);
        allMasterCurves{i} = MasterCurveData;% Save the master curve data in the cell array
        mat_inf(i,:) = MasterCurveData(1, :);

    end
end