function k_s = k_s(Temperature_C)
  Temp_K = Temperature_C + 273.15;
  k_s = 13.4 + ((15.2 - 13.4)/(400 - 300))*(Temp_K - 300);
end