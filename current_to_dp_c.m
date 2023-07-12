function Delta_p = current_to_dp_c(Current)
  Delta_p_psi(1,1) = 3.125*(Current(1,1) - 4);
  Delta_p_psi(2,1) = 3.125*Current(2,1);
  Delta_p = 6894.75729460444*Delta_p_psi;
endfunction