load antxxi3

load('../timeline.mat')
i0 = find(timeline.station==424 & timeline.cast==20);
startDay = timeline.days_since_jan01(i0);
endDay = startDay + 38;
clf
hold on
h=[];
for k = 1:100;length(data);
  if (data{k}.days_since_jan01 >= startDay & ...
	data{k}.days_since_jan01 <= endDay & k~=100 )
    theta = sw_ptmp(data{k}.salt,data{k}.theta,data{k}.pres,0);
    h = [h; scatter(data{k}.salt,theta,10,-data{k}.pres,'.')];
  end
end
hold off
axis([33.7 34.8 -0.2  6.5])
grid
set(gca,'clim',[-500 0],'box','on','layer','top')
chb=colorbar('v');
colormap('bdr')

xlabel('salinity')
ylabel('\theta [degC]')
title(sprintf('all stations between day %u and %u,\ncolor indicates depth',startDay,endDay))

return
set(gcf,'renderer','painters');
print -dpng tsdiagram.png
