% load common time line
load('../timeline.mat');

d=dir('efx*.txt');

data = cell(size(d));
for k = 1:length(d);
  fname = d(k).name;
  data{k} = loadco2(fname);
end
time =zeros(size(data));
for k = 1:length(data);
  time(k) = data{k}.date;
end
[stime,i]=sort(time);
datatmp = data;
for k = 1:length(i)
  data{k}=datatmp{i(k)};
end
clear datatmp

% list of "in-patch" stations"
inPatch = [ 424 426 427 508 511 513 543 544 545 553 580 586 593];
station = zeros(size(data));
for k=1:length(data)
  station(k)=data{k}.station;
end
id=[];
for k=1:length(inPatch);
  ii = find(floor(station/100)==inPatch(k));
  if isempty(ii);
    id=[id;NaN];
  else
    id=[id(:);ii(:)];
  end
end
id(find(isnan(id))) = [];

clear data0;
data0 = data;
data = cell(length(id),1);
for k=1:length(id)
  data{k} = data0{id(k)};
end
datafname='eifex_cdata_inpatch.mat';
clear data
data=data0;
datafname='eifex_cdata.mat';


for k=1:length(data)
  t0=data{k}.date-2004e4;
  mon=floor(t0/100);
  offset=0;
  if mon == 2
    offset=31;
  elseif mon == 3
    offset=31+29;
  else
    error('unknown month')
  end
  tim(k) = offset + t0-mon*100;
end

lon = [];
lat = [];
index=[];
station=[];
cast = [];
time = [];
days_since_jan01=[];
hours_since_jan01=[];
depth =[];
press =[];
theta = [];
sal = [];
tco2 = [];
alk = [];
tlid=timeline.station*100 + timeline.cast;
for k = 1:length(data);
  nz = length(data{k}.depth);
  lon = [lon; data{k}.lon*ones(nz,1)];
  lat = [lat; data{k}.lat*ones(nz,1)];
  station = [station; data{k}.station*ones(nz,1)];
  cast = [cast; data{k}.cast*ones(nz,1)];
  depth = [depth; data{k}.depth];
  index = [index; k*ones(nz,1)];
  time = [time; tim(k)*ones(nz,1)];
  ik=find(100*data{k}.station+data{k}.cast == tlid);
  if isempty(ik)
    days_since_jan01  = [days_since_jan01; NaN*ones(nz,1)];
    hours_since_jan01 = [hours_since_jan01; NaN*ones(nz,1)];
  else
    if length(ik) > 1
      error('length(ik)>1')
    end
    days_since_jan01  = [days_since_jan01; ...
		    timeline.days_since_jan01(ik)*ones(nz,1)];
    hours_since_jan01 = [hours_since_jan01; ...
		    timeline.hours_since_jan01(ik)*ones(nz,1)];
  end
  press = [press; data{k}.Pressure];
  if isfield(data{k},'Temperature')
    theta = [theta; data{k}.Temperature];
  else
    theta = [theta; NaN*ones(nz,1)];
  end
  if isfield(data{k},'Salinity')
    sal = [sal; data{k}.Salinity];
  else
    sal = [sal; NaN*ones(nz,1)];
  end
  if isfield(data{k},'TCO2')
    tco2 = [tco2; data{k}.TCO2];
  else
    tco2 = [tco2; NaN*ones(nz,1)];
  end
  if isfield(data{k},'alk')
    alk = [alk; data{k}.alk];
  else
    alk = [alk; NaN*ones(nz,1)];
  end
end

tco2(find(tco2<1000))=NaN;

cData = struct('lon',lon,'lat',lat,'depth',depth,'press',press, ...
	       'time',time,'station',station,'cast',cast, ...
	       'days_since_jan01',days_since_jan01, ...
	       'hours_since_jan01',hours_since_jan01, ...
	       'theta',theta,'sal',sal, ...
	       'tco2',tco2,'alk',alk);

save(datafname,'cData')

