function [materials, mat_inf] = properties_Targetfrequency(nmat, directory, targetFrequency, nearFrq)
    materials = zeros(nmat*nearFrq, 3); % It will keep the properties of all the materials in the library at the nearest frequency to our target frequency
    mat_inf = zeros(nmat, 3); % It will keep the properties of all the materials at lowest frequency as their long term properties
    for i=1:nmat
        MasterCurveData=readmatrix([directory, 'material', num2str(i),'.txt'], 'NumHeaderLines', 1);
        [~, sortedIdx] = sort(abs(MasterCurveData(:,1) - targetFrequency));
        for j = 1:nearFrq
            materials(i + (j-1)*nmat, :) = MasterCurveData(sortedIdx(j), :);
        end

        % finding long term modulus
        [~, minIdx] = min(MasterCurveData(:,1));  % Find the index of the minimum frequency
        mat_inf(i,:) = MasterCurveData(minIdx, :);

    end
end