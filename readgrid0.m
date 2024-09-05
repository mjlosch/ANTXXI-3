% get the station time infromation from this file:
fid=fopen('llgrid_station.cnt','r');

% move forward 
for k=1:40; fgetl(fid); end
%2004/02/12  03:16:00  to  2004/02/12  05:42:00 /* Station 424 cast 20*/
fmt='%u/%u/%u %u:%u:%u to %u/%u/%u %u:%u:%u /* Station %u cast %u*/';
[a,count] = fscanf(fid,fmt,[14,50]);
fclose(fid);

a=a';
yr1 =a(:,1);
mon1=a(:,2);
day1=a(:,3);
hr1 =a(:,4);
min1=a(:,5);
sec1=a(:,6);
yr2 =a(:,7);
mon2=a(:,8);
day2=a(:,9);
hr2 =a(:,10);
min2=a(:,11);
sec2=a(:,12);
stid=a(:,13);
cast=a(:,14);

% define common time line days or hours since Jan01,2004
offset = zeros(size(mon1));
offset(find(mon1==2))=31;
offset(find(mon1==3))=31+29;

days_since_jan01  = offset+day1;
hours_since_jan01 = (offset+day1)*24+hr1;

%
timeline=struct('station',stid,'cast',cast, ...
		'days_since_jan01',days_since_jan01, ...
		'hours_since_jan01',hours_since_jan01);

save timeline timeline

