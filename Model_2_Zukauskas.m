%Initial calculations considering inlet temperatures
T_c(1,:) = T_ci(1,:);
T_h(1,:) = T_hi(1,:);
T_wall(1,:) = (T_c(1,:) + T_h(1,:))/2;

%h_h
Re_h(1,:) = 4*Mass_flow_h(1,:)./(N_fins_h*mu_water(T_h(1,:)).*2*(hot_channel_width + height));
for i = 1:length(files)
  h_h(1,i) = h_tube(Re_h(1,i),T_h(1,i),0.003,abs_roughness,hot_channel_length,T_wall(1,i));
endfor

%h_c
Vmax1(1,:) = Mass_flow_c(1,:)./(rho(T_c(1,:))*A1);
Vmax2(1,:) = Mass_flow_c(1,:)./(rho(T_c(1,:))*A2);
V_max = (Vmax1 + Vmax2)/2;
d_h_bundle = fin_width;
Re_bundle = rho(T_c(1,:)).*V_max(1,:)*d_h_bundle./mu_water(T_c(1,:));
S_T = channel_width + fin_width;
S_L = communication_length + fin_length;
for i = 1:length(files)
  h_Bundle(1,i) = h_bundle(Re_bundle(1,i),T_c(1,i),d_h_bundle,S_T,S_L,T_wall(1,i));
endfor
h_c = h_Bundle;

Bh(1,:) = h_h(1,:)*height./k_s(T_wall(1,:));
Bc(1,:) = h_c(1,:)*height./k_s(T_wall(1,:));
for i = 1:length(files)
  q_bar_model_2(1,i) = q_bar_calculator(Bc(1,i),Bh(1,i));
endfor

R_model_2  = 1 ./(Number_domain_periods*q_bar_model_2.*k_s(T_wall)*height);
UA_model_2 = 1 ./R_model_2;

C_c(1,:) = cp_water(T_c(1,:)).*Mass_flow_c(1,:);
C_h(1,:) = cp_water(T_h(1,:)).*Mass_flow_h(1,:);
C_min(1,:) = min(C_c(1,:),C_h(1,:));
C_max(1,:) = max(C_c(1,:),C_h(1,:));
C_r(1,:) = C_min./C_max;
Ntu(1,:) = UA_model_2(1,:)./C_min(1,:);
epsilon(1,:) = (exp(Ntu(1,:).*(C_r - 1)) - 1)./(C_r(1,:).*exp(Ntu(1,:).*(C_r - 1)) - 1);
for i = 1:length(files)
  if C_c(i) < C_h(i)
    q_max = C_c(i)*(T_hi(1,i) - T_ci(1,i));
    q_model_2(1,i) = epsilon(i)*q_max;
    T_co_model_2(1,i) = T_ci(1,i) + epsilon(i)*(T_hi(1,i) - T_ci(1,i));
    T_ho_model_2(1,i) = T_hi(1,i) - epsilon(i)*C_r(i)*(T_hi(1,i) - T_ci(1,i));
  endif
  if C_c(i) > C_h(i)
    q_max = C_h(i)*(T_hi(1,i) - T_ci(1,i));
    q_model_2(1,i) = epsilon(i)*q_max;
    T_ho_model_2(1,i) = T_hi(1,i) - epsilon(i)*(T_hi(1,i) - T_ci(1,i));
    T_co_model_2(1,i) = T_ci(1,i) + epsilon(i)*C_r(i)*(T_hi(1,i) - T_ci(1,i));
  endif
endfor


Rc(1,:) = 1 ./(h_c(1,:)*A_hc);
Rh(1,:) = 1 ./(h_h(1,:)*A_hh);

T_h(1,:) = (T_hi(1,:) + T_ho_model_2(1,:))/2;
T_c(1,:) = (T_ci(1,:) + T_co_model_2(1,:))/2;
Delta_T_h(1,:) = Rh(1,:).*q_model_2(1,:);
T_wall_h(1,:) = T_h(1,:) - Delta_T_h(1,:);
Delta_T_c(1,:) = Rc(1,:).*q_model_2(1,:);
T_wall_c(1,:) = T_c(1,:) + Delta_T_c(1,:);
T_wall = (T_wall_c + T_wall_h)/2;

%Iterative Calculations
UA_old = ones(1,length(files));
UA_relvar = (UA_model_1 - UA_old)./UA_old;
while max(abs(UA_relvar)) > 1e-10
  UA_old = UA_model_2;
  
  %h_h
  Re_h(1,:) = 4*Mass_flow_h(1,:)./(N_fins_h*mu_water(T_h(1,:)).*2*(hot_channel_width + height));
  for i = 1:length(files)
    h_h(1,i) = h_tube(Re_h(1,i),T_h(1,i),0.003,abs_roughness,hot_channel_length,T_wall_h(1,i));
  endfor
    Rh(1,:) = 1 ./(h_h(1,:)*A_hh);
  
  %R_c
  Vmax1(1,:) = Mass_flow_c(1,:)./(rho(T_c(1,:))*A1);
  Vmax2(1,:) = Mass_flow_c(1,:)./(rho(T_c(1,:))*A2);
  V_max = (Vmax1 + Vmax2)/2;
  d_h_bundle = fin_width;
  Re_bundle = rho(T_c(1,:)).*V_max(1,:)*d_h_bundle./mu_water(T_c(1,:));
  S_T = channel_width + fin_width;
  S_L = communication_length + fin_length;
  for i = 1:length(files)
    h_Bundle(1,i) = h_bundle(Re_bundle(1,i),T_c(1,i),d_h_bundle,S_T,S_L,T_wall_c(1,i));
  endfor
  h_c = h_Bundle;
  Rc(1,:) = 1./(h_c(1,:)*A_hc);
  
  Bh(1,:) = h_h(1,:)*height./k_s(T_wall(1,:));
  Bc(1,:) = h_c(1,:)*height./k_s(T_wall(1,:));
  for i = 1:length(files)
    q_bar_model_2(1,i) = q_bar_calculator(Bc(1,i),Bh(1,i));
  endfor
  %q_bar_model_2(1,:) = q_bar_calculator(Bc(1,:),Bh(1,:));
  
  R_model_2  = 1 ./(Number_domain_periods*q_bar_model_2.*k_s(T_wall)*height);
  UA_model_2 = Number_domain_periods*q_bar_model_2.*k_s(T_wall)*height;
  
  C_c(1,:) = cp_water(T_c(1,:)).*Mass_flow_c(1,:);
  C_h(1,:) = cp_water(T_h(1,:)).*Mass_flow_h(1,:);
  C_min(1,:) = min(C_c(1,:),C_h(1,:));
  C_max(1,:) = max(C_c(1,:),C_h(1,:));
  C_r(1,:) = C_min./C_max;
  Ntu(1,:) = UA_model_1(1,:)./C_min(1,:);
  epsilon(1,:) = (exp(Ntu(1,:).*(C_r - 1)) - 1)./(C_r(1,:).*exp(Ntu(1,:).*(C_r - 1)) - 1);
  for i = 1:length(files)
    if C_c(i) < C_h(i)
      q_max = C_c(i)*(T_hi(1,i) - T_ci(1,i));
      q_model_2(1,i) = epsilon(i)*q_max;
      T_co_model_2(1,i) = T_ci(1,i) + epsilon(i)*(T_hi(1,i) - T_ci(1,i));
      T_ho_model_2(1,i) = T_hi(1,i) - epsilon(i)*C_r(i)*(T_hi(1,i) - T_ci(1,i));
    endif
    if C_c(i) > C_h(i)
      q_max = C_h(i)*(T_hi(1,i) - T_ci(1,i));
      q_model_2(1,i) = epsilon(i)*q_max;
      T_ho_model_2(1,i) = T_hi(1,i) - epsilon(i)*(T_hi(1,i) - T_ci(1,i));
      T_co_model_2(1,i) = T_ci(1,i) + epsilon(i)*C_r(i)*(T_hi(1,i) - T_ci(1,i));
    endif
  endfor
  
  T_h(1,:) = (T_hi(1,:) + T_ho_model_2(1,:))/2;
  T_c(1,:) = (T_ci(1,:) + T_co_model_2(1,:))/2;
  Delta_T_h(1,:) = Rh(1,:).*q_model_2(1,:);
  T_wall_h(1,:) = T_h(1,:) - Delta_T_h(1,:);
  Delta_T_c(1,:) = Rc(1,:).*q_model_2(1,:);
  T_wall_c(1,:) = T_c(1,:) + Delta_T_c(1,:);
  T_wall = (T_wall_c + T_wall_h)/2;
  
  UA_relvar = (UA_model_2 - UA_old)./UA_old;
  max(abs(UA_relvar))
endwhile