% read sql data-base file (table), convert units to my standard SI-units
% and save to a mat-file.
clear
fname = 'antxxi-3.poldat';

deg2rad = pi/180;

fid=fopen(fname,'r');
header=fgetl(fid);
header=fgetl(fid);
k=0;
while 1
  tline = fgetl(fid);
  if ~ischar(tline), break, end
%  disp(tline)
  k=k+1;
  day(k)   = data2num(tline(2:3));
  month(k) = data2num(tline(5:6));
  year(k)  = data2num(tline(8:9))+2000;
  hour(k)  = data2num(tline(11:12));
  minute(k)= data2num(tline(14:15));
  lat(k)   = data2num(tline(20:49));
  lon(k)   = data2num(tline(50:71));
  atemp(k) = data2num(tline(72:93));
  aqh(k)   = data2num(tline(94:115));
  press(k) = data2num(tline(116:137));
  winddir(k) = data2num(tline(138:159))*deg2rad;
  windspeed(k) = data2num(tline(160:181));
  ceiling(k) = data2num(tline(182:203));
  precip(k) = data2num(tline(204:225));
  swdown(k) = max(0,data2num(tline(226:238)));
  qexter(k) = data2num(tline(239:end));
end
fclose(fid);

% global time
offset=zeros(size(month));
offset(find(month==2))=31;
offset(find(month==3))=31+29;
time = offset + (day + (hour+minute/60)/24);


% 
year=year(:);
month=month(:);
day=day(:);
hour=hour(:);
minute=minute(:);
time=time(:);
lon=lon(:);
lat=lat(:);
atemp=atemp(:);
press=press(:);
aqh=aqh(:)*1e-3; % to convert to (kg H20)/(kg air)
convert2ms = 1e-3/600; % convert from mm/10min to m/s
precip=precip(:)*convert2ms;
swdown=swdown(:);
qexter=qexter(:);
windspeed=windspeed(:);
winddir=winddir(:);
% wind direction relative to north, so that
% 0deg means from north to south
% 90deg mean from east to west
% 180deg means to from south to north
% 270deg means from west to east
uwind = -windspeed.*sin(winddir);
vwind = -windspeed.*cos(winddir);


save antxxi_poldat year month day hour minute time lon lat uwind vwind ...
    windspeed winddir atemp press aqh precip swdown qexter
