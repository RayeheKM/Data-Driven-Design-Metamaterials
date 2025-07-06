function [selectedMaterial, materialNumber] = DecideMaterial(nmat, nearFrq)
    selectedMaterial = randi([1 nmat*nearFrq]);
    % Determine the original material number between 1 and nmat
    materialNumber = mod(selectedMaterial, nmat);
    if materialNumber == 0
        materialNumber = nmat;
    end
end