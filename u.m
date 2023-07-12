function u = u(T)
  ID = fopen('Saturated_Water.txt');
  format = '%f';
  N_col = 11;
  Table = textscan(ID,repmat(format,N_col),'Delimiter',' ');
  
  Temperature = Table{1}(:);
  Specific_Internal_Energy_l = Table{5}(:)*1e3;
  k = 0;
  T_aux = 0;
  while T_aux<T
    k++;
    T_aux = Temperature(k);
  endwhile
  k--;
  
  u = Specific_Internal_Energy_l(k) + ((Specific_Internal_Energy_l(k+1)-Specific_Internal_Energy_l(k))/(Temperature(k+1)-Temperature(k)))*(T-Temperature(k));
  fclose('Saturated_Water.txt');
endfunction