clear
fname = 'antxxi-3.dat';

fid=fopen(fname,'r');
header=fgetl(fid);
header=fgetl(fid);
k=0;
while 1
  tline = fgetl(fid);
  if ~ischar(tline), break, end
%  disp(tline)
  k=k+1;
  day(k)   = str2num(tline(2:3));
  month(k) = str2num(tline(5:6));
  year(k)  = str2num(tline(8:9))+2000;
  hour(k)  = str2num(tline(11:12)); % 3-hourly
  lon(k)   = str2num(tline(20:49));
  lat(k)   = str2num(tline(50:71));
  uwind(k) = str2num(tline(72:93));
  vwind(k) = str2num(tline(94:115));
  atemp(k) = str2num(tline(116:137));
  dp=str2num(tline(138:159)); 
  if isempty(dp); dewpoint(k) = NaN; else dewpoint(k)=dp; end
  dp=str2num(tline(160:181));
  if isempty(dp); dampfdruck(k) = NaN; else dampfdruck(k)=dp; end
  press(k) = str2num(tline(182:203));
  dp=str2num(tline(204:220));
  if isempty(dp) 
    % no observation (night)
    cloudcover(k) = NaN; 
  else 
    if dp > 8
      % fog, no clouds visible
      dp = NaN;
    else
      % convert from fraction of 8 to fraction of 1
      cloudcover(k)=dp/8; 
    end
  end
end

offset=zeros(size(month));
offset(find(month==2))=31;
offset(find(month==3))=31+29;
time = offset + (day + hour/24);

fclose(fid);

dp = dewpoint;% + 273.15;
% compute specific humidity
et  = exp(17.84362*dp./(245.425+dp));
mbar2hp = 100;
aqh = 622*et./(press*mbar2hp-0.378*et);

time = time(:);
year = year(:);
month = month(:);
day = day(:);
hour = hour(:);
lon=lon(:);
lat=lat(:);
uwind=uwind(:);
vwind=vwind(:);
atemp=atemp(:);
dewpoint=dewpoint(:);
dampfdruck=dampfdruck(:);
press=press(:);
aqh=aqh(:);
cloudcover=cloudcover(:);

save ../output_tmp/antxxi time year month day hour  lon lat uwind vwind atemp dewpoint ...
    dampfdruck press aqh cloudcover 
