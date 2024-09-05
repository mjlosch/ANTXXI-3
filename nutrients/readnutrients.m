% first read nutrients of surface recorder
load EIFEX_all_nuts;
inan=find(isnan(nuts(:,1)));
nuts(inan,:) = [];
nuts(:,8:end) = [];
tsurf=nuts(:,1);
month=floor(nuts(:,1)/1e6);
day  =floor((nuts(:,1)-month*1e6)/1e4);
hour =floor((nuts(:,1)-month*1e6-day*1e4)/1e2);
minute=nuts(:,1)-month*1e6-day*1e4-hour*1e2;
month(find(month==2))=31;
month(find(month==3))=31+29;
days_since_jan01_surf = -1+month+day+(hour+minute/60)/24;
ctr=load('../eifex_cruisetrack.txt');

lon_surf = zeros(size(days_since_jan01_surf));
lat_surf = zeros(size(days_since_jan01_surf));
for k=1:length(days_since_jan01_surf)
  mindist = min(abs(days_since_jan01_surf(k)-ctr(:,1)));
  ik=find(abs(days_since_jan01_surf(k)-ctr(:,1))==mindist);
  if isempty(ik)
    display('no time found')
    keyboard
  elseif length(ik)>1
    display('more than one time found')
%    keyboard
    lon_surf(k) = mean(ctr(ik,2));
    lat_surf(k) = mean(ctr(ik,3));
  else
    lon_surf(k) = ctr(ik,2);
    lat_surf(k) = ctr(ik,3);
  end
end
il=find(lon_surf>4 & lat_surf > -48);
lon_surf(il)=[]; 
lat_surf(il)=[];
days_since_jan01_surf(il) = [];
nuts(il,:) = [];

DIN = sum(nuts(:,[2 3 6]),2);

ik=1:300;
x = 1:.05:3.6;
y = -51:.05:-48.6;
si = griddata(lon_surf(ik),lat_surf(ik),nuts(ik,4),x,y');
din = griddata(lon_surf(ik),lat_surf(ik),DIN(ik),x,y');
return

fname = 'EIFEX_nutrients.prn';

fid=fopen(fname,'r');

% skip header
fgetl(fid);
str0 = 0;
k=0;
str0=fgetl(fid);
while str0~=-1
  str = char(32*ones(1,80));
  str(1:length(str0)) = str0;
  k = k+1;
  tmp=deblank(str(1:14)); 
  it=strfind(tmp,'_'); 
  if ~isempty(it)
    tmp = tmp(1:it-1);
  end
  it=strfind(tmp,'/');
  tmp = str2num(tmp(1:it-1))*100+str2num(tmp(it+1:end));
  if isempty(tmp); stid(k) = NaN; else stid(k)=tmp; end
  tmp = str2num(str(15:21));
  if isempty(tmp); depth(k) = NaN; else depth(k)=tmp; end
  tmp = str2num(str(22:29));
  if isempty(tmp); NO3(k) = NaN; else NO3(k)=tmp; end
  tmp = str2num(str(30:37));
  if isempty(tmp); NO2(k) = NaN; else NO2(k)=tmp; end
  tmp = str2num(str(38:45));
  if isempty(tmp); NH4(k) = NaN; else NH4(k)=tmp; end
  tmp  = str2num(str(46:53));
  if isempty(tmp); Si(k) = NaN; else Si(k)=tmp; end
  tmp = str2num(str(54:61));
  if isempty(tmp); PO4(k) = NaN; else PO4(k)=tmp; end
  % read next line
  str0=fgetl(fid);
end
fclose(fid);
%turn into column vectors
stid = stid(:);
depth = depth(:);
NO3 = NO3(:);
NO2 = NO2(:);
NH4 = NH4(:);
Si = Si(:);
PO4 = PO4(:);
%
load('../CTD/antxxi3.mat')
dstid=zeros(length(data),1);
lon = zeros(length(data),1);
lat = zeros(length(data),1);
for k=1:length(data)
  dstid(k) = data{k}.stid;
  dlon(k) = data{k}.lon;
  dlat(k) = data{k}.lat;
end

lon = NaN*ones(size(stid));
lat = NaN*ones(size(stid));
for k=1:length(stid);
  ii=find(dstid==stid(k));
  if ~isempty(ii);
%    lon(k) = mean(dlon(ii));
%    lat(k) = mean(dlat(ii));
    lon(k) = dlon(ii);
    lat(k) = dlat(ii);
  end
end

load('../timeline.mat')
tlid=100*timeline.station+timeline.cast;
days_since_jan01=NaN*ones(size(lon));
hours_since_jan01=NaN*ones(size(lon));
keyboard
for k=1:length(tlid);
  ik=find(stid==tlid(k));
  if ~isempty(ik)
    days_since_jan01(ik)=timeline.days_since_jan01(k);
    hours_since_jan01(ik)=timeline.hours_since_jan01(k);
  end
end

inan=find(isnan(lon));
lon(inan)   = [];
lat(inan)   = [];
stid(inan)  = [];
days_since_jan01(inan)  = [];
hours_since_jan01(inan) = [];
depth(inan) = [];
NO3(inan)   = [];
NO2(inan)   = [];
NH4(inan)   = [];
Si(inan)    = [];
PO4(inan)   = [];

% compute DIN
Nmol = 14.0067; % gramms/mol
Omol = 15.9994;
Hmol = 1.00794;
DIN =   NO3 + NO2 + NH4;

% first station
i0 = find(stid==42420);

nutrients = struct('station',stid, ...
		   'days_since_jan01',days_since_jan01, ...
		   'hours_since_jan01',hours_since_jan01, ...
		   'lon',lon,'lat',lat,'depth',depth, ...
		   'NO3',NO3,'NO2',NO2,'NH4',NH4,'DIN',DIN, ...
		   'Si',Si,'PO4',PO4); 


save EIFEX_nutrients nutrients

return
% 3D map
x = min(lon(:)):(max(lon(:))-min(lon(:)))/20:max(lon(:));
y = min(lat(:)):(max(lat(:))-min(lat(:)))/20:max(lat(:));
[xi,yi]=meshgrid(x,y);
zi = unique(depth);
for k = 1:length(zi)
  disp(num2str(k))
  id=find(depth==zi(k));
  if length(id) > 2
    Si3d(:,:,k) = griddata(lon(id),lat(id),Si(id),xi,yi, ...
			     'linear');
  else
    Si3d(:,:,k) = zeros(size(xi));
  end
end
