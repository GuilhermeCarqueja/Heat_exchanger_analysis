function k_water = k_water(T_water)
  k_water = 8.7847443206E-13*(T_water.^6) - 2.9687103646E-10*(T_water.^5) + 3.9736882178E-08*(T_water.^4) - 2.6559406323E-06*(T_water.^3) + 8.1333072284E-05*(T_water.^2) + 7.1564111028E-04*T_water + 5.6703001299E-01;
end