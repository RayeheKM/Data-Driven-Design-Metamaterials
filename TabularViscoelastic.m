function [ViscoelasticTable, Young]=TabularViscoelastic(freq, youngs_cplx, poisson, mat_inf)

    % Normalize modulus
    shear_cplx = youngs_cplx / (2 * (1 + poisson));
    bulk_cplx = youngs_cplx / (3 * (1 - 2 * poisson));
    
    shear_cplx_inf = complex(mat_inf(1,2),mat_inf(1,3)) / (2 * (1 + poisson));
    bulk_cplx_inf = complex(mat_inf(1,2),mat_inf(1,3)) / (3 * (1 - 2 * poisson));

    shear_inf = real(shear_cplx_inf);
    bulk_inf = real(bulk_cplx_inf);

    wgstar = complex(imag(shear_cplx) / shear_inf, 1 - real(shear_cplx) / shear_inf);
    wkstar = complex(imag(bulk_cplx) / bulk_inf, 1 - real(bulk_cplx) / bulk_inf);

    ViscoelasticTable=[real(wgstar), imag(wgstar), real(wkstar), imag(wkstar), freq];
  
    % get the Young's modulus at lowest frequency for long-term behavior
    Young = mat_inf(1,2);

end
