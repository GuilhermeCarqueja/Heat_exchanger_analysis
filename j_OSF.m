function j_OSF = j_OSF(Re,alpha,delta,gamma)
  j_OSF = 0.6522*Re.^(-0.5403)*alpha^(-0.1541)*delta^0.1499*gamma^(-0.0678).*(1 + 5.269e-5*Re.^1.340*alpha^0.504*delta^0.456*gamma^(-1.055)).^0.1;
endfunction