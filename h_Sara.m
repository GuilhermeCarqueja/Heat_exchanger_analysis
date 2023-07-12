function h_Sara = h_Sara(Re,T,D_e,Sx,D_fin)
  Pr = cp_water(T)*mu_water(T)/k_water(T);
  Nu = 2.8358*(Re^0.58)*((Sx/D_fin)^(-0.251))*Pr^(1/3);
  h_Sara = Nu*k_water(T)/D_fin;
endfunction