group(1) = 1;
aux = 2;
for i = 2:length(files)
  comparison = strcmp(files(i-1).name(1:8),files(i).name(1:8));
  if comparison == 0
    group(aux) = i;
    aux++;
  endif
endfor
length_group = length(group);
group(length_group+1) = length(files);




for i = 1:length(group)-1
  section_start = group(i);
  section_end = group(i+1) - 1;
  Header = files(section_start).name(1:8);
  T_header = str2double(Header(1:2));
  Flow_header = strrep(Header(4:8),'_','.');
  Mass_flow_header = str2double(Flow_header);
  
  % Heat Transfer Rate
  figure
  scatter(Mass_flow_c(1,section_start:section_end),q_cold(1,section_start:section_end),'b','Filled')
  hold
  scatter(Mass_flow_c(1,section_start:section_end),-q_hot(1,section_start:section_end),'r','Filled')
  errorbar(Mass_flow_c(1,section_start:section_end),q_cold(1,section_start:section_end),Mass_flow_c(4,section_start:section_end),Mass_flow_c(4,section_start:section_end),q_cold(4,section_start:section_end),q_cold(4,section_start:section_end),'~>o')
  errorbar(Mass_flow_c(1,section_start:section_end),-q_hot(1,section_start:section_end),Mass_flow_c(4,section_start:section_end),Mass_flow_c(4,section_start:section_end),q_hot(4,section_start:section_end),q_hot(4,section_start:section_end),'~>o')
  %title(['Hot stream inlet temperature at ' num2str(T_header) '°C and mass flow at ' strrep(num2str(Mass_flow_header),'.',',') 'kg/s'])
  grid on
  xlabel('Cold Stream Mass Flow [kg/s]')
  ylabel('Heat Transfer [W]')
  axis([0 0.2001 0 5000])
  xl = get(gca,'XTickLabel');
  new_xl = strrep(xl(:),'.',',');
  set(gca,'XTickLabel',new_xl)
  legend({'Cold Stream','Hot Stream'},'FontSize',15,'Location','Southeast')
  set(gca,'FontSize',15)
  figfile = ['Figures\q-' num2str(T_header) '-' strrep(num2str(Mass_flow_header),'.','_') '.png'];
  print(figfile)
  
  % Thermal Conductance
  x = log(Re_c(1,section_start:section_end));
  y = log(UA_cold(1,section_start:section_end));
  [linear_coefficient angular_coefficient R_squared] = linreg(x,y);
  alpha = exp(linear_coefficient);
  beta = angular_coefficient;
  Re = linspace(0,Re_max,10000);
  UA_ls = alpha.*Re.^beta;
  
  figure
  scatter(Re_c(1,section_start:section_end),UA_cold(1,section_start:section_end),'b','Filled')
  hold
  scatter(Re_c(1,section_start:section_end),UA_hot(1,section_start:section_end),'r','Filled')
  errorbar(Re_c(1,section_start:section_end),UA_cold(1,section_start:section_end),Re_c(4,section_start:section_end),Re_c(4,section_start:section_end),UA_cold(4,section_start:section_end),UA_cold(4,section_start:section_end),'~>o')
  errorbar(Re_c(1,section_start:section_end),UA_hot(1,section_start:section_end),Re_c(4,section_start:section_end),Re_c(4,section_start:section_end),UA_hot(4,section_start:section_end),UA_hot(4,section_start:section_end),'~>o')
  grid on
  %plot(Re,UA_ls,'b')
  %title(['Hot stream inlet temperature at ' num2str(T_header) '°C and mass flow at ' strrep(num2str(Mass_flow_header),'.',',') 'kg/s'])
  xlabel('Cold Stream Reynolds Number')
  ylabel('Thermal Conductance [W/K]')
  axis([0 Re_max 0 120])
  legend({'Cold Stream','Hot Stream'},'FontSize',15,'Location','Southeast')
  set(gca,'FontSize',15)
  %inputtext = text(100,5,['UA = ' strrep(num2str(alpha),'.',',') 'Re^{' strrep(num2str(beta),'.',',') '}';'R^2 = ' strrep(num2str(R_squared),'.',',')],'verticalalignment','bottom');
  figfile = ['Figures\UA-' num2str(T_header) '-' strrep(num2str(Mass_flow_header),'.','_') '.png'];
  print(figfile)
  
  % Pressure Drop
  figure
  scatter(Mass_flow_c(1,section_start:section_end),Dp_c(1,section_start:section_end)/1e3,'b','Filled')
  hold
  errorbar(Mass_flow_c(1,section_start:section_end),Dp_c(1,section_start:section_end)/1e3,Mass_flow_c(4,section_start:section_end),Mass_flow_c(4,section_start:section_end),Dp_c(4,section_start:section_end)/1e3,Dp_c(4,section_start:section_end)/1e3,'~>o')
  line([0 0.2],[0 0],'linestyle','-','color','k')
  grid on
  %title(['Hot stream inlet temperature at ' num2str(T_header) '°C and mass flow at ' strrep(num2str(Mass_flow_header),'.',',') 'kg/s'])
  xlabel('Cold Stream Mass Flow Rate [kg/s]')
  ylabel('Pressure Drop [kPa]')
  axis([0 0.2 -10 1.5e2])
  grid on
  xl = get(gca,'XTickLabel');
  new_xl = strrep(xl(:),'.',',');
  set(gca,'XTickLabel',new_xl)
  set(gca,'FontSize',15)
  figfile = ['Figures\Deltap-' num2str(T_header) '-' strrep(num2str(Mass_flow_header),'.','_') '.png'];
  print(figfile)
  %{
  figure
  scatter(Re_h(1,section_start:section_end),Dp_h(1,section_start:section_end))
  axis([0 18000 0 20000])
  %}
endfor

figure
for i = 1:length(group)-1
  section_start = group(i);
  section_end = group(i+1) - 1;
  Header = files(section_start).name(1:8);
  T_header = str2double(Header(1:2));
  Flow_header = strrep(Header(4:8),'_','.');
  Mass_flow_header = str2double(Flow_header);
  if T_header == 70
    c = 'b';
  else
    c = 'r';
  endif
  if Mass_flow_header == 0.1
    m = 'o';
  endif
  if Mass_flow_header == 0.15
    m = 's';
  endif
  if Mass_flow_header == 0.2
    m = '^';
  endif
  scatter(Re_c(1,section_start:section_end),UA_cold(1,section_start:section_end),c,m,'Filled')
  hold on
  legend_names(i,:) = [num2str(T_header) '°C; ' strrep(num2str(Mass_flow_header,'%4.2f'),'.',',') 'kg/s'];
endfor
xlabel('Cold Stream Reynolds Number')
ylabel('Thermal Conductance [W/K]')
axis([0 Re_max 0 120])
grid on
leg = legend(legend_names,'Location','Southeast');
set(leg,'FontSize',15)
set(gca,'FontSize',15)
figfile = ['Figures\UA-overall.png'];
print(figfile)

% Cold stream pressure drop, all test points.
figure
for i = 1:length(group)-1
  section_start = group(i);
  section_end = group(i+1) - 1;
  Header = files(section_start).name(1:8);
  T_header = str2double(Header(1:2));
  Flow_header = strrep(Header(4:8),'_','.');
  Mass_flow_header = str2double(Flow_header);
  if T_header == 70
    c = 'b';
  else
    c = 'r';
  endif
  if Mass_flow_header == 0.1
    m = 'o';
  endif
  if Mass_flow_header == 0.15
    m = 's';
  endif
  if Mass_flow_header == 0.2
    m = '^';
  endif
  scatter(Re_c(1,section_start:section_end),Dp_c(1,section_start:section_end)/1000,c,m,'Filled')
  hold on
  legend_names(i,:) = [num2str(T_header) '°C; ' strrep(num2str(Mass_flow_header,'%4.2f'),'.',',') 'kg/s'];
endfor
xlabel('Cold Stream Reynolds Number')
ylabel('Pressure Drop [kPa]')
axis([0 Re_max 0 150])
leg = legend(legend_names,'Location','Southeast');
grid on
set(leg,'FontSize',15)
set(gca,'FontSize',15)
figfile = ['Figures\Dp-overall.png'];
print(figfile)






% Heat transfer rate, all test points.
figure
for i = 1:length(group)-1
  section_start = group(i);
  section_end = group(i+1) - 1;
  Header = files(section_start).name(1:8);
  T_header = str2double(Header(1:2));
  Flow_header = strrep(Header(4:8),'_','.');
  Mass_flow_header = str2double(Flow_header);
  if T_header == 70
    c = 'b';
  else
    c = 'r';
  endif
  if Mass_flow_header == 0.1
    m = 'o';
  endif
  if Mass_flow_header == 0.15
    m = 's';
  endif
  if Mass_flow_header == 0.2
    m = '^';
  endif
  scatter(Mass_flow_c(1,section_start:section_end),q_cold(1,section_start:section_end),c,m,'Filled')
  hold on
  legend_names(i,:) = [num2str(T_header) '°C; ' strrep(num2str(Mass_flow_header,'%4.2f'),'.',',') 'kg/s'];
endfor
xlabel('Cold Stream Mass Flow Rate [kg/s]')
ylabel('Heat Transfer Rate [W]')
axis([0 0.2 0 5000])
leg = legend(legend_names,'Location','Southeast');
set(leg,'FontSize',15)
set(gca,'FontSize',15)
xl = get(gca,'XTickLabel');
new_xl = strrep(xl(:),'.',',');
set(gca,'XTickLabel',new_xl)
grid on
figfile = ['Figures\q-overall.png'];
print(figfile)