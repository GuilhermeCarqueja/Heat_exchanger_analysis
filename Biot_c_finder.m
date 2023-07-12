function Biot_c_finder = Biot_c_finder(Bh,q_bar_exp,q_bar,Biot_c,Biot_h);
  
  aux = 1;  
  while Biot_h(aux) < Bh
    aux++;
  endwhile
  aux--;
  
  q_bar_inf = q_bar(:,aux);
  q_bar_sup = q_bar(:,aux + 1);
  
  q_bar_interpol = q_bar_inf + ((q_bar_sup - q_bar_inf)/(Biot_h(aux + 1) - Biot_h(aux)))*(Bh - Biot_h(aux));
  aux = 1;  
  while q_bar_interpol(aux) < q_bar_exp
    aux++;
  endwhile
  aux--;
  Biot_c_finder = Biot_c(aux) + ((Biot_c(aux + 1) - Biot_c(aux))/(q_bar_interpol(aux + 1) - q_bar_interpol(aux)))*(q_bar_exp - q_bar_interpol(aux));
endfunction