for i = 1:length(files)
  Pr_comparison(1,i) = mu_water(T_c(i))*cp_water(T_c(i))/k_water(T_c(i));
  f_sc_comparison(1,i) = f_D(0,Re_c(1,i))/4;
  Nu_sc_comparison(1,i) = (f_sc_comparison(1,i)/8).*(Re_c(1,i) - 1000)*Pr_comparison(1,i)./(1 + 12.7*sqrt(f_sc_comparison(1,i)/8)*(Pr_comparison(1,i)^(2/3) - 1));
  j_sc_comparison(1,i) = Nu_sc_comparison(1,i)./(Re_c(1,i)*Pr_comparison(1,i)^(1/3));
  h_sc_comparison(1,i) = Nu_sc_comparison(1,i)*k_water(T_c(1,i))/d_h;
endfor

figure
scatter(Re_c(1,:),h_sc_comparison)
hold



scatter(Re_c(1,:),h_c)

figure
scatter(Re_c(1,:),Nu_sc_comparison)
hold
scatter(Re_c(1,:),Nu_c)