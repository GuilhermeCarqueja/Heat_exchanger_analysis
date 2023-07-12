%Model 1

%Initial calculations considering inlet temperatures
T_c(1,:) = T_ci(1,:);
T_h(1,:) = T_hi(1,:);
T_wall(1,:) = (T_c(1,:) + T_h(1,:))/2;

%R_w
R_w(1,:) = height./(k_s(T_wall(1,:))*L*effective_width);

%R_h
Re_h(1,:) = 4*Mass_flow_h(1,:)./(N_fins_h*mu_water(T_h(1,:)).*2*(hot_channel_width + height));
for i = 1:length(files)
  h_h(1,i) = h_tube(Re_h(1,i),T_h(1,i),0.003,abs_roughness,hot_channel_length,T_wall(1,i));
endfor
m(1,:) = (h_h(1,:)*fin_h_perimeter./(k_s(T_wall(1,:))*A_cross_fin_h)).^0.5;
etah_f_h(1,:) = tanh(m(1,:)*height)./(m(1,:)*height);
etah_o_h(1,:) = 1 - (N_fins_h*fin_h_perimeter*height/A_hh)*(1 - etah_f_h(1,:));
R_h(1,:) = 1 ./(etah_o_h(1,:).*h_h(1,:)*A_hh);
Rh(1,:) = 1 ./(h_h(1,:)*A_hh);

%R_c
Vmax1(1,:) = Mass_flow_c(1,:)./(rho(T_c(1,:))*A1);
Vmax2(1,:) = Mass_flow_c(1,:)./(rho(T_c(1,:))*A2);
V_max = (Vmax1 + Vmax2)/2;
d_h_bundle = fin_width;

D_e = 4*(total_width*height)/(2*(total_width + height));
U(1,:) = Mass_flow_c(1,:)./(rho(T_c(1,:))*total_width*height);
Re_Sara(1,:) = rho(T_c(1,:)).*U(1,:)*D_e./mu_water(T_c(1,:));
for i = 1:length(files)
  h_Duct(1,i) = h_Sara(Re_Sara(1,i),T_c(1,i),D_e,fin_width,fin_width);
endfor


Re_bundle = rho(T_c(1,:)).*V_max(1,:)*d_h_bundle./mu_water(T_c(1,:));
S_T = channel_width + fin_width;
S_L = communication_length + fin_length;
for i = 1:length(files)
  h_Bundle(1,i) = h_bundle(Re_bundle(1,i),T_c(1,i),d_h_bundle,S_T,S_L,T_wall(1,i));
endfor
h_c = h_Bundle;
m(1,:) = (h_c(1,:)*fin_c_perimeter./(k_s(T_wall(1,:))*A_cross_fin_c)).^0.5;
etah_f_c(1,:) = tanh(m(1,:)*height)./(m(1,:)*height);
etah_o_c(1,:) = 1 - (N_fins_c*fin_c_perimeter*height/A_hc)*(1 - etah_f_c(1,:));
R_c(1,:) = 1./(etah_o_c(1,:).*h_c(1,:)*A_hc);
Rc(1,:) = 1./(h_c(1,:)*A_hc);





De = 4*total_width*height/(2*(total_width + height));
U(1,:) = Mass_flow_c(1,:)./(rho(T_c(1,:))*total_width*height);
%Thermal Circuit
R_model_1 = R_c + R_w + R_h;
UA_model_1 = 1 ./R_model_1;
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
    q_model_1(1,i) = epsilon(i)*q_max;
    T_co_model_1(1,i) = T_ci(1,i) + epsilon(i)*(T_hi(1,i) - T_ci(1,i));
    T_ho_model_1(1,i) = T_hi(1,i) - epsilon(i)*C_r(i)*(T_hi(1,i) - T_ci(1,i));
  endif
  if C_c(i) > C_h(i)
    q_max = C_h(i)*(T_hi(1,i) - T_ci(1,i));
    q_model_1(1,i) = epsilon(i)*q_max;
    T_ho_model_1(1,i) = T_hi(1,i) - epsilon(i)*(T_hi(1,i) - T_ci(1,i));
    T_co_model_1(1,i) = T_ci(1,i) + epsilon(i)*C_r(i)*(T_hi(1,i) - T_ci(1,i));
  endif
endfor

T_h(1,:) = (T_hi(1,:) + T_ho_model_1(1,:))/2;
T_c(1,:) = (T_ci(1,:) + T_co_model_1(1,:))/2;
Delta_T_h(1,:) = Rh(1,:).*q_model_1(1,:);
T_wall_h(1,:) = T_h(1,:) - Delta_T_h(1,:);
Delta_T_c(1,:) = Rc(1,:).*q_model_1(1,:);
T_wall_c(1,:) = T_c(1,:) + Delta_T_c(1,:);
T_wall = (T_wall_c + T_wall_h)/2;

Re_h(1,:) = 4*Mass_flow_h(1,:)./(N_fins_h*mu_water(T_h(1,:)).*2*(hot_channel_width + height));

%Iterative Calculations
UA_old = ones(1,length(files));
UA_relvar = (UA_model_1 - UA_old)./UA_old;
while max(abs(UA_relvar)) > 1e-10
  UA_old = UA_model_1;
  
  Re_h(1,:) = 4*Mass_flow_h(1,:)./(N_fins_h*mu_water(T_h(1,:)).*2*(hot_channel_width + height));
  
  
  %R_h
  Re_h(1,:) = 4*Mass_flow_h(1,:)./(N_fins_h*mu_water(T_h(1,:)).*2*(hot_channel_width + height));
  for i = 1:length(files)
    h_h(1,i) = h_tube(Re_h(1,i),T_h(1,i),0.003,abs_roughness,hot_channel_length,T_wall_h(1,i));
  endfor
  m(1,:) = (h_h(1,:)*fin_h_perimeter./(k_s(T_wall(1,:))*A_cross_fin_h)).^0.5;
  etah_f_h(1,:) = tanh(m(1,:)*height)./(m(1,:)*height);
  etah_o_h(1,:) = 1 - (N_fins_h*fin_h_perimeter*height/A_hh)*(1 - etah_f_h(1,:));
  R_h(1,:) = 1 ./(etah_o_h(1,:).*h_h(1,:)*A_hh);
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
  m(1,:) = (h_c(1,:)*fin_c_perimeter./(k_s(T_wall(1,:))*A_cross_fin_c)).^0.5;
  etah_f_c(1,:) = tanh(m(1,:)*height)./(m(1,:)*height);
  etah_o_c(1,:) = 1 - (N_fins_c*fin_c_perimeter*height/A_hc)*(1 - etah_f_c(1,:));
  R_c(1,:) = 1./(etah_o_c(1,:).*h_c(1,:)*A_hc);
  Rc(1,:) = 1./(h_c(1,:)*A_hc);
  
  %Thermal Circuit
  R_model_1 = R_c + R_w + R_h;
  UA_model_1 = 1 ./R_model_1;
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
      q_model_1(1,i) = epsilon(i)*q_max;
      T_co_model_1(1,i) = T_ci(1,i) + epsilon(i)*(T_hi(1,i) - T_ci(1,i));
      T_ho_model_1(1,i) = T_hi(1,i) - epsilon(i)*C_r(i)*(T_hi(1,i) - T_ci(1,i));
    endif
    if C_c(i) > C_h(i)
      q_max = C_h(i)*(T_hi(1,i) - T_ci(1,i));
      q_model_1(1,i) = epsilon(i)*q_max;
      T_ho_model_1(1,i) = T_hi(1,i) - epsilon(i)*(T_hi(1,i) - T_ci(1,i));
      T_co_model_1(1,i) = T_ci(1,i) + epsilon(i)*C_r(i)*(T_hi(1,i) - T_ci(1,i));
    endif
  endfor
  
  T_h(1,:) = (T_hi(1,:) + T_ho_model_1(1,:))/2;
  T_c(1,:) = (T_ci(1,:) + T_co_model_1(1,:))/2;
  Delta_T_h(1,:) = Rh(1,:).*q_model_1(1,:);
  T_wall_h(1,:) = T_h(1,:) - Delta_T_h(1,:);
  Delta_T_c(1,:) = Rc(1,:).*q_model_1(1,:);
  T_wall_c(1,:) = T_c(1,:) + Delta_T_c(1,:);
  T_wall = (T_wall_c + T_wall_h)/2;
  
  UA_relvar = (UA_model_1 - UA_old)./UA_old;
  max(abs(UA_relvar))
endwhile