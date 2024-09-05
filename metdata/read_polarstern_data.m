fname = 'ANTXXI-3.temp.txt';

fid=fopen(fname,'r');
header=fgetl(fid);
k=0;
while 1
  tline = fgetl(fid);
  if ~ischar(tline), break, end
%  disp(tline)
  k=k+1;
  if strcmp(tline(1:3),'Jan')
    month(k) = 1;
  elseif strcmp(tline(1:3),'Feb')
    month(k) = 2;
  elseif strcmp(tline(1:3),'Mar')
    month(k) = 3;
  end
  day(k) = str2num(tline(4:6));
  year(k)= str2num(tline(7:11));
  timetext = tline(12:26);
  if timetext(end-1:end) == 'PM'
    addtwelve = 12;
  else
    addtwelve=0;
  end
  hour(k) = str2num(timetext(1:3));
  if hour(k) == 12; 
    if timetext(end-1:end) == 'PM'
      addtwelve = 0; 
    else 
      addtwelve = -12;
    end;
  end
  hour(k)   = hour(k)+addtwelve;
  minute(k) = str2num(timetext(5:6));
  second(k) = str2num(timetext(8:9))+str2num(timetext(11:13))/1000;
  lon(k) = str2num(tline(27:35));
  lat(k) = str2num(tline(36:44));
  temp(k) = str2num(tline(45:53));
end

offset=zeros(size(month));
offset(find(month==2))=31;
offset(find(month==3))=31+29;
timetemp = offset + (day + (hour + (minute + second/60)/60)/24);

fclose(fid);

fname = 'ANTXXI-3.dewpoint.txt';

fid=fopen(fname,'r');
header=fgetl(fid);
k=0;
while 1
  tline = fgetl(fid);
  if ~ischar(tline), break, end
%  disp(tline)
  k=k+1;
  if strcmp(tline(1:3),'Jan')
    month(k) = 1;
  elseif strcmp(tline(1:3),'Feb')
    month(k) = 2;
  elseif strcmp(tline(1:3),'Mar')
    month(k) = 3;
  end
  day(k) = str2num(tline(4:6));
  year(k)= str2num(tline(7:11));
  timetext = tline(12:26);
  if timetext(end-1:end) == 'PM'
    addtwelve = 12;
  else
    addtwelve=0;
  end
  hour(k) = str2num(timetext(1:3));
  if hour(k) == 12; 
    if timetext(end-1:end) == 'PM'
      addtwelve = 0; 
    else 
      addtwelve = -12;
    end;
  end
  hour(k)   = hour(k)+addtwelve;
  minute(k) = str2num(timetext(5:6));
  second(k) = str2num(timetext(8:9))+str2num(timetext(11:13))/1000;
  lon(k) = str2num(tline(27:35));
  lat(k) = str2num(tline(36:44));
  dp = str2num(tline(45:53));
  if isempty(dp);
    dewpoint(k) = NaN;
  else
    dewpoint(k) = dp;
  end
end

offset=zeros(size(month));
offset(find(month==2))=31;
offset(find(month==3))=31+29;
timedew = offset + (day + (hour + (minute + second/60)/60)/24);

fclose(fid);

fname = 'ANTXXI-3.wind.txt';

fid=fopen(fname,'r');
header=fgetl(fid);
k=0;
while 1
  tline = fgetl(fid);
  if ~ischar(tline), break, end
%  disp(tline)
  k=k+1;
  if strcmp(tline(1:3),'Jan')
    month(k) = 1;
  elseif strcmp(tline(1:3),'Feb')
    month(k) = 2;
  elseif strcmp(tline(1:3),'Mar')
    month(k) = 3;
  end
  day(k) = str2num(tline(4:6));
  year(k)= str2num(tline(7:11));
  timetext = tline(12:26);
  if timetext(end-1:end) == 'PM'
    addtwelve = 12;
  else
    addtwelve=0;
  end
  hour(k) = str2num(timetext(1:3));
  if hour(k) == 12; 
    if timetext(end-1:end) == 'PM'
      addtwelve = 0; 
    else 
      addtwelve = -12;
    end;
  end
  hour(k)   = hour(k)+addtwelve;
  minute(k) = str2num(timetext(5:6));
  second(k) = str2num(timetext(8:9))+str2num(timetext(11:13))/1000;
  lon(k) = str2num(tline(27:35));
  lat(k) = str2num(tline(36:44));
  wdir(k) = str2num(tline(45:49));
  wspeed(k) = str2num(tline(50:59));
end

offset=zeros(size(month));
offset(find(month==2))=31;
offset(find(month==3))=31+29;
timewind = offset + (day + (hour + (minute + second/60)/60)/24);

fclose(fid);

time = timewind(:);
lon = lon(:);
lat = lat(:);
temperature = temp(:);
dewpoint = dewpoint;
wind_speed = wspeed(:);
wind_direction = wdir(:);

save metdata time lon lat temperature dewpoint wind_speed wind_direction



