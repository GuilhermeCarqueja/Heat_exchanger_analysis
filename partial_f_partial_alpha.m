function partial_f_partial_alpha = partial_f_partial_alpha(a,b,Bc,Bh)
  partial_f_partial_alpha = ((sech(a*Bc^0.5))^2)*(Bc^0.5)*tanh(b*Bh^0.5);
endfunction