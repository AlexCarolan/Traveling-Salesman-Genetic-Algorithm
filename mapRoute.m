figure('Name','TSP_GA | Results','Numbertitle','off');
subplot(2,2,1);
pclr = ~get(0,'DefaultAxesColor');
plot(xy(:,1),xy(:,2),'.','Color',pclr);
title('City Locations');
subplot(2,2,2);
rte = optRoute([1:100 1]);
plot(xy(rte,1),xy(rte,2),'r.-');
title(sprintf('Total Distance = %1.4f',optRoute(1,101)));