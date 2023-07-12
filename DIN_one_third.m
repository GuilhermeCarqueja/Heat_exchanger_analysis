function DIN_one_third = DIN_one_third(T)
  Temperature = [0 100];
  Uncertainty = [0.3 0.8]/3;
  DIN_one_third = Uncertainty(1) + ((Uncertainty(2) - Uncertainty(1))/(Temperature(2) - Temperature(1)))*(T - Temperature(1));
endfunction