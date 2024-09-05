%
t0 = datenum('13-Feb-2004')-datenum('01-Jan-2004');
a = csvread('EIFEX_diatommass.csv');

% outpatch
% inpatch

station=a(:,1)*100+a(:,2);
inpatch=a(:,3);
time = datenum([2000+a(:,6),a(:,5),a(:,4),a(:,7),a(:,8),0*a(:,8)]);
time = time-datenum('13-Feb-2004');
days_since_jan01=time + t0;
hours_since_jan01=(time + t0)*24;
lon = a(:,11);
lat = a(:,12);
depth =a(:,14);
phyto_diatom = a(:,15);

phytoData = struct('lon',lon,'lat',lat,'depth',depth, ...
	       'time',time,'station',station, ...
	       'days_since_jan01',days_since_jan01, ...
	       'hours_since_jan01',hours_since_jan01, ...
	       'totalDiatoms',phyto_diatom);
save eifexPhyto phytoData

return
scatter(phytoData.time,-phytoData.depth,20,phytoData.totalDiatoms,'filled')
