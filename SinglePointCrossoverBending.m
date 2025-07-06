function [y1, y2] = SinglePointCrossoverBending(x1, x2, targetElements)

    n = numel(targetElements);
    if n < 2
        y1 = x1;
        y2 = x2;
        return;
    end

    c = randi([1 n-1]);
    
    idx = targetElements;
    
    y1 = x1;
    y2 = x2;

    y1(idx(c+1:end)) = x2(idx(c+1:end));
    y2(idx(c+1:end)) = x1(idx(c+1:end));
end