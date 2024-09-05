[datestring,numtime,pCO2,dum,timestring,lat,lon, ...
 dum,dum,dum,dum,dum,dum,dum,dum,dum,dum] = ...
    textread('fCO2.txt','%s%f%f%f%s%f%f%f%f%f%f%f%f%f%f%f%f');

dateandtimestr=datestring;
serialdate = zeros(size(datestring));
for k=1:length(datestring)
  dateandtimestr{k} = [datestring{k} ',' timestring{k}];
  serialdate(k) = datenum(dateandtimestr{k},'mm-dd-yy,HH:MM:SS');
end

save -v6 pCO2 dateandtimestr serialdate lon lat pCO2

