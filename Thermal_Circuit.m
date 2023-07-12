%Experimental Thermal Resistance
R(1,:) = 1./UA_cold(1,:);

%Cold Side
A_h_fins_1 = N_channels_1*(2*height*fin_length + channel_width*fin_length);
A_h_fins_2 = N_channels_2*(2*height*fin_length + channel_width*fin_length);
A_h_Communication = total_width*communication_length + (N_channels_2 - 1)*fin_width*height + (N_channels_1 + 1)*fin_width*height;
A_h_instance = A_h_fins_1 + 2*A_h_Communication + A_h_fins_2;
A_hc = N_instances*A_h_instance + A_h_fins_1 + 2*total_width*communication_length + 4*height*communication_length; %Total cold side heat transfer area
A_cross_fin_c = fin_width*fin_length;
fin_c_perimeter = 2*(fin_width + fin_length);
N_fins_c = N_instances*(N_channels_1 + N_channels_2 - 2) + N_channels_1 - 1;
A1 = N_channels_1*channel_width*height;
A2 = N_channels_2*channel_width*height;

%Hot Side
N_fins_h = 11;
fin_h_perimeter = 2*hot_channel_length;
A_cross_fin_h = fin_h_width*hot_channel_length;
abs_roughness = ((0.15 + 0.11)/2 + 2.41 + 3.43)/4000000;
effective_width = total_width;
A_hh = N_fins_h*fin_h_perimeter*height + N_fins_h*hot_channel_width*hot_channel_length;

T_c(1,:) = (T_ci(1,:) + T_co(1,:))/2;
T_h(1,:) = (T_hi(1,:) + T_ho(1,:))/2;
Re_h(1,:) = 4*Mass_flow_h(1,:)./(N_fins_h*mu_water(T_h(1,:)).*2*(hot_channel_width + hot_channel_height));

T_wall(1,:) = (T_c(1,:) + T_h(1,:))/2;

%R_w
R_w(1,:) = height./(k_s(T_wall(1,:))*L*effective_width);

%R_h
for i = 1:length(files)
  h_h(1,i) = h_tube(Re_h(1,i),T_h(1,i),0.003,abs_roughness,hot_channel_length,T_wall(1,i),hot_channel_width,hot_channel_height);
endfor
m(1,:) = (h_h(1,:)*fin_h_perimeter./(k_s(T_wall(1,:))*A_cross_fin_h)).^0.5;
eta_f_h(1,:) = tanh(m(1,:)*height)./(m(1,:)*height);
eta_o_h(1,:) = 1 - (N_fins_h*fin_h_perimeter*height/A_hh)*(1 - eta_f_h(1,:));
R_h(1,:) = 1 ./(eta_o_h(1,:).*h_h(1,:)*A_hh);
%Rh(1,:) = 1 ./(h_h(1,:)*A_hh);

R_c = R - R_w - R_h;

eta_o_c(1,1:length(files)) = 0.7;
h_c(1,:) = 1 ./(eta_o_c(1,:)*A_hc.*R_c(1,:));
parameter = 1;
while parameter > 1e-10
  R_c_old = R_c;
  R_w_old = R_w;
  R_h_old = R_h;
  
  T_wall_c(1,:) = T_c(1,:) + q_cold(1,:).*R_c(1,:);
  T_wall_h(1,:) = T_h(1,:) - q_cold(1,:).*R_h(1,:);
  T_wall = (T_wall_c + T_wall_h)/2;
  R_w(1,:) = height./(k_s(T_wall(1,:))*L*effective_width);
  
  DT_h(1,:) = q_cold(1,:)./(h_h(1,:)*A_hh);
  T_w_h = T_h - DT_h;
  for i = 1:length(files)
    h_h(1,i) = h_tube(Re_h(1,i),T_h(1,i),0.003,abs_roughness,hot_channel_length,T_w_h(1,i),hot_channel_width,hot_channel_height);
  endfor
  m(1,:) = (h_h(1,:)*fin_h_perimeter./(k_s(T_w_h(1,:))*A_cross_fin_h)).^0.5;
  eta_f_h(1,:) = tanh(m(1,:)*height)./(m(1,:)*height);
  eta_o_h(1,:) = 1 - (N_fins_h*fin_h_perimeter*height/A_hh)*(1 - eta_f_h(1,:));
  R_h(1,:) = 1 ./(eta_o_h(1,:).*h_h(1,:)*A_hh);
  
  R_c = R - R_w - R_h;
  
  r = 1;
  while r > 1e-10
    h_c_old = h_c;
    DT_c(1,:) = q_cold(1,:)./(h_c(1,:)*A_hc);
    T_w_c = T_c + DT_c;
    m(1,:) = (h_c(1,:)*fin_c_perimeter./(k_s(T_w_c(1,:))*A_cross_fin_c)).^0.5;
    eta_f_c(1,:) = tanh(m(1,:)*height)./(m(1,:)*height);
    eta_o_c(1,:) = 1 - (N_fins_c*fin_c_perimeter*height/A_hc)*(1 - eta_f_c(1,:));
    h_c(1,:) = 1 ./(eta_o_c(1,:).*R_c(1,:)*A_hc);
    r = max(abs((h_c - h_c_old)./h_c_old));
  endwhile
  parameter = max([max(abs((R_c - R_c_old)./R_c_old)) max(abs((R_w - R_w_old)./R_w_old)) max(abs((R_h - R_h_old)./R_h_old))]);
endwhile
Nu_c(1,:) = h_c(1,:)*d_h./k_water(T_c(1,:));
Pr_c(1,:) = cp_water(T_c(1,:)).*mu_water(T_c(1,:))./k_water(T_c(1,:));
j_c(1,:) = Nu_c(1,:)./(Re_c(1,:).*(Pr_c(1,:).^(1/3)));
%scatter(Re_c(1,:),j_c(1,:))
%axis([0 5500 0 0.0015])

Fanning(1,:) = rho(T_c(1,:)).*Dp_c(1,:)*d_h*A_c^2 ./((Mass_flow_c(1,:).^2)*2*L);
Fanning(2,:) = (((rho(T_c(1,:))*d_h*A_c^2 ./(2*(Mass_flow_c(1,:).^2)*L)).*Dp_c(2,:)).^2 + ((-rho(T_c(1,:)).*Dp_c(1,:)*d_h*A_c^2 ./((Mass_flow_c(1,:).^3)*L)).*Mass_flow_c(2,:)).^2).^0.5;

Fanning(3,:) = ((Fanning(2,:)./Fanning(1,:)).^4)./(((Dp_c(2,:)./Dp_c(1,:)).^4)./Dp_c(3,:) + ((Mass_flow_c(2,:)./Mass_flow_c(1,:)).^4)./Mass_flow_c(3,:));
Fanning(4,:) = tinv(1-(1-p)/2,Fanning(3,:)).*Fanning(2,:);

%figure
%scatter(Re_c(1,:),Fanning(1,:))
%axis([0 5500 0 0.5])