function tour2 = ApplyReversionBending(tour1, targetElements)

    tour2 = tour1;

    if numel(targetElements) >= 2
        I = sort(randsample(targetElements, 2));
        i1 = I(1);
        i2 = I(2);

        subSegment = tour1(i1:i2);
        tour2(i1:i2) = subSegment(end:-1:1);
    end

end