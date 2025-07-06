function [C, cutoff] = findDDVparameters(materials)
    cutoff = max(abs(materials(:,1))); % max freqeuncy of all materials used in the model
    C = sum(materials(:,2))/size(materials,1); % average storage of all materials used in the model
end