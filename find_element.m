function find_element = find_element(ElementID,searched_element)
  find_element = 0;
  %Search Accelerator
  %{
  if searched_element(3) > 1
    aux = 0;
    counter = 1;
    while aux == 0
      if ElementID(counter,4) == searched_element(3) - 1
        aux = counter;
      endif
      counter++;
    endwhile
  else
  aux = 1;
  endif
  %}
  %End of Search Accelerator
  aux = 1;
  while find_element == 0
    if ElementID(aux,2:4) == searched_element
      find_element = aux;
    endif
    aux++;
  endwhile
  %{
  for aux = 1:size(ElementID,1)
    if ElementID(aux,2:4) == searched_element
      find_element = aux;
    endif
  endfor
  %}
endfunction