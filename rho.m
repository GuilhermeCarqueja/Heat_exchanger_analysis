function rho = rho(T)
  ID = fopen('Saturated_Water.txt');
  format = '%f';
  N_col = 11;
  Table = textscan(ID,repmat(format,N_col),'Delimiter',' ');
  
  Temperature = Table{1}(:);
  Specific_Volume_l = Table{3}(:)/1e3;
  Density = 1./Specific_Volume_l;
  k = 0;
  T_aux = 0;
  while T_aux<T
    k++;
    T_aux = Temperature(k);
  endwhile
  if Temperature(k)>T
    k--;
  endif
  
  rho = Density(k) + ((Density(k+1)-Density(k))/(Temperature(k+1)-Temperature(k)))*(T-Temperature(k));
  fclose('Saturated_Water.txt');
endfunction