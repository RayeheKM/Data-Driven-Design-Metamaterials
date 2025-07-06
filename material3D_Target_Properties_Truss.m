function materials = material3D_Target_Properties_Truss(allMasterCurves, nmat, nearFrq, targetFrequency)
    for i=1:nmat
        MasterCurveData = allMasterCurves{i};
        [~, sortedIdx] = sort(abs(MasterCurveData(:,1) - targetFrequency));
        for j = 1:nearFrq
            materials(i + (j-1)*nmat, :) = MasterCurveData(sortedIdx(j), :);
        end
    end
end