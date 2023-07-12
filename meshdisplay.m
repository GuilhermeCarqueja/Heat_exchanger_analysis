printf('Creating mesh drawing\n')

for i = 1:size(Element_ID,1)
  num_neighbours = nnz(Element_connectivity(i,2:7));
  if num_neighbours < 6
    scatter3(Element_ID(i,2),Element_ID(i,3),Element_ID(i,4),50,'k','.')
    hold on
    for j = 2:7
      if Element_connectivity(i,j) > 0
        plot3([Element_ID(i,2) Element_ID(Element_connectivity(i,j),2)],[Element_ID(i,3) Element_ID(Element_connectivity(i,j),3)],[Element_ID(i,4) Element_ID(Element_connectivity(i,j),4)],'k')
        hold on
      endif
    endfor
  endif
endfor
axis([0 20 0 20 0 20])