%q
p_co = 101325; %Outlet pressure in Pa
p_ci = p_co + Dp_c(1,:);
rho_c_avg = Dp_c(1,:)./(p_ci./rho(T_ci(1,:)) - p_co./rho(T_co(1,:)));

u_ci(1,:) = u(T_ci(1,:));
DT = 1;
du_dT_sat = (u(T_ci(1,:)+DT/2) - u(T_ci(1,:)-DT/2))/DT;
u_ci(2,:) = T_ci(2,:).*du_dT_sat;
u_ci(3,:) = ((u_ci(2,:)./u_ci(1,:)).^4)/(((T_ci(2,:)./T_ci(1,:)).^4)./T_ci(3,:));

u_co(1,:) = u(T_co(1,:));
du_dT_sat = (u(T_co(1,:)+DT/2) - u(T_co(1,:)-DT/2))/DT;
u_co(2,:) = T_co(2,:).*du_dT_sat;
u_co(3,:) = ((u_co(2,:)./u_co(1,:)).^4)/(((T_co(2,:)./T_co(1,:)).^4)./T_co(3,:));

q_cold_specific = u_co(1,:) - u_ci(1,:) - Dp_c(1,:)./rho_c_avg;
q_cold(1,:) = Mass_flow_c(1,:).*q_cold_specific;

var_q_cold = (q_cold_specific.^2).*(Mass_flow_c(2,:).^2) + (Mass_flow_c(1,:).^2).*((u_co(2,:).^2) + (u_ci(2,:).^2) + (1./(rho_c_avg.^2)).*(Dp_c(2,:).^2));
q_cold(2,:) = var_q_cold.^0.5;
A = (q_cold(2,:)./q_cold(1,:)).^4;
B = ((Mass_flow_c(2,:)./Mass_flow_c(1,:)).^4)./Mass_flow_c(3,:);
C = ((u_co(2,:)./u_co(1,:)).^4)./u_co(3,:);
D = ((u_ci(2,:)./u_ci(1,:)).^4)./u_ci(3,:);
E = ((Dp_c(2,:)./Dp_c(1,:)).^4)./Dp_c(3,:);
q_cold(3,:) = A./(B + C + D + E);
q_cold(4,:) = tinv(1-(1-p)/2,q_cold(3,:)).*q_cold(2,:);

p_ho = 101325; %Outlet pressure in Pa
p_hi = p_ho + Dp_h(1,:);
rho_h_avg = Dp_h(1,:)./(p_hi./rho(T_hi(1,:)) - p_ho./rho(T_ho(1,:)));

u_hi(1,:) = u(T_hi(1,:));
DT = 1;
du_dT_sat = (u(T_hi(1,:)+DT/2) - u(T_hi(1,:)-DT/2))/DT;
u_hi(2,:) = T_hi(2,:).*du_dT_sat;
u_hi(3,:) = ((u_hi(2,:)./u_hi(1,:)).^4)/(((T_hi(2,:)./T_hi(1,:)).^4)./T_hi(3,:));

u_ho(1,:) = u(T_ho(1,:));
du_dT_sat = (u(T_ho(1,:)+DT/2) - u(T_ho(1,:)-DT/2))/DT;
u_ho(2,:) = T_ho(2,:).*du_dT_sat;
u_ho(3,:) = ((u_ho(2,:)./u_ho(1,:)).^4)/(((T_ho(2,:)./T_ho(1,:)).^4)./T_ho(3,:));

q_hot_specific = u_ho(1,:) - u_hi(1,:) - Dp_h(1,:)./rho_h_avg;
q_hot(1,:) = Mass_flow_h(1,:).*q_hot_specific;

var_q_hot = (q_hot_specific.^2).*(Mass_flow_h(2,:).^2) + (Mass_flow_h(1,:).^2).*((u_ho(2,:).^2) + (u_hi(2,:).^2) + (1./(rho_h_avg.^2)).*(Dp_h(2,:).^2));
q_hot(2,:) = var_q_hot.^0.5;
A = (q_hot(2,:)./q_hot(1,:)).^4;
B = ((Mass_flow_h(2,:)./Mass_flow_h(1,:)).^4)./Mass_flow_h(3,:);
C = ((u_ho(2,:)./u_ho(1,:)).^4)./u_ho(3,:);
D = ((u_hi(2,:)./u_hi(1,:)).^4)./u_hi(3,:);
E = ((Dp_h(2,:)./Dp_h(1,:)).^4)./Dp_h(3,:);
q_hot(3,:) = A./(B + C + D + E);
q_hot(4,:) = tinv(1-(1-p)/2,q_hot(3,:)).*q_hot(2,:);
%mean(q_cold(1,:)./q_hot(1,:))

%UA

DT_1(1,:) = T_hi(1,:) - T_co(1,:);
DT_1(2,:) = (T_hi(2,:).^2 + T_co(2,:).^2).^0.5;
DT_1(3,:) = (DT_1(2,:).^4)./((T_hi(2,:).^4)./T_hi(3,:) + (T_co(2,:).^4)./T_co(3,:));
DT_2(1,:) = T_ho(1,:) - T_ci(1,:);
DT_2(2,:) = (T_ho(2,:).^2 + T_ci(2,:).^2).^0.5;
DT_2(3,:) = (DT_2(2,:).^4)./((T_ho(2,:).^4)./T_ho(3,:) + (T_ci(2,:).^4)./T_ci(3,:));
DT_ln = (DT_2(1,:) - DT_1(1,:))./log(DT_2(1,:)./DT_1(1,:));
dDT_ln_d_DT_1 = -(DT_1(1,:).*log(DT_2(1,:)./DT_1(1,:)) + DT_1(1,:) - DT_2(1,:))./(DT_1(1,:).*(log(DT_2(1,:)./DT_1(1,:)).^2));
dDT_ln_d_DT_2 = (DT_2(1,:).*log(DT_2(1,:)./DT_1(1,:)) + DT_1(1,:) - DT_2(1,:))./(DT_2(1,:).*(log(DT_2(1,:)./DT_1(1,:)).^2));
DT_ln(2,:) = ((dDT_ln_d_DT_1.*DT_1(2,:)).^2 + (dDT_ln_d_DT_2.*DT_2(2,:)).^2).^0.5;
DT_ln(3,:) = (DT_ln(2,:).^4)./((DT_1(2,:).^4)./DT_1(3,:) + (DT_2(2,:).^4)./DT_2(3,:));
DT_ln(4,:) = tinv(1-(1-p)/2,DT_ln(3,:)).*DT_ln(2,:);
UA_cold(1,:) = q_cold(1,:)./DT_ln(1,:);
UA_cold(2,:) = ((q_cold(2,:)./DT_ln(1,:)).^2 + (q_cold(1,:).*DT_ln(2,:)./(DT_ln(1,:).^2)).^2).^0.5;
UA_cold(3,:) = ((UA_cold(2,:)./UA_cold(1,:)).^4)./(((q_cold(2,:)./q_cold(1,:)).^4)./q_cold(3,:) + ((DT_ln(2,:)./DT_ln(1,:)).^4)./DT_ln(3,:));
UA_cold(4,:) = tinv(1-(1-p)/2,UA_cold(3,:)).*UA_cold(2,:);
UA_hot(1,:) = -q_hot(1,:)./DT_ln(1,:);
UA_hot(2,:) = ((q_hot(2,:)./DT_ln(1,:)).^2 + (q_hot(1,:).*DT_ln(2,:)./(DT_ln(1,:).^2)).^2).^0.5;
UA_hot(3,:) = ((UA_hot(2,:)./UA_hot(1,:)).^4)./(((q_hot(2,:)./q_hot(1,:)).^4)./q_hot(3,:) + ((DT_ln(2,:)./DT_ln(1,:)).^4)./DT_ln(3,:));
UA_hot(4,:) = tinv(1-(1-p)/2,UA_hot(3,:)).*UA_hot(2,:);
%{
Delta_dimensionless_Length = 0.01;
dimensionless_Length = (0:Delta_dimensionless_Length:1)';
C_c(1,:) = q_cold(1,:)./(T_co(1,:) - T_ci(1,:));
for i = 1:length(files)
  q_x(:,i) = (q_cold(1,i).*DT_1(1,i)./(DT_1(1,i) - DT_2(1,i))).*(1 - exp(UA_cold(1,i).*dimensionless_Length(:,1).*(DT_2(1,i) - DT_1(1,i))./q_cold(1,i)));
  T_cx(:,i) = T_co(1,i) - q_x(:,i)./C_c(i);
  mu(:,i) = mu_water(T_cx(:,i));
endfor
mu_avg(1,:) = ((mu(1,:) + mu(size(mu,1),:))./2 + sum(mu(2:size(mu,1)-1)))*Delta_dimensionless_Length;
%}
T_c(1,:) = (T_ci(1,:) + T_co(1,:))/2;
mu_avg(1,:) = mu_water(T_c(1,:));
%Perimeter = 11*4*0.003;
Re_c(1,:) = Mass_flow_c(1,:)*d_h*L./(mu_avg(1,:)*V_s);
Re_c(2,:) = Mass_flow_c(2,:)*d_h*L./(mu_avg(1,:)*V_s);
Re_c(3,:) = Mass_flow_c(3,:);
Re_c(4,:) = tinv(1-(1-p)/2,Re_c(3,:)).*Re_c(2,:);
Scientific_Notation_Exponent = floor(log10(max(Re_c(1,:))));
Re_max = ceil(max(Re_c(1,:))/(10^Scientific_Notation_Exponent))*10^Scientific_Notation_Exponent;

Raw_test_data
Thermal_Circuit
Pressure_Drop
Basic_Performance_Parameters
%test
Data_Plot