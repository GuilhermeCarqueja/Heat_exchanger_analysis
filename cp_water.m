function cp_water = cp_water(T_water)
  cp_water = 3.1086244690E-15*(T_water.^6) - 1.0462741784E-12*(T_water.^5) - 1.0256259499E-05*(T_water.^4) + 2.8717832557E-03*(T_water.^3) - 2.8953333905E-01*(T_water.^2) + 1.2991135612E+01*T_water + 3.9604032303E+03;
end