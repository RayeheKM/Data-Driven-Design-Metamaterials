function y = MutateBending(x, mu, allowedMaterials, targetElements)

    % Number of elements to mutate (from within targetElements only)
    nTarget = numel(targetElements);
    nmu = ceil(mu * nTarget);

    % Sample indices to mutate from targetElements only
    mutationTargets = randsample(targetElements, nmu);

    % Copy the original
    y = x;

    % Assign new materials randomly from allowedMaterials
    y(mutationTargets) = allowedMaterials(randi(length(allowedMaterials), [nmu, 1]));

end