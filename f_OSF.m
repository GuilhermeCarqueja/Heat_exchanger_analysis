function f_OSF = f_OSF(Re,alpha,delta,gamma)
  f_OSF =9.6243*Re.^(-0.7422)*alpha^(-0.1856)*delta^0.3053*gamma^(-0.2659).*(1 + 7.669e-8*Re.^4.426*alpha^0.920*delta^3.767*gamma^0.236).^0.1;
endfunction