function [lin_c ang_c R_squared] = linreg(x,y)
  X = [ones(length(x),1) x'];
  Y = y';
  
  coefficients = (X'*X)\(X'*Y);
  
  lin_c = coefficients(1);
  ang_c = coefficients(2);
  
  Sxx = sum((x - mean(x)).^2);
  Syy = sum((y - mean(y)).^2);
  Sxy = sum((x - mean(x)).*(y - mean(y)));
  
  rho_xy = Sxy/((Sxx*Syy)^0.5);
  R_squared = rho_xy^2;
endfunction