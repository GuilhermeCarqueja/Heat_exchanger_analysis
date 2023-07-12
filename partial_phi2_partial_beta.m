function partial_phi2_partial_beta = partial_phi2_partial_beta(q_bar,q_T,alpha_0,beta_0,Biot_c,Biot_h)
  
  for i = 1:length(Biot_c)
    for j = 1:length(Biot_h)
      M(i,j) = (partial_f_partial_beta(alpha_0,beta_0,Biot_c(i),Biot_h(j)))^2 - ((q_bar(i,j)/q_T) - f_lsq(alpha_0,beta_0,Biot_c(i),Biot_h(j)))*(-2*Biot_h(j)*((sech(beta_0*Biot_h(j)^0.5))^2)*f_lsq(alpha_0,beta_0,Biot_c(i),Biot_h(j)));
    endfor
  endfor
  
  partial_phi2_partial_beta = 2*sum(sum(M));
endfunction
