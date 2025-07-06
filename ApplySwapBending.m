function tour2 = ApplySwapBending(tour1, targetElements)

    tour2 = tour1;

    if numel(targetElements) >= 2
        I = randsample(targetElements, 2);
        i1 = I(1);
        i2 = I(2);

        tour2([i1 i2]) = tour1([i2 i1]);
    end

end