filename = 'Raw_test_data.txt'
fid = fopen(filename,'w');

for i = 1:length(files)
  Name_aux = files(i).name;
  Name = Name_aux(1:14);
  
  exponent = floor(log10(T_ci(4,i))) - 1;
  a1 = round(T_ci(1,i)/10^exponent)*10^exponent;
  a1_str = strrep(num2str(a1),'.',',');
  if a1_str(end - 1) == ','
    a1_str(end + 1) = '0';
  end
  a2 = round(T_ci(4,i)/10^exponent)*10^exponent;
  a2_str = strrep(num2str(round(T_ci(4,i)/10^exponent)*10^exponent),'.',',');
  if a2_str(end - 1) == ','
    a2_str(end + 1) = '0';
  end
  
  exponent = floor(log10(T_co(4,i))) - 1;
  a3 = round(T_co(1,i)/10^exponent)*10^exponent;
  a3_str = strrep(num2str(a3),'.',',');
  if a3_str(end - 1) == ','
    a3_str(end + 1) = '0';
  end
  if length(a3_str) == 2
    a3_str(3) = ',';
    a3_str(4) = '0';
    a3_str(5) = '0';
  end
  a4 = round(T_co(4,i)/10^exponent)*10^exponent;
  a4_str = strrep(num2str(a4),'.',',');
  if a4_str(end - 1) == ','
    a4_str(end + 1) = '0';
  end
  
  exponent = floor(log10(Mass_flow_c(4,i))) - 1;
  a5 = round(Mass_flow_c(1,i)/10^exponent)*10^exponent;
  a5_str = strrep(num2str(a5),'.',',');
  if a5_str(end - 1) == ','
    a5_str(end + 1) = '0';
  end
  a6 = round(Mass_flow_c(4,i)/10^exponent)*10^exponent;
  a6_str = strrep(num2str(round(Mass_flow_c(4,i)/10^exponent)*10^exponent),'.',',');
  if a6_str(end - 1) == ','
    a6_str(end + 1) = '0';
  end
  
  exponent = floor(log10(Dp_c(4,i)*1e-3)) - 1;
  a7 = round(Dp_c(1,i)*1e-3/10^exponent)*10^exponent;
  a7_str = strrep(num2str(a7),'.',',');
  if length(a7_str) == 1
    a7_str(2) = ',';
    a7_str(3) = '0';
  end
  
  a8 = round(Dp_c(4,i)*1e-3/10^exponent)*10^exponent;
  a8_str = strrep(num2str(a8),'.',',');
  fdisp(fid,[Name(1:4) '\_' Name(6:10) '\_' Name(12:14) ' & $' a1_str ' \pm ' a2_str '$ & $' a3_str ' \pm ' a4_str '$ & $' a5_str ' \pm ' a6_str '$ & $' a7_str ' \pm ' a8_str '$ \\'])
endfor









fdisp(fid,' ')
for i = 1:length(files)
  Name_aux = files(i).name;
  Name = Name_aux(1:14);
  
  exponent = floor(log10(T_hi(4,i))) - 1;
  a1 = round(T_hi(1,i)/10^exponent)*10^exponent;
  a1_str = strrep(num2str(a1),'.',',');
  if a1_str(end - 1) == ','
    a1_str(end + 1) = '0';
  end
  a2 = round(T_hi(4,i)/10^exponent)*10^exponent;
  a2_str = strrep(num2str(round(T_hi(4,i)/10^exponent)*10^exponent),'.',',');
  if a2_str(end - 1) == ','
    a2_str(end + 1) = '0';
  end
  
  exponent = floor(log10(T_ho(4,i))) - 1;
  a3 = round(T_ho(1,i)/10^exponent)*10^exponent;
  a3_str = strrep(num2str(a3),'.',',');
  if a3_str(end - 1) == ','
    a3_str(end + 1) = '0';
  end
  if length(a3_str) == 2
    a3_str(3) = ',';
    a3_str(4) = '0';
    a3_str(5) = '0';
  end
  a4 = round(T_ho(4,i)/10^exponent)*10^exponent;
  a4_str = strrep(num2str(a4),'.',',');
  if a4_str(end - 1) == ','
    a4_str(end + 1) = '0';
  end
  
  exponent = floor(log10(Mass_flow_h(4,i))) - 1;
  a5 = round(Mass_flow_h(1,i)/10^exponent)*10^exponent;
  a5_str = strrep(num2str(a5),'.',',');
  if a5_str(end - 1) == ','
    a5_str(end + 1) = '0';
  end
  a6 = round(Mass_flow_h(4,i)/10^exponent)*10^exponent;
  a6_str = strrep(num2str(round(Mass_flow_h(4,i)/10^exponent)*10^exponent),'.',',');
  if a6_str(end - 1) == ','
    a6_str(end + 1) = '0';
  end
  
  exponent = floor(log10(Dp_h(4,i))) - 1;
  a7 = round(Dp_h(1,i)/10^exponent)*10^exponent;
  a7_str = strrep(num2str(a7),'.',',');
  
  
  a8 = round(Dp_h(4,i)/10^exponent)*10^exponent;
  a8_str = strrep(num2str(a8),'.',',');
  
  fdisp(fid,[Name(1:4) '\_' Name(6:10) '\_' Name(12:14) ' & $' a1_str ' \pm ' a2_str '$ & $' a3_str ' \pm ' a4_str '$ & $' a5_str ' \pm ' a6_str '$ & $' a7_str ' \pm ' a8_str '$ \\'])
endfor


fclose(fid);