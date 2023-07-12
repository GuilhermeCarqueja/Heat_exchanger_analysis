clear all
close all
clc

N_d = 5:20;

for sim = 1:length(N_d)
  N_divisions = N_d(sim)
  Conduction
  printf('\n\n\n\n\n')
  
  N_e(sim) = N_elements;
  t_m(sim) = t_mesh;
  t_s(sim) = t_solution;
  
  dimensionless_q(sim) = q_dimensionless;
  clear -exclusive N_d sim t_m t_s dimensionless_q N_e
endfor

mesh_study_plots