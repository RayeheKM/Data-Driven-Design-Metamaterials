function [Distance] = distance(eps,sig, Omega, G, omega, C, cutoff)
    %To compute the Flat norm between the measure (eps,sig) with support at Omega and the subspace
    %(eps, G*eps) with support in omega
    
    % inputs eps and sig are the voigt notation of shear strain and stress tensors
    
    den = C^2 + G*G;
    
    eps_parallel = ((C^2)*eps + G*sig)/den; sig_parallel = G*eps_parallel;
    
    eps_normal = G*(G*eps-sig)/den; sig_normal= (C^2)*(sig-G*eps)/den;
    
    alpha = abs(Omega-omega)/cutoff;
    
    if (alpha > 2)
        alpha = 2.;
    end
    
    norm_total = norm_state(eps,sig,C);
    norm_parallel = norm_state(eps_parallel, sig_parallel, C);
    norm_normal = norm_state(eps_normal, sig_normal, C);
    
    mu = 1 -(alpha/(sqrt(1-alpha^2)))*norm_normal/norm_parallel;
    
    if (alpha > norm_parallel/norm_total || norm_total == 0)
        Distance = norm_total;
    else
       eps_weighted = (mu - 1)*eps_parallel - eps_normal;
       sig_weighted = (mu - 1)*sig_parallel - sig_normal;
       Distance = norm_state(eps_weighted, sig_weighted, C) + alpha*mu*norm_parallel;
    end

end

