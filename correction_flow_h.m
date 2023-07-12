function Correction = correction_flow_h(Vol_Flow)
  Measured_flow_h = [1.04822E-01	1.52765E-01	2.03324E-01]/1000;
  Correction_h = [-8.01445E-03	-5.65282E-03	-4.55632E-03]/1000;
  Std_Correction_h = [6.97325E-04	7.16991E-04	1.46844E-03]/1000;
  df_Correction_h = [31	13	10];
  
  if Vol_Flow >= Measured_flow_h(1) && Vol_Flow <= Measured_flow_h(length(Measured_flow_h))
    i = 1;
    while Vol_Flow > Measured_flow_h(i)
      i++;
    endwhile
    i--;
    Correction(1,1) = Correction_h(i) + ((Correction_h(i+1) - Correction_h(i))/(Measured_flow_h(i+1) - Measured_flow_h(i)))*(Vol_Flow - Measured_flow_h(i));
    Correction(2,1) = Std_Correction_h(i) + ((Std_Correction_h(i+1) - Std_Correction_h(i))/(Measured_flow_h(i+1) - Measured_flow_h(i)))*(Vol_Flow - Measured_flow_h(i));
    Correction(3,1) = df_Correction_h(i+1);
  end
  
  if Vol_Flow > Measured_flow_h(length(Measured_flow_h))
    i = length(Measured_flow_h) - 1;
    Correction(1,1) = Correction_h(i) + ((Correction_h(i+1) - Correction_h(i))/(Measured_flow_h(i+1) - Measured_flow_h(i)))*(Vol_Flow - Measured_flow_h(i));
    Correction(2,1) = Std_Correction_h(i) + ((Std_Correction_h(i+1) - Std_Correction_h(i))/(Measured_flow_h(i+1) - Measured_flow_h(i)))*(Vol_Flow - Measured_flow_h(i));
    Correction(3,1) = df_Correction_h(i+1);
  end
  
  if Vol_Flow < Measured_flow_h(1)
    i = 1;
    Correction(1,1) = Correction_h(i) + ((Correction_h(i+1) - Correction_h(i))/(Measured_flow_h(i+1) - Measured_flow_h(i)))*(Vol_Flow - Measured_flow_h(i));
    Correction(2,1) = Std_Correction_h(i) + ((Std_Correction_h(i+1) - Std_Correction_h(i))/(Measured_flow_h(i+1) - Measured_flow_h(i)))*(Vol_Flow - Measured_flow_h(i));
    Correction(3,1) = df_Correction_h(i);
  end
endfunction