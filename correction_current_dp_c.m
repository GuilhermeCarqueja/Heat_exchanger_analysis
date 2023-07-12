function Correction = correction_current_dp_c(Current)
  fileID = fopen('Pressure_Sensor_Cold.txt');
  Table = textscan(fileID,repmat('%s',11),'Delimiter',' ');
  
  Standard_Current = str2double(strrep(Table{1}(:),',','.'));
  Measured_Current_1 = str2double(strrep(Table{2}(:),',','.'));
  Measured_Current_2 = str2double(strrep(Table{4}(:),',','.'));
  Measured_Current = (Measured_Current_1 + Measured_Current_2)/2;
  Expanded_Uncertainty = str2double(strrep(Table{8}(:),',','.'));
  k = str2double(strrep(Table{10}(:),',','.'));
  Standard_Uncertainty = Expanded_Uncertainty./k;
  Correction_dp = Standard_Current - Measured_Current;
  
  if Current > Measured_Current(1)
    i = 1;
    while Current > Measured_Current(i)
      i++;
    endwhile
    i--;
    Correction(1,1) = Correction_dp(i) + ((Correction_dp(i+1) - Correction_dp(i))/(Measured_Current(i+1) - Measured_Current(i)))*(Current - Measured_Current(i));
    Correction(2,1) = Standard_Uncertainty(i) + ((Standard_Uncertainty(i+1) - Standard_Uncertainty(i))/(Measured_Current(i+1) - Measured_Current(i)))*(Current - Measured_Current(i));
  else
    i = 1;
    Correction(1,1) = Correction_dp(i) + ((Correction_dp(i+1) - Correction_dp(i))/(Measured_Current(i+1) - Measured_Current(i)))*(Current - Measured_Current(i));
    Correction(2,1) = Standard_Uncertainty(i) + ((Standard_Uncertainty(i+1) - Standard_Uncertainty(i))/(Measured_Current(i+1) - Measured_Current(i)))*(Current - Measured_Current(i));
  endif
  fclose(fileID);
endfunction