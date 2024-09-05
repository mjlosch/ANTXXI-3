timeMin = 44.25;
timeMax = 80;
lonMin = 1.2;
lonMax = 3.6;
latMin = -50.7;
latMax = -48.8;
a=load('EIFEX_ADCP.txt');

cm2m=0.01;

time = a(:,1);
lon = a(:,2);
lat = a(:,3);
udata = a(:,4)*cm2m;
vdata = a(:,5)*cm2m;
clear a
ii=find(isnan(time)|isnan(lon)|isnan(lat)|isnan(udata)|isnan(vdata));
time(ii)=[];
lon(ii)=[];
lat(ii)=[];
udata(ii)=[];
vdata(ii)=[];

% remove duplicate x-y data points
[b,i,j]=unique(lon);
lon=lon(i);
lat=lat(i);
udata=udata(i);
vdata=vdata(i);
[b,i,j]=unique(lat);
lon=lon(i);
lat=lat(i);
udata=udata(i);
vdata=vdata(i);

%i0 = find(lon>=lonMin&lon<=lonMax&lat>=latMin&lat<=latMax);
i0 = [1:length(lon)]';
%it = find(time>=timeMin&time<=timeMax);

dx=.05;
x =   [1.35:dx:3.45]';
y = [latMin:dx:latMax]';
latMin = -50.55;
latMax = -48.85;
y = latMin;
while y(end)<=latMax
  y=[y; y(end)+dx*cos(y(end)*pi/180)];
end
%[x,y]=meshgrid([1.35:0.01:3.45],[-50.55:0.01:-48.85]);
[x,y]=meshgrid(x,y);
warning off MATLAB:griddata:DuplicateDataPoints
un=griddata(lon(i0),lat(i0),udata(i0),x,y,'nearest');
vn=griddata(lon(i0),lat(i0),vdata(i0),x,y,'nearest');
u=griddata(lon(i0),lat(i0),udata(i0),x,y,'linear');
v=griddata(lon(i0),lat(i0),vdata(i0),x,y,'linear');
warning on MATLAB:griddata:DuplicateDataPoints
ii=find(isnan(un(:))); un(ii)=u(ii);
ii=find(isnan(vn(:))); vn(ii)=v(ii);
ii=find(isnan(u(:)));  u(ii)=un(ii);
ii=find(isnan(v(:)));  v(ii)=vn(ii);

save eifex_adcp x y u v
