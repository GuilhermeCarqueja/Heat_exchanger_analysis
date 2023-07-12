function LSQ = LSQ(qi,qT,a,b,Bc,Bh)
  for i = 1:size(qi,1)
    for j = 1:size(qi,2)
      M(i,j) = (qi(i,j)/qT - f_lsq(Bc(i),Bh(j),a,b))^2;
      LSQ = sum(sum(M));
    endfor
  endfor
endfunction