Duct_length = 0.536;

relative_roughness = abs_roughness/d_h_h;
for i = 1:length(files)
  f_Darcy_h(1,i) = f_D(relative_roughness,Re_h(i));
  f_Darcy_h_smooth(1,i) = f_D(0,Re_h(i));
endfor

K_b_standard = 0.14;
C_Re = 2.2;
C_development_1 = 1;
C_development_2 = 0.9;
C_roughness(1,:) = f_Darcy_h./f_Darcy_h_smooth;

K_b_1(1,:) = K_b_standard*C_Re*C_development_1*C_roughness;
K_b_2(1,:) = K_b_standard*C_Re*C_development_2*C_roughness;

Velocity(1,:) = Mass_flow_h(1,:)./(rho(T_h(1,:))*N_hot_channels*hot_channel_width*height);

Deltap_core_h_theoretical(1,:) = rho(T_h(1,:)).*((Velocity(1,:).^2)/2).*(f_Darcy_h(1,:)*Duct_length/d_h_h + K_b_1(1,:) + K_b_2);
%Deltap_core_h_theoretical(1,:) = rho(T_h(1,:)).*((Velocity(1,:).^2)/2).*f_Darcy_h(1,:)*(Duct_length/height + 25);


sigma = 0.5;
K_c = 0.4;
Deltap_h_inlet(1,:) = rho(T_h(1,:)).*((Velocity(1,:).^2)/2)*(1 - sigma^2 + K_c);
K_e = 0.2;
Deltap_rise_outlet(1,:) = rho(T_h(1,:)).*((Velocity(1,:).^2)/2)*(1 - sigma^2 - K_e);

Dp_h_theoretical(1,:) = Deltap_h_inlet + Deltap_core_h_theoretical - Deltap_rise_outlet;
%{
figure
scatter(Dp_h(1,:),Dp_h_theoretical)
hold
plot([0 max(Dp_h(1,:))],[0 max(Dp_h(1,:))],'k')
xlabel('Experimental Pressure Drop [Pa]')
ylabel('Theoretical Pressure Drop [Pa]')
%plot([0 max(Dp_h(1,:))],[0 0.9*max(Dp_h(1,:))])
%plot([0 max(Dp_h(1,:))],[0 0.8*max(Dp_h(1,:))])
plot([0 max(Dp_h(1,:))],[0 0.7*max(Dp_h(1,:))],'LineStyle','--')
plot([0 max(Dp_h(1,:))],[0 1.3*max(Dp_h(1,:))],'LineStyle','--')
text(10000,15000,['+30%'],'HorizontalAlignment','Right','FontSize',15)
text(10000,5000,['-30%'],'FontSize',15)
axis([0 20000 0 20000])
set(gca,'FontSize',15)
print('Figures\Pressure_Drop_h.png')

text(10000,5000,['-30%'],'FontSize',15)
figure
scatter(Re_h(1,:),Dp_h(1,:))
hold
scatter(Re_h(1,:),Dp_h_theoretical(1,:))
axis([0 18000 0 20000])
%}

















Velocity_c(1,:) = Mass_flow_c(1,:)./(rho(T_c(1,:))*N_channels_1*channel_width*height);
Deltap_c_inlet(1,:) = rho(T_c(1,:)).*((Velocity_c(1,:).^2)/2)*(1 - sigma^2 + K_c);
Velocity_c_outlet(1,:) = Mass_flow_c(1,:)./(rho(T_c(1,:))*N_channels_2*channel_width*height);
Deltap_c_rise_outlet(1,:) = rho(T_c(1,:)).*((Velocity_c_outlet(1,:).^2)/2)*(1 - sigma^2 - K_e);
Dp_c_core = Dp_c(1,:) - Deltap_c_inlet(1,:) + Deltap_c_rise_outlet(1,:);
Velocity_c_mean(1,:) = Mass_flow_c(1,:)./(rho(T_c(1,:))*A_c);
f_c(1,:) = Dp_c_core(1,:)*d_h./(2*rho(T_c(1,:)).*(Velocity_c_mean(1,:).^2)*L);

aux = 1;
for i = 1:length(files)
  if Re_c(1,i) >= 2000
    Re_c_plot(1,aux) = Re_c(1,i);
    f_c_plot(1,aux) = f_c(1,i);
    j_c_plot(1,aux) = j_c(1,i);
    aux++;
  endif
endfor

B_lr = [ones(length(Re_c_plot),1) Re_c_plot(1,:)'];
linear_regression = (B_lr'*B_lr)\(B_lr'*f_c_plot');