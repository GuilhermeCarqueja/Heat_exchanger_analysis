function cv = cv(T)
  Temperature = (5:5:95);
  c_v = [4205 4191 4174 4157 4138 4117 4096 4073 4050 4026 4002 3976 3951 3925 3899 3873 3847 3820 3794];
  
  k = 1;
  while Temperature(k) < T
    k++;
  endwhile
  k--;
  
  cv = c_v(k) + ((c_v(k+1) - c_v(k))/(Temperature(k+1) - Temperature(k)))*(T - Temperature(k))
endfunction