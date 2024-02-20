function [moyenne, variance] = estimation_loi_normale(echantillons)


  [n,p] = size(echantillons);
  %moyenne = sum(echantillons)/(n*p);
  moyenne = mean(echantillons);

 

  variance = sum((echantillons - moyenne).^2)/(n*p);
end

