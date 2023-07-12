clear
clc
close all

pkg load statistics

%Dimensions
height = 0.00282;
L = 0.549;
total_width = 0.063;
channel_width = 0.003;
communication_length = 0.00401;
N_instances = 45;
fin_width = 0.003;
fin_length = 0.006 - communication_length;

N_channels_1 = floor(total_width/(channel_width + fin_width));
N_channels_2 = ceil(total_width/(channel_width + fin_width));

Vol_fins_1 = N_channels_1*channel_width*fin_length*height;
Vol_fins_2 = N_channels_2*channel_width*fin_length*height;
Vol_Communication = total_width*communication_length*height;
Vol_instance = Vol_fins_1 + 2*Vol_Communication + Vol_fins_2;
V_s = N_instances*Vol_instance + Vol_fins_1 + 2*Vol_Communication;

Area_fins_1 = N_channels_1*2*(height*fin_length + channel_width*fin_length);
Area_fins_2 = N_channels_2*2*(height*fin_length + channel_width*fin_length);
Area_Communication = 2*total_width*communication_length + N_channels_2*fin_width*height + N_channels_1*fin_width*height;
A_instance = Area_fins_1 + 2*Area_Communication + Area_fins_2;
A_s = N_instances*A_instance + Area_fins_1 + 4*(total_width*communication_length + height*communication_length);

d_h = 4*V_s/A_s
A_c = V_s/L

hot_channel_width = 0.00401;
fin_h_width = 0.006 - hot_channel_width;
hot_channel_length = 0.536;
N_hot_channels = 11;
hot_channel_height = 0.00282;
d_h_h = 4*hot_channel_width*hot_channel_height/(2*(hot_channel_width + hot_channel_height))

files = dir('Tests/*.txt');
aux = 0;
for i=1:length(files)
  Address = ['Tests/' files(i).name];
  if Address(16:20) == '0_010'
    aux++;
    Substitution(aux) = i;
  end
  fileID = fopen(Address);
  formatSpec = '%s';
  N_Headline = 2;
  Headline = textscan(fileID,formatSpec,N_Headline,'Delimiter',' ');
  N = 43;
  Test_Data = textscan(fileID,repmat(formatSpec,N),'Delimiter',' ');
  Data_Points = 300;

  T_ci_aux = Test_Data{2}(2:Data_Points+1);
  T_ci_aux = strrep(T_ci_aux,',','.');
  T_ci_raw(:,i) = str2double(T_ci_aux);

  T_co_aux = Test_Data{3}(2:Data_Points+1);
  T_co_aux = strrep(T_co_aux,',','.');
  T_co_raw(:,i) = str2double(T_co_aux);

  T_hi_aux = Test_Data{6}(2:Data_Points+1);
  T_hi_aux = strrep(T_hi_aux,',','.');
  T_hi_raw(:,i) = str2double(T_hi_aux);

  T_ho_aux = Test_Data{7}(2:Data_Points+1);
  T_ho_aux = strrep(T_ho_aux,',','.');
  T_ho_raw(:,i) = str2double(T_ho_aux);
  
  Volumetric_flow_c_aux = Test_Data{32}(2:Data_Points+1);
  Volumetric_flow_c_aux = strrep(Volumetric_flow_c_aux,',','.');
  Volumetric_flow_c_aux = str2double(Volumetric_flow_c_aux); %Volumetric flow in L/s
  Volumetric_flow_c_raw(:,i) = Volumetric_flow_c_aux/1000; %Volumetric flow in m^3/s
  T_c_flowmeter_aux = Test_Data{29}(2:Data_Points+1);
  T_c_flowmeter_aux = strrep(T_c_flowmeter_aux,',','.');
  T_c_flowmeter_raw(:,i) = str2double(T_c_flowmeter_aux);

  Volumetric_flow_h_aux = Test_Data{38}(2:Data_Points+1);
  Volumetric_flow_h_aux = strrep(Volumetric_flow_h_aux,',','.');
  Volumetric_flow_h_aux = str2double(Volumetric_flow_h_aux); %Volumetric flow in L/s
  Volumetric_flow_h_raw(:,i) = Volumetric_flow_h_aux/1000; %Volumetric flow in m^3/s
  T_h_flowmeter_aux = Test_Data{30}(2:Data_Points+1);
  T_h_flowmeter_aux = strrep(T_h_flowmeter_aux,',','.');
  T_h_flowmeter_raw(:,i) = str2double(T_h_flowmeter_aux);
  
  Current_Deltap_c_aux = Test_Data{8}(2:Data_Points+1);
  Current_Deltap_c_aux = strrep(Current_Deltap_c_aux,',','.');
  Current_Deltap_c_raw(:,i) = str2double(Current_Deltap_c_aux);
  
  Current_Deltap_h_aux = Test_Data{9}(2:Data_Points+1);
  Current_Deltap_h_aux = strrep(Current_Deltap_h_aux,',','.');
  Current_Deltap_h_raw(:,i) = str2double(Current_Deltap_h_aux);
  
  fclose(Address);
end

p = 0.9545;


T_ci(1,:) = mean(T_ci_raw);
Std_T_ci_raw = std(T_ci_raw);
u_DIN_uncertainty = DIN_one_third(T_ci(1,:))/(3^0.5);
Std_T_ci = Std_T_ci_raw/((size(T_ci_raw,1))^0.5);
T_ci(2,:) = (Std_T_ci.^2 + u_DIN_uncertainty.^2).^0.5;
T_ci(3,:) = (T_ci(2,:).^4)./((Std_T_ci(1,:).^4)/(size(T_ci_raw,1) - 1));
T_ci(4,:) = tinv(1-(1-p)/2,T_ci(3,:)).*T_ci(2,:);

T_co(1,:) = mean(T_co_raw);
Std_T_co_raw = std(T_co_raw);
u_DIN_uncertainty = DIN_one_third(T_co(1,:))/(3^0.5);
Std_T_co = Std_T_co_raw/((size(T_co_raw,1))^0.5);
T_co(2,:) = (Std_T_co.^2 + u_DIN_uncertainty.^2).^0.5;
T_co(3,:) = (T_co(2,:).^4)./((Std_T_co(1,:).^4)/(size(T_co_raw,1) - 1));
T_co(4,:) = tinv(1-(1-p)/2,T_co(3,:)).*T_co(2,:);

T_hi(1,:) = mean(T_hi_raw);
Std_T_hi_raw = std(T_hi_raw);
u_DIN_uncertainty = DIN_one_third(T_hi(1,:))/(3^0.5);
Std_T_hi = Std_T_hi_raw/((size(T_hi_raw,1))^0.5);
T_hi(2,:) = (Std_T_hi.^2 + u_DIN_uncertainty.^2).^0.5;
T_hi(3,:) = (T_hi(2,:).^4)./((Std_T_hi(1,:).^4)/(size(T_hi_raw,1) - 1));
T_hi(4,:) = tinv(1-(1-p)/2,T_hi(3,:)).*T_hi(2,:);

T_ho(1,:) = mean(T_ho_raw);
Std_T_ho_raw = std(T_ho_raw);
u_DIN_uncertainty = DIN_one_third(T_ho(1,:))/(3^0.5);
Std_T_ho = Std_T_ho_raw/((size(T_ho_raw,1))^0.5);
T_ho(2,:) = (Std_T_ho.^2 + u_DIN_uncertainty.^2).^0.5;
T_ho(3,:) = (T_ho(2,:).^4)./((Std_T_ho(1,:).^4)/(size(T_ho_raw,1) - 1));
T_ho(4,:) = tinv(1-(1-p)/2,T_ho(3,:)).*T_ho(2,:);


Volumetric_flow_c = mean(Volumetric_flow_c_raw); %Average volumetric flow
Std_Volumetric_flow_c_raw = std(Volumetric_flow_c_raw); %Standard deviation
Std_Volumetric_flow_c = Std_Volumetric_flow_c_raw/((size(Volumetric_flow_c_raw,1))^0.5); %Standard deviation of the mean value
df_Volumetric_flow_c = size(Volumetric_flow_c_raw,1) - 1; %Degrees of freedom
for aux = 1:length(Volumetric_flow_c)
  Corr(1:3,aux) = correction_flow_c(Volumetric_flow_c(aux));
end
Vol_flow_c = Volumetric_flow_c + Corr(1,:); %Corrected values of volumetric flow
Std_Vol_flow_c = (Std_Volumetric_flow_c.^2 + Corr(2,:).^2).^0.5;
nu_Vol_flow_c = (Std_Vol_flow_c.^4)./((Std_Volumetric_flow_c.^4)./df_Volumetric_flow_c + (Corr(2,:).^4)./Corr(3,:));
t_Student = tinv(1-(1-p)/2,nu_Vol_flow_c);
Standard_Uncertainty_Vol_flow_c = t_Student.*Std_Vol_flow_c; %Standard Uncertainty
T_c_flowmeter = mean(T_c_flowmeter_raw);
rho_c_flowmeter = rho(T_c_flowmeter);
Mass_flow_c(1,:) = rho_c_flowmeter.*Vol_flow_c;
Mass_flow_c(2,:) = rho_c_flowmeter.*Std_Vol_flow_c;
Mass_flow_c(3,:) = nu_Vol_flow_c;
Mass_flow_c(4,:) = rho_c_flowmeter.*Standard_Uncertainty_Vol_flow_c;
Evaluated_Mass_flow = [8.71650E-03	8.69063E-03	8.68117E-03	9.51895E-03	9.59032E-03	8.88002E-03];
Std_Evaluated_Mass_flow = [1.67712E-05	9.06442E-06	2.54236E-05	8.79184E-06	1.16679E-05	1.04192E-05];
df_Evaluated_Mass_flow = repmat(4,1,length(Evaluated_Mass_flow));
for aux = 1:length(Substitution)
  aux;
  Substitution(aux);
  Mass_flow_c(1,Substitution(aux)) = Evaluated_Mass_flow(aux);
  Mass_flow_c(2,Substitution(aux)) = Std_Evaluated_Mass_flow(aux);
  Mass_flow_c(3,Substitution(aux)) = df_Evaluated_Mass_flow(aux);
  Mass_flow_c(4,Substitution(aux)) = tinv(1-(1-p)/2,df_Evaluated_Mass_flow(aux))*Std_Evaluated_Mass_flow(aux);
end

Volumetric_flow_h = mean(Volumetric_flow_h_raw); %Average volumetric flow
Std_Volumetric_flow_h_raw = std(Volumetric_flow_h_raw); %Standard deviation
Std_Volumetric_flow_h = Std_Volumetric_flow_h_raw/((size(Volumetric_flow_h_raw,1))^0.5); %Standard deviation of the mean value
df_Volumetric_flow_h = size(Volumetric_flow_h_raw,1) - 1; %Degrees of freedom
for aux = 1:length(Volumetric_flow_h)
  Corr(1:3,aux) = correction_flow_h(Volumetric_flow_h(aux));
end
Vol_flow_h = Volumetric_flow_h + Corr(1,:); %Corrected values of volumetric flow
Std_Vol_flow_h = (Std_Volumetric_flow_h.^2 + Corr(2,:).^2).^0.5;
nu_Vol_flow_h = (Std_Vol_flow_h.^4)./((Std_Volumetric_flow_h.^4)./df_Volumetric_flow_h + (Corr(2,:).^4)./Corr(3,:));
p = 0.9545;
t_Student = tinv(1-(1-p)/2,nu_Vol_flow_h);
Standard_Uncertainty_Vol_flow_h = t_Student.*Std_Vol_flow_h;
T_h_flowmeter = mean(T_h_flowmeter_raw);
rho_h_flowmeter = rho(T_h_flowmeter);
Mass_flow_h(1,:) = rho_h_flowmeter.*Vol_flow_h;
Mass_flow_h(2,:) = rho_h_flowmeter.*Std_Vol_flow_h;
Mass_flow_h(3,:) = nu_Vol_flow_h;
Mass_flow_h(4,:) = rho_h_flowmeter.*Standard_Uncertainty_Vol_flow_h;

Current_Deltap_c(1,:) = mean(Current_Deltap_c_raw)*1000; %Average sensor current in mA
Std_Current_Deltap_c_raw = std(Current_Deltap_c_raw)*1000; %Standard deviation in mA
Current_Deltap_c(2,:) = Std_Current_Deltap_c_raw/((size(Current_Deltap_c_raw,1))^0.5); %Standard deviation of the mean value in mA
Current_Deltap_c(3,:) = size(Current_Deltap_c_raw,1) - 1; %Degrees of freedom
for aux = 1:size(Current_Deltap_c,2)
  Corr_dp(1:2,aux) = correction_current_dp_c(Current_Deltap_c(1,i));
end
Current_Dp_c(1,:) = Current_Deltap_c(1,:) + Corr_dp(1,:); %Corrected values of current in mA
Current_Dp_c(2,:) = (Current_Deltap_c(2,:).^2 + Corr_dp(2,:).^2).^0.5;
Current_Dp_c(3,:) = (Current_Dp_c(2,:).^4)/((Current_Deltap_c(2,:).^4)./Current_Deltap_c(3,:));
for aux = 1:size(Current_Dp_c,2)
  Dp_c(1:2,aux) = current_to_dp_c(Current_Dp_c(1:2,aux));
end
Dp_c(3,:) = Current_Dp_c(3,:);
Dp_c(4,:) = tinv(1-(1-p)/2,Dp_c(3,:)).*Dp_c(2,:);

Current_Deltap_h(1,:) = mean(Current_Deltap_h_raw)*1000; %Average sensor current in mA
Std_Current_Deltap_h_raw = std(Current_Deltap_h_raw)*1000; %Standard deviation in mA
Current_Deltap_h(2,:) = Std_Current_Deltap_h_raw/((size(Current_Deltap_h_raw,1))^0.5); %Standard deviation of the mean value in mA
Current_Deltap_h(3,:) = size(Current_Deltap_h_raw,1) - 1; %Degrees of freedom
for aux = 1:size(Current_Deltap_h,2)
  Dp_h(1:2,aux) = current_to_dp_h(Current_Deltap_h(1:2,aux));
end
Dp_h(3,:) = (Dp_h(2,:).^4)/((Current_Deltap_c(2,:).^4)./Current_Deltap_c(3,:));
Dp_h(4,:) = tinv(1-(1-p)/2,Dp_h(3,:)).*Dp_h(2,:);

q_and_UA

close all