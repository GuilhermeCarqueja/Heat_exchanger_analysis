clear all
clc
close all

tic
L = 0.003;
N_divisions = 5;
Delta = L/(2*N_divisions);
Biot_h = linspace(0.1,5,40);
Biot_c = linspace(0.1,5,40);
k_solid = 15;
printf('Creating Mesh\n')
%Coordinates
Nx = round(2*L/Delta);
Ny = round(L/Delta);
Nz = round(3*L/Delta);
x_coordinates = linspace(Delta/2,2*L-Delta/2,Nx);
y_coordinates = linspace(Delta/2,L-Delta/2,Ny);
z_coordinates = linspace(Delta/2,3*L-Delta/2,Nz);

Elements = zeros(Nx,Ny,Nz);
size(Elements)
Elements(:,1:Ny/2,1:Nz/3) = 1;
Elements(:,:,Nz/3 + 1:Nz*2/3) = 1;
Elements(1:Nx/4,Ny/2 + 1:Ny,Nz*2/3 + 1:Nz) = 1;
Elements(Nx*3/4 + 1:Nx,1:Ny/2,Nz*2/3 + 1:Nz) = 1;
N_elements = nnz(Elements)


Element_ID(:,1) = (1:N_elements)';
Named_elements = zeros(Nx+2,Ny+2,Nz+2);
size(Element_ID)
aux = 1;
for k = 1:Nz
  for j = 1:Ny
    for i = 1:Nx
      if Elements(i,j,k) > 0.5
        Element_ID(aux,2:4) = [i j k];
        Named_elements(i+1,j+1,k+1) = aux;
        aux++;
      endif
    endfor
  endfor
endfor
%Element_ID is a matrix that relates every element to its position inside the domain.
%The first column is the element ID
%The second column is the x position
%The third column is the y position
%The fourth column is the z position

printf('Element Connectivity\n')
Element_connectivity(:,1) = (1:N_elements)';
for i = 1:size(Element_ID,1)
  Element_east = [Element_ID(i,2)+1 Element_ID(i,3) Element_ID(i,4)];
  Element_connectivity(i,2) = Named_elements(Element_east(1)+1,Element_east(2)+1,Element_east(3)+1);
  
  Element_west = [Element_ID(i,2)-1 Element_ID(i,3) Element_ID(i,4)];
  Element_connectivity(i,3) = Named_elements(Element_west(1)+1,Element_west(2)+1,Element_west(3)+1); 
  
  Element_north = [Element_ID(i,2) Element_ID(i,3)+1 Element_ID(i,4)];
  Element_connectivity(i,4) = Named_elements(Element_north(1)+1,Element_north(2)+1,Element_north(3)+1);
  
  Element_south = [Element_ID(i,2) Element_ID(i,3)-1 Element_ID(i,4)];
  Element_connectivity(i,5) = Named_elements(Element_south(1)+1,Element_south(2)+1,Element_south(3)+1);
  
  Element_front = [Element_ID(i,2) Element_ID(i,3) Element_ID(i,4)+1];
  Element_connectivity(i,6) = Named_elements(Element_front(1)+1,Element_front(2)+1,Element_front(3)+1);
  
  Element_back = [Element_ID(i,2) Element_ID(i,3) Element_ID(i,4)-1];
  Element_connectivity(i,7) = Named_elements(Element_back(1)+1,Element_back(2)+1,Element_back(3)+1);
endfor

printf('\nCreating Linear System\n')

printf('\nFinding Internal and Boundary Elements\n\t')
[ii,jj] = find(~Element_connectivity');
JJ = unique(jj);
Boundary_elements = Element_connectivity(JJ(:),:);
Internal_elements = Element_connectivity;
Internal_elements(JJ(:),:) = [];

printf('\nSorting Elements Based on Boundary Conditions\n\t')
%tic
%Adiabatic
j = 1;
k = 1;
l = 1;
for i = 1:size(Element_ID,1)
  if Element_ID(i,2) == 1 || Element_ID(i,2) == Nx
    Adiabatic_elements_x(j,1) = i;
    j++;
  endif
  if Element_ID(i,3) == 1 || Element_ID(i,3) == Ny
    Adiabatic_elements_y(k,1) = i;
    k++;
  endif
  if Element_ID(i,4) == 1 || Element_ID(i,4) == Nz
    Adiabatic_elements_z(l,:) = i;
    l++;
  endif
endfor

%Convection
j = 1;
k = 1;
for i = 1:size(Element_ID,1)
  if Element_ID(i,3) == Ny/2 && Element_ID(i,4) <= Nz/3
    hh_elements_y(j,1) = i;
    j++;
  endif
  if Element_ID(i,3) >= Ny/2 + 1 && Element_ID(i,4) == Nz/3 + 1
    hh_elements_z(k,1) = i;
    k++;
  endif
endfor
j = 1;
k = 1;
l = 1;
for i = 1:size(Element_ID,1)
  if Element_ID(i,4) == Nz*2/3
    if Element_ID(i,3) <= Ny/2 && Element_ID(i,2) <= Nx*3/4
      hc_elements_z(j,1) = i;
      j++;
    endif
    if Element_ID(i,3) > Ny/2 && Element_ID(i,2) > Nx/4
      hc_elements_z(j,1) = i;
      j++;
    endif
  endif
  
  if Element_ID(i,2) == Nx/4 && Element_ID(i,4) > Nz*2/3
    hc_elements_x(k,1) = i;
    k++;
  endif
  if Element_ID(i,2) == Nx*3/4 + 1 && Element_ID(i,4) > Nz*2/3
    hc_elements_x(k,1) = i;
    k++;
  endif
  
  if Element_ID(i,3) == Ny/2 + 1 && Element_ID(i,4) > Nz*2/3
    hc_elements_y(l,1) = i;
    l++;
  endif
  if Element_ID(i,3) == Ny/2 && Element_ID(i,4) > Nz*2/3
    hc_elements_y(l,1) = i;
    l++;
  endif
endfor
t_mesh = toc

for ic = 1:length(Biot_c)
  for ih = 1:length(Biot_h)
    Biot_cold = Biot_c(ic);
    Bi_c = Biot_c(ic)*Delta/L;
    Bi_h = Biot_h(ih)*Delta/L;
    Conduction_Solution
    q_bar(ic,ih) = q_dimensionless;
  endfor
endfor
Conduction_Solution_T
q_T = q_dimensionless



surf(Biot_c,Biot_h,q_bar)
xlabel('Cold Side Biot Number')
ylabel('Hot Side Biot Number')
zlabel('Dimensionless Heat Transfer Rate')
axis([0 max(Biot_c) 0 max(Biot_h) 0 2])
print('Figures\q_bar.png')
save q_bar_data.mat q_bar q_T Biot_c Biot_h
