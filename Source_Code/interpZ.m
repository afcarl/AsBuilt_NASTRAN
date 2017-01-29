function Z = interpZ(X,M,intMethod)
    % find new node z-coords with interpolated CMM data
    % INVARS:
    % X = row matrix with R^3 coords
    % M = row matrix with CMM R^3 coords
    % intMethod = interpolation method
    % OUTVARS:
    % Z = vector with updated Z-Coord for each FEM node 
    sI = scatteredInterpolant(M(:,1:2),M(:,3),intMethod);
    X(:,3) = sI(X(:,1),X(:,2));
    Z = X(:,3);
end

