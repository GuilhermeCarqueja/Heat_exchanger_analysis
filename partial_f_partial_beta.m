function partial_f_partial_beta = partial_f_partial_beta(a,b,Bc,Bh)
  partial_f_partial_beta = ((sech(b*Bh^0.5))^2)*(Bh^0.5)*tanh(a*Bc^0.5);
endfunction
