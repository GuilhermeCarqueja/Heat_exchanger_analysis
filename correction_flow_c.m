function Correction = correction_flow_c(Vol_Flow)
  Measured_flow_c = [2.04003E-02	2.90195E-02	4.73650E-02	9.47888E-02	1.43974E-01	1.96808E-01]/1000;
  Correction_c = [2.81599E-03	2.83157E-03	2.51088E-03	2.01900E-03	3.13817E-03	1.95972E-03]/1000;
  Std_Correction_c = [2.75512E-04	2.66371E-04	4.33113E-04	7.30141E-04	7.27997E-04	1.46363E-03]/1000;
  df_Correction_c = [2096	457	46	37	14	10];
  
  if Vol_Flow > 1e-5
    i = 1;
    while Vol_Flow > Measured_flow_c(i)
      i++;
    endwhile
    i--;
    if Vol_Flow <= Measured_flow_c(1)
      i = 1;
    end
    Correction(1,1) = Correction_c(i) + ((Correction_c(i+1) - Correction_c(i))/(Measured_flow_c(i+1) - Measured_flow_c(i)))*(Vol_Flow - Measured_flow_c(i));
    Correction(2,1) = Std_Correction_c(i) + ((Std_Correction_c(i+1) - Std_Correction_c(i))/(Measured_flow_c(i+1) - Measured_flow_c(i)))*(Vol_Flow - Measured_flow_c(i));
    Correction(3,1) = df_Correction_c(i+1);
    
  else
    Correction(1,1) = 0;
    Correction(2,1) = 0;
    Correction(3) = 1;
  end
endfunction