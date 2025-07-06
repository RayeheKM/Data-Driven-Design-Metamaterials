function tour2=CreateNeighborBending(tour1, targetElements)
    tour2 = tour1;
    vals = tour1(targetElements);
    permutedVals = vals(randperm(length(vals)));
    tour2(targetElements) = permutedVals;
end