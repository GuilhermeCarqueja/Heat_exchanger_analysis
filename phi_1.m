function phi_1 = phi_1(q_bar,q_T,alpha_0,beta_0,Biot_c,Biot_h)
  
  for i = 1:length(Biot_c)
    for j = 1:length(Biot_h)
      M(i,j) = (partial_f_partial_alpha(alpha_0,beta_0,Biot_c(i),Biot_h(j)))*((q_bar(i,j)/q_T) - f_lsq(alpha_0,beta_0,Biot_c(i),Biot_h(j)));
    endfor
  endfor
  
  phi_1 = -2*sum(sum(M));
endfunction