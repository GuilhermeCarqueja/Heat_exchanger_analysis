function h_tube = h_tube(Re,Temperature,Dh,abs_roughness,L,T_wall,W,H)
  
  Pr = cp_water(Temperature)*mu_water(Temperature)/k_water(Temperature);
  Pr_w = cp_water(T_wall)*mu_water(T_wall)/k_water(T_wall);
    
  abs_roughness;
  rel_roughness = abs_roughness/Dh;
  f_D = f_D(rel_roughness,Re);
  %f = 0.00128 + 0.1143*Re^(-0.311);
  %Correlação de Dittus-Boelter
  %Nu = 0.023*(Re^(4/5))*(Pr^0.4);  
  %Analogia de Chilton Colburn
  %Nu = (f*Re*Pr/8)^(3/5);
  %Correlação de Gnielinski
  %Nu = (f_D/8)*(Re-1000)*Pr/(1 + 12.7*sqrt(f_D/8)*(Pr^(2/3) - 1));
  
  
  K = (Pr/Pr_w)^0.11;
  Nu = ((f_D/8)*(Re-1000)*Pr/(1 + 12.7*sqrt(f_D/8)*(Pr^(2/3) - 1)))*(1 + (Dh/L)^(2/3))*K;
  
  %Nu = 0.5*(Nu1 + Nu2);
  
  %Correlação de Hausen
  %Nu = 0.116*(Re^(2/3) - 125)*(Pr^(1/3))*(1 + (Dh/L)^(2/3))*(mu_ar(Temperature)/mu_ar(T_wall))^0.14;
  %Equação de Taborek
  %Nu_laminar = 2.98;
  %Nu = 0.5*f*Re*Pr/(1.07 + 900/Re - 0.63/(1 + 10*Pr) + 12.7*((0.5*f)^0.5)*(Pr^(2/3) - 1));
  %Nu_turbulento = 0.023*(Re^(4/5))*(Pr^0.4);
  %phi = 1.33 - Re/6000;
  %Nu = phi*Nu_laminar + (1 - phi)*Nu_turbulento;
  %Correlação João
  %Nu = 4.089 + 0.00497*(Re^0.95)*(Pr^0.55);
  %Correlação João 2 - zigue-zague MGO
  %Nu = 0.1696*(Re^0.629)*(Pr^0.317);
  
  %{
  epsilon = min(W,H)/max(W,H);
  C1 = 3.24;
  C2 = 3/2;
  C3 = 0.409;
  C4 = 2;
  C0 = 0.564;
  Ci = 0.339;
  fPr = C0/(1 + (C0*Pr^(1/6)/Ci)^(9/2))^(2/9);
  m1 = 2.27 + 1.65*Pr^(1/3);
  gamma = 1/10;
  Re_sqrtA = Re*((W*H)^0.5)/Dh;
  z_dimensionless = L/((W*H)^0.5*Re_sqrtA);
  fRe = ((3.44/z_dimensionless)^2 + (12/(epsilon^0.5*(1 + epsilon)*(1 - (192*epsilon/pi^5)*tanh(pi/(2*epsilon)))))^2)^0.5;
  Nu_sqrtA_L = ((C4*fPr/z_dimensionless^0.5)^m1 + ((C2*C3*(fRe/z_dimensionless)^(1/3))^5 + (C1*fRe/(8*pi^0.5*epsilon^gamma))^5)^(m1/5))^(1/m1);
  TC = (Pr/Pr_w)^2;
  fRe_sqrtA_T = (3.6*log10(6.115/Re_sqrtA))^(-2)*Re_sqrtA;
  tau = fRe_sqrtA_T/2;
  K_td = 1 + (1.12*(W*H)^0.5/L)^(2/3);
  Nu_sqrtA_T = TC*K_td*tau*(1 - 886/Re_sqrtA)*Pr/(1 + 2.495*(Pr^(2/3) - 1)/log10(6.115/Re_sqrtA));
  mc = 12;
  B = 406;
  Re_sqrtA_critical = 1700;
  Psi = exp(-(Re_sqrtA_critical - Re_sqrtA)^2/B^2);
  Nu_sqrtA = (Nu_sqrtA_L^mc + (Psi/(Nu_sqrtA_L^2) + 1/(Nu_sqrtA_T^2))^(-mc/2))^(1/mc);
  %}  
  h_tube = Nu*k_water(Temperature)/Dh;
  %h_tube = Nu_sqrtA*k_water(Temperature)/(W*H)^0.5;
end