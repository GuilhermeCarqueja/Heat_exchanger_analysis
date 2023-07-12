function q_bar_calculator = q_bar_calculator(bc,bh)
  load q_bar_data
  
  aux = 1;  
  while Biot_h(aux) < bh
    aux++;
  endwhile
  aux--;
  
  q_bar_inf = q_bar(:,aux);
  q_bar_sup = q_bar(:,aux + 1);
  
  q_bar_interpol = q_bar_inf + ((q_bar_sup - q_bar_inf)/(Biot_h(aux + 1) - Biot_h(aux)))*(bh - Biot_h(aux));
  aux = 1;  
  while Biot_c(aux) < bc
    aux++;
  endwhile
  aux--;
  
  q_bar_calculator = q_bar_interpol(aux) + ((q_bar_interpol(aux + 1) - q_bar_interpol(aux))/(Biot_c(aux + 1) - Biot_c(aux)))*(bc - Biot_c(aux));
endfunction