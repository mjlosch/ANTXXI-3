%
% list of "in-patch" stations:
inPatchKlaas = [424,427,452,470,508,511,513,522,543,544,545,570,580,591,593];
d=loadbottle_data('StationChlaML.txt');

% remove all stations that are not in the right location
id = find(d.lon > 0 & d.lon < 4 & d.lat > -52 & d.lat < -48);
d.year         = d.year(id);
d.month        = d.month(id);
d.day          = d.day(id);
d.hour         = d.hour(id);
d.minute       = d.minute(id);
d.lon          = d.lon(id);
d.lat          = d.lat(id);
d.depth        = d.depth(id);
d.station      = d.station(id);
d.cast         = d.cast(id);
d.particleSize = d.particleSize(id);
d.chlaValue    = d.chlaValue(id);

% remove all entries with small particle size:
id = find(d.particleSize == 0);
d.year         = d.year(id);
d.month        = d.month(id);
d.day          = d.day(id);
d.hour         = d.hour(id);
d.minute       = d.minute(id);
d.lon          = d.lon(id);
d.lat          = d.lat(id);
d.depth        = d.depth(id);
d.station      = d.station(id);
d.cast         = d.cast(id);
d.particleSize = d.particleSize(id);
d.chlaValue    = d.chlaValue(id);

load('../timeline.mat');

days_since_jan01  = [];
hours_since_jan01 = [];
for k = 1:length(d.station);
  ik=find(d.station(k)==timeline.station & d.cast(k) == timeline.cast);
  if isempty(ik)
    error('invalid station')
  end
  if length(ik) > 1
    error('length(ik)>1')
  end
  days_since_jan01  = [days_since_jan01; ...
		    timeline.days_since_jan01(ik)];
  hours_since_jan01 = [hours_since_jan01; ...
		    timeline.hours_since_jan01(ik)];
end

offset=0*d.month;
for k=1:length(d.month)
  if d.month(k) == 2
    offset(k)=31;
  elseif d.month(k) == 3
    offset(k)=31+29;
  else
    error('unknown month')
  end
end

time = offset + d.day + (d.hour + d.minute/60)/24;
timedays  = offset + d.day;
timehours = timedays*24 + d.hour;

[time,is]=sort(time);

[nr, inr, jnr] = unique(d.station);
lon = d.lon(inr);
lat = d.lat(inr);

depth = unique(d.depth);
nz = length(depth);
chla2d=[];
tnr=[];
ip = find(ismember(d.station,inPatchKlaas));
for k=1:length(nr)
  if ~isempty(find(nr(k)==inPatchKlaas))
    knr = find(d.station==nr(k));
    [dtmp,id]= sort(d.depth(knr));
    tnr = [tnr;time(knr(1))];
    chlatmp = d.chlaValue(knr(id));
    chla2d = [chla2d interp1q(dtmp,chlatmp,depth)];
  end
end

% $$$ x = min(lon(:)):(max(lon(:))-min(lon(:)))/20:max(lon(:));
% $$$ y = min(lat(:)):(max(lat(:))-min(lat(:)))/20:max(lat(:));
% $$$ [xi,yi]=meshgrid(x,y);
% $$$ for k = 1:length(depth)
% $$$   disp(num2str(k))
% $$$   id=find(d.depth==depth(k));
% $$$   if length(id) > 2
% $$$     chla3d(:,:,k) = griddata(d.lon(id),d.lat(id),d.chlaValue(id),xi,yi, ...
% $$$ 			     'linear');
% $$$   else
% $$$     chla3d(:,:,k) = zeros(size(xi));
% $$$   end
% $$$ end

for k=1:length(inPatchKlaas)
  ik=min(find(timeline.station==inPatchKlaas(k)));
  inPatchKlaas(k) = inPatchKlaas(k)*100+timeline.cast(ik);
end

chla = d;
chla.inPatchStation = inPatchKlaas;
chla.days_since_jan01 = days_since_jan01;
chla.hours_since_jan01 = hours_since_jan01;

save eifexchla chla

clf
[cs h]=contourf(tnr,-depth,chla2d,20);
% und zum Vergleich die "Rohdaten":
hold on
scatter(timedays(ip),-d.depth(ip),20,d.chlaValue(ip),'filled')
plot(timedays(ip),-d.depth(ip),'ko')
hold off

set(h,'edgecolor','none')
caxis([0 3.5])
colorbar('h')
xlabel('days of experiment')
ylabel('depth [m]')
title('''in patch'' Chl a, mg/l^3')

set(gca,'ylim',[-200 0])

set(gcf,'renderer','painters'); print -dpng eifexchla.png
