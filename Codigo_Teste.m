clear
clc

fileID = fopen('grades.txt')
formatSpec = '%s'
N = 4

%C_text = textscan(fileID,formatSpec,N,'Delimiter','|')
%C_data0 = textscan(fileID,'%d %f %f %f')
%frewind(fileID)
C_text = textscan(fileID,formatSpec,N,'Delimiter','|')
C_data1 = textscan(fileID,['%d',repmat('%f',[1,3])],'CollectOutput',1)

%StudentID = reshape(C_data1(1),[1,3])

Headlines = C_text{1}

StudentID = C_data1{1}
Grades = C_data1{2}