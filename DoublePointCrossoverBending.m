function [y1, y2] = DoublePointCrossoverBending(x1, x2, targetElements)

    n = numel(targetElements);
    if n < 2
        y1 = x1;
        y2 = x2;
        return;
    end

    cc = randsample(n-1,2);
    c1 = min(cc);
    c2 = max(cc);

    idx = targetElements;

    y1 = x1;
    y2 = x2;

    y1(idx(c1+1:c2)) = x2(idx(c1+1:c2));
    y2(idx(c1+1:c2)) = x1(idx(c1+1:c2));
end