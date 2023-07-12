Area_goodness_factor(1,:) = j_c_plot./f_c_plot;
Operating_parameter(1,:) = Re_c_plot./(d_h*(Area_goodness_factor.^(1/2)));
sigma_max = 3/4;
P_A(1,:) = Area_goodness_factor.^(-1/2);
P_f(1,:) = (1/sigma_max)*P_A(1,:);
P_fV(1,:) = d_h*(f_c_plot./(j_c_plot.^3)).^(1/2);
P_V(1,:) = (1/sigma_max)*P_fV(1,:);

Re_sc = linspace(1800,1e5,1e3);
Pr = mu_water(50)*cp_water(50)/k_water(50);
for i = 1:length(Re_sc)
  f_sc(1,i) = f_D(0,Re_sc(1,i))/4;
endfor
Nu_sc = (f_sc/8).*(Re_sc - 1000)*Pr./(1 + 12.7*sqrt(f_sc/8)*(Pr^(2/3) - 1));
j_sc = Nu_sc./(Re_sc*Pr^(1/3));
h_sc = Nu_sc*k_water(50)/3e-3;

Re_zz = linspace(1800,1e5,1e3);
Nu_zz = 0.1696*(Re_zz.^0.629)*Pr^0.317
j_zz = Nu_zz./(Re_zz*Pr^(1/3));
f_zz = 0.1924*Re_zz.^-0.091;

Po_sc(1,:) = Re_sc./(3e-3*(j_sc./f_sc).^(1/2));
PA_sc(1,:) = (f_sc./j_sc).^(1/2);
Pf_sc = PA_sc;
PV_sc(1,:) = 3e-3*(f_sc./(j_sc.^3)).^(1/2);

h_zz = 0.003;
g_f = (1.31/0.94)*h_zz;
theta = 52*pi/180;
g_t = g_f/cos(theta);
dh_zz = (2*g_t*h_zz*cos(theta))/(h_zz + g_t)
Po_zz(1,:) = Re_zz./(3e-3*(j_zz./f_zz).^(1/2));
PA_zz(1,:) = (f_zz./j_zz).^(1/2);
Pf_zz = PA_zz;
PV_zz(1,:) = dh_zz*(f_zz./(j_zz.^3)).^(1/2);

figure
scatter(Re_c_plot(1,:),f_c_plot(1,:),'Filled')
axis([2000 5500 0 0.5])
xlabel('Cold Stream Reynolds Number')
ylabel('f')
hold
Remin = 2000;
Remax = 5500;
Re_lr = linspace(400,Remax,1000);
plot([Remin Remax],[mean(f_c_plot) mean(f_c_plot)],'--','Color','k')

x = log(Re_c_plot(1,:));
y = log(f_c_plot(1,:));
[linear_coefficient angular_coefficient R_squared] = linreg(x,y);
alpha = exp(linear_coefficient)
beta = angular_coefficient
f_lr = alpha*Re_lr.^beta;
plot(Re_lr,f_lr,'Color','k')
leg = legend('Experimental Values','Mean Value','Linear Regression','Location','Southeast');
inputtext2 = text(Remax,0.3,['f = ' strrep(num2str(alpha),'.',',') 'Re^{' strrep(num2str(beta),'.',',') '}'],'HorizontalAlignment','Right');
set(inputtext2,'FontSize',15)
set(leg,'FontSize',15)
set(gca,'FontSize',15)
grid on
print('Figures\Dimensionless_Pressure_Drop.png')

% Colburn factor
figure
scatter(Re_c(1,:),j_c(1,:),'Filled')
xlabel('Cold Stream Reynolds Number')
ylabel('j')
x = log(Re_c(1,:));
y = log(j_c(1,:));
[linear_coefficient angular_coefficient R_squared] = linreg(x,y);
alpha_j = exp(linear_coefficient);
beta_j = angular_coefficient;
j_lr = alpha_j.*Re_lr.^beta_j;
hold
plot(Re_lr,j_lr,'Color','k')
axis([0 Remax 0 0.03])
yl = get(gca,'YTickLabel');
new_yl = strrep(yl,'.',',');
set(gca,'YTickLabel',new_yl)
%plot(Re_sc,j_sc,'--','Color','k')
inputtext = text(3500,0.025,['j = ' strrep(num2str(alpha_j),'.',',') 'Re^{' strrep(num2str(beta_j),'.',',') '}';'R^2 = ' strrep(num2str(R_squared),'.',',')],'verticalalignment','bottom');
set(inputtext,'FontSize',15)
set(gca,'FontSize',15)
grid on
print('Figures\j.png')

% Area goodness factor
figure
axis([Remin Remax 0 0.2])
xlabel('Cold Stream Reynolds Number')
ylabel('j/f')
hold
area_goodness_factor_linear_regression = j_lr./f_lr;
area_goodness_factor_sc = j_sc./f_sc;
area_goodness_factor_zz = j_zz./f_zz;
plot(Re_lr,area_goodness_factor_linear_regression,'Color','k','LineWidth',2)
plot(Re_sc,area_goodness_factor_sc,'--','Color','b','LineWidth',2)
plot(Re_zz,area_goodness_factor_zz,'-.','Color','r','LineWidth',2)
leg = legend('Present work','Straight channels','Zigzag channels','Location','Northwest');
scatter(Re_c_plot,Area_goodness_factor,'b','Filled')
yl = get(gca,'YTickLabel');
new_yl = strrep(yl,'.',',');
set(gca,'YTickLabel',new_yl)
set(gca,'FontSize',15)
set(leg,'FontSize',15)
grid on
print('Figures\Area_goodness_factor.png')

% Operating parameter as a function of Reynolds number with experimental data points
figure
operating_parameter_linear_regression = Re_lr./(d_h*(j_lr./f_lr).^(1/2));
plot(Re_lr,operating_parameter_linear_regression/1e6,'Color','k','LineWidth',2)
hold
plot(Re_sc,Po_sc/1e6,'--','Color','b','LineWidth',2)
plot(Re_zz,Po_zz/1e6,'-.','Color','r','LineWidth',2)
scatter(Re_c_plot,Operating_parameter/1e6,'b','Filled')
leg = legend('Present work','Straight channels','Zigzag channels','Location','Northwest');
axis([0 Remax 0 11])
xlabel('Cold Stream Reynolds Number')
ylabel('Operating Parameter [10^6m^{-1}]')
set(leg,'FontSize',15)
set(gca,'FontSize',15)
grid on
print('Figures\Operating_Parameter.png')

%Area goodness factor as a function of the operating parameter
figure
scatter(Operating_parameter,Area_goodness_factor,'Filled')
axis([0 11e6 0 0.2])
xlabel('Operating Parameter')
ylabel('j/f')
hold
area_goodness_factor_linear_regression = j_lr./f_lr;
area_goodness_factor_sc = j_sc./f_sc;
area_goodness_factor_zz = j_zz./f_zz;
plot(operating_parameter_linear_regression,area_goodness_factor_linear_regression,'Color','k')
plot(Po_sc,area_goodness_factor_sc,'--','Color','b','LineWidth',2)
plot(Po_zz,area_goodness_factor_zz,'-.','Color','r','LineWidth',2)
leg = legend('Present work','Straight channels','Zigzag channels','Location','Northwest');
yl = get(gca,'YTickLabel');
new_yl = strrep(yl,'.',',');
set(gca,'YTickLabel',new_yl)
set(gca,'FontSize',15)
set(leg,'FontSize',15)
%print('Figures\Area_goodness_factor.png')

Mass_flow = 1;
Re_min = 2000
Re_max = 5500
rho_water = rho(50);
Re_plot = linspace(Re_min,Re_max,1e2);
L_min = 0.1;
L_max = 1;
Length = linspace(L_min,L_max,1e2);
f_plot3 = alpha*Re_max^beta;
V_plot3 = Re_max*mu_water(50)/(rho_water*d_h);
A_plot3 = Mass_flow/(rho_water*V_plot3);
A_min = A_plot3;
for j = 1:length(Length)
  Dp_plot(j) = (4*Length(j)/d_h)*f_plot3*0.5*rho_water*V_plot3^2;
end
figure
plot3(A_plot3*ones(1,length(Length)),Length,Dp_plot/1e3,'Color','k')
hold
f_plot3 = alpha*Re_min^beta;
V_plot3 = Re_min*mu_water(50)/(rho_water*d_h);
A_plot3 = Mass_flow/(rho_water*V_plot3);
for j = 1:length(Length)
  Dp_plot(j) = (4*Length(j)/d_h)*f_plot3*0.5*rho_water*V_plot3^2;
end
plot3(A_plot3*ones(1,length(Length)),Length,Dp_plot/1e3,'Color','k')
for i = 1:length(Re_plot)
  V_plot3 = Re_plot(i)*mu_water(50)/(rho_water*d_h);
  A_plot3(i) = Mass_flow/(rho_water*V_plot3);
  f_plot3 = alpha*Re_plot(i)^beta;
  Dp_plot3(i) = (4*L_min/d_h)*f_plot3*0.5*rho_water*V_plot3^2;
end
plot3(A_plot3,L_min*ones(1,length(A_plot3)),Dp_plot3/1e3,'Color','k')
for i = 1:length(Re_plot)
  V_plot3 = Re_plot(i)*mu_water(50)/(rho_water*d_h);
  A_plot3(i) = Mass_flow/(rho_water*V_plot3);
  f_plot3 = alpha*Re_plot(i)^beta;
  Dp_plot3(i) = (4*L_max/d_h)*f_plot3*0.5*rho_water*V_plot3^2;
end
plot3(A_plot3,L_max*ones(1,length(A_plot3)),Dp_plot3/1e3,'Color','k')
Aplot3 = A_plot3;
grid on
Dp = 4e4;
for i = 1:length(Length)
  f_old = mean(f_c_plot);
  V_plot = (Dp/(2*rho_water*Length(i)*f_old/d_h))^0.5;
  Re = rho_water*V_plot*d_h/mu_water(50);
  f_plot = alpha.*Re_plot(i).^beta;
  while abs(f_plot - f_old)/f_old > 1e-10
    f_old = f_plot;
    V_plot = (Dp/(2*rho_water*Length(i)*f_old/d_h))^0.5;
    Re = rho_water*V_plot*d_h/mu_water(50);
    f_plot = alpha.*Re_plot(i).^beta;
  end
  V_plot = (Dp/(2*rho_water*Length(i)*f_plot/d_h))^0.5;
  A_plot3(i) = Mass_flow/(rho_water*V_plot);
end
aux = 0;
for i = 1:length(A_plot3)
  if A_plot3(i) >= A_min
    aux++;
    A_plot_3(aux) = A_plot3(i);
    Length_plot_3(aux) = Length(i);
  end
end
plot3(A_plot_3,Length_plot_3,Dp*ones(1,length(A_plot_3))/1e3,'LineWidth',2,'Color','k')
view(45,30)
xlabel('A_c [m^2]')
ylabel('L [m]')
zlabel('\Delta p [kPa]')
set(gca,'FontSize',15)
Omega = (A_s/L)/(A_c^0.5);
N = 2e-2;
for i = 1:length(Aplot3)
  L_plot3(i) = Aplot3(i)^beta_j*N/((k_water(50)/(mu_water(50)*cp_water(50)))^(2/3)*alpha_j*(Mass_flow*d_h/mu_water(50))^beta_j*Omega);
  V_plot3 = Mass_flow/(rho_water*Aplot3(i));
  Re_plot3 = Mass_flow*d_h/(Aplot3(i)*mu_water(50));
  f_plot3 = alpha*Re_plot3^beta;
  Dp_plot3(i) = (4*L_plot3(i)/d_h)*f_plot3*0.5*rho_water*V_plot3^2;
end
plot3(Aplot3,L_plot3,Dp_plot3/1e3,'LineWidth',2,'Color','b')
N = 3e-2;
for i = 1:length(Aplot3)
  L_plot3(i) = Aplot3(i)^beta_j*N/((k_water(50)/(mu_water(50)*cp_water(50)))^(2/3)*alpha_j*(Mass_flow*d_h/mu_water(50))^beta_j*Omega);
  V_plot3 = Mass_flow/(rho_water*Aplot3(i));
  Re_plot3 = Mass_flow*d_h/(Aplot3(i)*mu_water(50));
  f_plot3 = alpha*Re_plot3^beta;
  Dp_plot3(i) = (4*L_plot3(i)/d_h)*f_plot3*0.5*rho_water*V_plot3^2;
end
plot3(Aplot3,L_plot3,Dp_plot3/1e3,'LineWidth',2,'Color','b')
xl = get(gca,'XTickLabel');
new_xl = strrep(xl(:),'.',',');
set(gca,'XTickLabel',new_xl)
yl = get(gca,'YTickLabel');
new_yl = strrep(yl(:),'.',',');
set(gca,'YTickLabel',new_yl)
print('Figures\Delta_p_surface.png')

% Operating parameter as a function of Reynolds number
figure
semilogx(Re_lr,operating_parameter_linear_regression/1e6,'Color','k','LineWidth',2)
hold
semilogx(Re_sc,Po_sc/1e6,'--','Color','b','LineWidth',2)
semilogx(Re_zz,Po_zz/1e6,'-.','Color','r','LineWidth',2)
leg = legend('Present work','Straight channels','Zigzag channels','Location','Northwest');
axis([500 15000 0 10])
xlabel('Cold Stream Reynolds Number')
ylabel('Operating Parameter [10^6m^{-1}]')
set(leg,'FontSize',15)
set(gca,'FontSize',15)
grid on
print('Figures\Operating_Parameter_semilogx.png')

% Throughflow area parameter
figure
throughflow_area_parameter_linear_regression = (f_lr./j_lr).^(1/2);
plot(operating_parameter_linear_regression/1e6,throughflow_area_parameter_linear_regression,'Color','k','LineWidth',2)
hold
plot(Po_sc/1e6,PA_sc,'--','Color','b','LineWidth',2)
plot(Po_zz/1e6,PA_zz,'-.','Color','r','LineWidth',2)
scatter(Operating_parameter/1e6,P_A,'b','Filled')
axis([0 10 0 11])
xlabel('Operating Parameter [10^6m^{-1}]')
ylabel('Throughflow Area Parameter')
leg = legend('Present work','Straight channels','Zigzag channels','Location','Northwest');
set(leg,'FontSize',15)
set(gca,'FontSize',15)
grid on
print('Figures\Throughflow_Area_Parameter.png')

% Face area parameter
figure
face_area_parameter_linear_regression = (1/sigma_max)*throughflow_area_parameter_linear_regression
plot(operating_parameter_linear_regression/1e6,face_area_parameter_linear_regression,'Color','k','LineWidth',2)
hold
plot(Po_sc/1e6,Pf_sc,'--','Color','b','LineWidth',2)
plot(Po_zz/1e6,Pf_zz,'-.','Color','r','LineWidth',2)
scatter(Operating_parameter/1e6,P_f,'b','Filled')
axis([0 10 0 11])
xlabel('Operating Parameter [10^6m^{-1}]')
ylabel('Face Area Parameter')
leg = legend('Present work','Straight channels','Zigzag channels','Location','Southwest');
set(leg,'FontSize',15)
set(gca,'FontSize',15)
grid on
print('Figures\Face_Area_Parameter.png')

% Fluid Volume parameter
figure
fluid_volume_parameter_linear_regression = d_h*(f_lr./(j_lr.^3)).^(1/2);
plot(operating_parameter_linear_regression/1e6,fluid_volume_parameter_linear_regression,'Color','k','LineWidth',2)
hold
plot(Po_sc/1e6,PV_sc,'--','Color','b','LineWidth',2)
plot(Po_zz/1e6,PV_zz,'-.','Color','r','LineWidth',2)
scatter(Operating_parameter/1e6,P_fV,'b','Filled')
axis([0 11 0 10])
xlabel('Operating Parameter [10^6m^{-1}]')
ylabel('Fluid Volume Parameter [m]')
leg = legend('Present work','Straight channels','Zigzag channels','Location','Northeast');
set(leg,'FontSize',15)
set(gca,'FontSize',15)
grid on
print('Figures\Fluid_Volume_Parameter.png')

% Volume parameter
figure
volume_parameter_linear_regression = (1/sigma_max)*fluid_volume_parameter_linear_regression;
plot(operating_parameter_linear_regression/1e6,volume_parameter_linear_regression,'Color','k','LineWidth',2)
hold
plot(Po_sc/1e6,PV_sc,'--','Color','b','LineWidth',2)
plot(Po_zz/1e6,PV_zz,'-.','Color','r','LineWidth',2)
scatter(Operating_parameter/1e6,P_V,'b','Filled')
axis([0 11 0 10])
xlabel('Operating Parameter [10^6m^{-1}]')
ylabel('Volume Parameter [m]')
leg = legend('Present work','Straight channels','Zigzag channels','Location','Northeast');
set(leg,'FontSize',15)
set(gca,'FontSize',15)
grid on
print('Figures\Volume_Parameter.png')