
tic
printf('\n\nCreating Coefficient Matrix\n')
%tic
aux = 1;
for i = 1:size(Internal_elements)
  for j = 2:7
    I(aux) = Internal_elements(i,1);
    J(aux) = Internal_elements(i,j);
    V(aux) = -1;
    aux++;
  endfor
endfor

%Bi_c = Biot_c*Delta/L;
%Bi_h = Biot_h*Delta/L;

%Coefficients for Internal Elements
for i = 1:size(Boundary_elements,1)
  for j = 2:7
    if Boundary_elements(i,j) > 0
      I(aux) = Boundary_elements(i,1);
      J(aux) = Boundary_elements(i,j);
      V(aux) = -1;
      aux++;
    endif
  endfor
endfor

%Boundary Elements
gamma_c = zeros(size(Element_ID,1),1);
for i = 1:size(hh_elements_y,1)
  gamma_c(hh_elements_y(i,1),1)++;
endfor
for i = 1:size(hh_elements_z,1)
  gamma_c(hh_elements_z(i,1),1)++;
endfor
for i = 1:size(hc_elements_x,1)
  gamma_c(hc_elements_x(i,1),1)++;
endfor
for i = 1:size(hc_elements_y,1)
  gamma_c(hc_elements_y(i,1),1)++;
endfor
for i = 1:size(hc_elements_z,1)
  gamma_c(hc_elements_z(i,1),1)++;
endfor

gamma_a = zeros(size(Element_ID,1),1);
for i = 1:size(Adiabatic_elements_x,1)
  gamma_a(Adiabatic_elements_x(i,1),1)++;
endfor
for i = 1:size(Adiabatic_elements_y,1)
  gamma_a(Adiabatic_elements_y(i,1),1)++;
endfor
for i = 1:size(Adiabatic_elements_z,1)
  gamma_a(Adiabatic_elements_z(i,1),1)++;
endfor

gamma = gamma_a + gamma_c;

N_elements_h = Nx*(Ny/2)*(Nz/3) + Nx*Ny;
N_elements_c = 2*(Nx/4)*(Ny/2)*(Nz/3) + Nx*Ny;

T_h = 1;
T_c = 0;

B = zeros(N_elements,1);

for i = 1:N_elements_h
  I(aux) = i;
  J(aux) = i;
  V(aux) = 6 - gamma(i) + gamma_c(i)*(2*Bi_h/(2 + Bi_h));
  aux++;
endfor
for i = N_elements_h + 1:N_elements - N_elements_c
  I(aux) = i;
  J(aux) = i;
  V(aux) = 6 - gamma(i);
  aux++;
endfor
for i = N_elements - N_elements_c + 1:N_elements
  I(aux) = i;
  J(aux) = i;
  V(aux) = 6 - gamma(i) + gamma_c(i)*(2*Bi_c/(2 + Bi_c));
  aux++;
endfor

printf('\tCreating Sparse Matrix A\n\t')
A = sparse(I,J,V,N_elements,N_elements);
%toc

for i = 1:N_elements_h
  B(i,1) = B(i,1) + gamma_c(i)*(2*Bi_h/(2 + Bi_h))*T_h;
endfor
for i = N_elements - N_elements_c + 1:N_elements
  B(i,1) = B(i,1) + gamma_c(i)*(2*Bi_c/(2 + Bi_c))*T_c;
endfor

printf('\nLinear System Created\n\n')
printf('\nSolving System\n')
T = A\B;
printf('System Solved\n')


%N_h = length(hh_elements_y) + length(hh_elements_z);
%N_c = length(hc_elements_x) + length(hc_elements_y) + length(hc_elements_z);
%tic
%{
for i = 1:length(hh_elements_y)
  Th_fy(i) = (2*T(hh_elements_y(i)) + Bi_h*T_h)/(2 + Bi_h);
endfor
for i = 1:length(hh_elements_z)
  Th_fz(i) = (2*T(hh_elements_z(i)) + Bi_h*T_h)/(2 + Bi_h);
endfor

for i = 1:length(hc_elements_x)
  Tc_fx(i) = (2*T(hc_elements_x(i)) + Bi_c*T_c)/(2 + Bi_c);
endfor
for i = 1:length(hc_elements_y)
  Tc_fy(i) = (2*T(hc_elements_y(i)) + Bi_c*T_c)/(2 + Bi_c);
endfor
for i = 1:length(hc_elements_z)
  Tc_fz(i) = (2*T(hc_elements_z(i)) + Bi_c*T_c)/(2 + Bi_c);
endfor

Sum_T = sum(Tc_fx) + sum(Tc_fy) + sum(Tc_fz);
N_cc = length(Tc_fx) + length(Tc_fy) + length(Tc_fz);

q_dimensionless = Biot_cold*((Delta^2)/((L^2)*(T_h - T_c)))*(Sum_T - N_cc*T_c)
toc
%}
%tic
P_layer = floor(Nz/2);
N_layer = P_layer + 1;


Sum_T = sum(T(Named_elements(2,2,P_layer+1):Named_elements(Nx+1,Ny+1,P_layer+1)));
Sum_N = sum(T(Named_elements(2,2,P_layer+2):Named_elements(Nx+1,Ny+1,P_layer+2)));
q_dimensionless = -(Delta/(L*(T_h - T_c)))*(Sum_N - Sum_T)

%toc
t_solution = toc