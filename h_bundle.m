function h_bundle = h_bundle(Re,Temperature,Dh,ST,SL,T_wall)
  
  Pr = cp_water(Temperature)*mu_water(Temperature)/k_water(Temperature);
  Pr_w = cp_water(T_wall)*mu_water(T_wall)/k_water(T_wall);
  
  if Re <= 1e2
    C1 = 0.9;
    m1 = 0.4;
  endif
  if Re > 1e2 || Re <= 1e3
    C1 = 0.51;
    m1 = 0.5;
  endif
  if Re > 1e3 || Re <= 2e5
    if ST/SL < 2
      C1 = 0.35*(ST/SL)^(1/5);
    else
      C1 = 0.4;
    endif
    m1 = 0.6;
  endif
  if Re > 2e5 || Re <= 2e6
    C1 = 0.022;
    m1 = 0.84;
  endif
  
  
  Nu = C1*(Re^m1)*(Pr^0.36)*(Pr/Pr_w)^(1/4);
  
  h_bundle = Nu*k_water(Temperature)/Dh;
end