function f_D = f_D(rel_roughness,Re)
  if Re<400
    f_D = 0.0054 + (2.3e-8)*Re^(2/3);
  else
    f_old = 0.3;
    f_D = 1/((2*log10((rel_roughness)/3.7 + 2.51/(Re*sqrt(f_old))))^2);
    while abs(f_D-f_old) > 1e-6
      f_old = f_D;
      f_D = 1/((2*log10((rel_roughness)/3.7 + 2.51/(Re*sqrt(f_old))))^2);
  end
  end
end