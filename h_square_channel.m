function h_square_channel = h_square_channel(Mass_flow,T_water,N,a,abs_roughness,Length)
  Perimeter = 4*a;
  Dh = a;
  Re = 4*Mass_flow/(N*mu_water(T_water)*Perimeter);
  Pr = cp_water(T_water)*mu_water(T_water)/k_water(T_water);
  rug_rel = abs_roughness/Dh;
  f = f(rug_rel,Re);
  %Nu1 = 0.023*(Re^(4/5))*(Pr^0.3);
  Nu = (f/8)*(Re-1000)*Pr/(1 + 12.7*sqrt(f/8)*(Pr^(2/3) - 1));
  %Nu = 0.5*(Nu1 + Nu2);
  %Hausen Correlation
  %Nu = 0.116*(Re^(2/3) - 125)*(Pr^(1/3))*(1 + (Dh/Length)^(2/3));
  h_square_channel = Nu*k_water(T_water)/Dh;
end