function mu_water = mu_water(T_water)
  mu_water = 3.8311288089E-15*(T_water.^6) - 1.5328799545E-12*(T_water.^5) + 2.5884522335E-10*(T_water.^4) - 2.4448618612E-08*(T_water.^3) + 1.4665979212E-06*(T_water.^2) - 6.1192110263E-05*T_water + 1.7974800921E-03;
end