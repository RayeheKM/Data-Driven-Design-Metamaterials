function [AmpZ] = norm_state(eps,sig, C)
%The norm of a state Z=(E,S) in C^d * C^d space
A = norm(eps)^2; B = norm(sig)^2;
AmpZ = sqrt(C*A + B/C);
end

