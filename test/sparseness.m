%% sparseness
% How well does the sparse orthogonalizing network algorithm return random
% ids in [1,156]
% Thanks to: 
%  https://stats.stackexchange.com/a/318009	
%  https://stackoverflow.com/a/19303725/1608467
results = zeros(1,156);  
figure
for i = 1:30
 for j = 31:60
  for k = 61:90
   for m = 91:120
    for ii = 121:132
     for jj = 133:144
      for kk = 145:156
        a = (sin(i) + sin(j) + sin(k) + sin(m) + sin(ii) + sin(jj) + sin(kk)) * 10000; 
        prettyRandom = a - floor(a);
        inRange = floor(156 * prettyRandom) + 1; 
        results(inRange) = results(inRange) + 1; 
        if ii == 132
            plot(results) 
            drawnow            
        end
      end
     end
    end
   end
  end
 end
end
