function Delta_p = current_to_dp_h(Current)
  Measured_Current_1 = [4.012 12.003 19.998];
  Measured_Current_2 = [4.011 12.004 19.998];
  Measured_Current = (Measured_Current_1 + Measured_Current_2)/2;
  Pressure_psi = [0 2.5 5];
  Pressure = 6894.75729460444*Pressure_psi;
  
  if Current > Measured_Current(1)
    i = 1;
    while Current > Measured_Current(i)
      i++;
    endwhile
    i--;
    Delta_p(1,1) = Pressure(i) + ((Pressure(i+1) - Pressure(i))/(Measured_Current(i+1) - Measured_Current(i)))*(Current(1,1) - Measured_Current(i));
  else
    i = 1;
    Delta_p(1,1) = Pressure(i) + ((Pressure(i+1) - Pressure(i))/(Measured_Current(i+1) - Measured_Current(i)))*(Current(1,1) - Measured_Current(i));
  endif
  Delta_p(2,1) = ((Pressure(length(Pressure)) - Pressure(1))/(Measured_Current(length(Measured_Current)) - Measured_Current(1)))*(Current(2,1));
endfunction