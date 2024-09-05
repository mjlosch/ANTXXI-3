%
% data provided by Boris Cisewski
%
% layers for which mean stream function (units 1000 m^2/s, NOT
% integrated) is representative:
% layer 1: 19m-50m   ! contaminated by intertial oscillations etc.
% layer 2: 50m-100m
% layer 3: 100m-150m
% layer 4: 150m-200m ! Boris takes this as representative for mean flow
% layer 5: 200m-250m
% 
% format of continuous ADCP data eifex_all_uv.mat
% uv = 79 depth layers x (u,v)*number of horiontal points
% units = m/s
% Volker Strass: everything above 100m is heavily contaminated by
% intertial oscillations and other noise, not recommended for assimilation
% 
% format of continuous ADCP data eifex_all_xy.mat
% xyt = (lon lat julian_days) x number of horizontal points
% z   = depth between measuments (m)
% zc  = depth at measurments (m)

% initial uv-fields:
zstrf = - [ 25; 75; 125; 175; 225];
a = cell(size(zstrf));
a{1} = load('eddy2_strf_layer1.mat');
a{2} = load('eddy2_strf_layer2.mat');
a{3} = load('eddy2_strf_layer3.mat');
a{4} = load('eddy2_strf_layer4.mat');
a{5} = load('eddy2_strf_layer5.mat');

alon = a{1}.alon;
alat = a{1}.alat;
for k = 1:length(zstrf);
  ustrf(:,:,k) = a{k}.u;
  vstrf(:,:,k) = a{k}.v;
end

plotit=0;
if plotit
  clf
  m_proj('lambert','lon',[min(alon(:)),max(alon(:))], ...
	 'lat',[min(alat(:)),max(alat(:))]);
  k=1; qh = m_quiver(alon,alat,ustrf(:,:,k),vstrf(:,:,k),'k');
  m_grid;
end

% 4 m continuous ADCP fields
zmin = -0; % do not use data above zmin, contaminated with fast fluctuations
load eifex_all_uv
ua = uv(:,1:2:end);
va = uv(:,2:2:end);
clear uv
load eifex_all_xy xyt z zc
za  = -z; 
zca = -zc;
x = xyt(1,:);
y = xyt(2,:);
t = xyt(3,:);
clear xyt z zc
iz = find(zca>=zmin);
if ~isempty(iz)
  ua(iz,:) = NaN;
  va(iz,:) = NaN;
end

% load common time frame
load('../timeline.mat')
firstday = 31+11; 
lastday  = 31+29+20;
it = find(t>=firstday & t<=lastday);
x = x(it);
y = y(it);
t = t(it);
ua = ua(:,it);
va = va(:,it);

nx = 30;
ny = 60;
lonc = [min(alon(:)),max(alon(:))]; lonc = [lonc(1):diff(lonc)/(nx-1):lonc(2)]';
latc = [min(alat(:)),max(alat(:))]; latc = [latc(1):diff(latc)/(ny-1):latc(2)]';

long = lonc;
latg = latc;
zc = -[5:10:250]';
nz = length(zc);
gmethod = 'linear';
for k = 1:length(zstrf)
  utmp(:,:,k) = griddata(alon,alat,ustrf(:,:,k),long',latc,gmethod);
  vtmp(:,:,k) = griddata(alon,alat,vstrf(:,:,k),lonc',latg,gmethod);
end
uini = zeros([length(zc) size(utmp,1) size(utmp,2)]);
vini = zeros([length(zc) size(utmp,1) size(utmp,2)]);
gmethod = 'cubic';
for j = 1:size(utmp,1);
  for i = 1:size(utmp,2);
    u1 = interp1(zstrf,squeeze(utmp(j,i,:)),zc,'nearest','extrap');
    u2 = interp1(zstrf,squeeze(utmp(j,i,:)),zc,gmethod,NaN);
    i0 = find(isnan(u2));
    u2(i0) = u1(i0);
    uini(:,j,i) = u2;
    v1 = interp1(zstrf,squeeze(vtmp(j,i,:)),zc,'nearest','extrap');
    v2 = interp1(zstrf,squeeze(vtmp(j,i,:)),zc,gmethod,NaN);
    i0 = find(isnan(v2));
    v2(i0) = v1(i0);
    vini(:,j,i) = interp1(zstrf,squeeze(vtmp(j,i,:)),zc,gmethod,'extrap');
  end
end

% initial fields
uini = permute(uini,[3 2 1]);
vini = permute(vini,[3 2 1]);

% daily data
datatime = [firstday:lastday]';
% hourly data
%datatime = [firstday-1:(1/24):lastday]';
kdiff = 1;

[llonc,llatc]=meshgrid(lonc,latc);
[llong,llatg]=meshgrid(long,latg);
nt=length(datatime);
udata = NaN*ones(nz,ny,nx,nt);
vdata = NaN*ones(nz,ny,nx,nt);
for kt = 1:nt;
  disp(sprintf('timestep %u (%u)',kt,nt))
  km1 = max(kt-kdiff,1);
  kp1 = min(kt+kdiff,nt);
  it = find(t>=datatime(km1) & t<=datatime(kp1));
  warning off MATLAB:griddata:DuplicateDataPoints
  utmp = NaN*ones(ny,nx,length(zca));
  vtmp = NaN*ones(ny,nx,length(zca));
  for k = 1:length(zca)
    xx = x(it);
    yy = y(it);
    uu = ua(k,it); i0 = find(~isnan(uu));
    if length(i0) > 2;
      utmp(:,:,k) = griddata(xx(i0),yy(i0),uu(i0),llong,llatc);
    end
    vv = va(k,it); i0 = find(~isnan(vv));
    if length(i0) > 2;
      vtmp(:,:,k) = griddata(xx(i0),yy(i0),vv(i0),llonc,llatg);
    end
  end
  warning on MATLAB:griddata:DuplicateDataPoints
  for j=1:ny
    for i=1:nx
      udata(:,j,i,kt) = interp1(zca,squeeze(utmp(j,i,:)),zc,'linear',NaN);
      vdata(:,j,i,kt) = interp1(zca,squeeze(vtmp(j,i,:)),zc,'linear',NaN);
    end
  end
end

udata = permute(udata,[3 2 1 4]);
vdata = permute(vdata,[3 2 1 4]);

prec='real*8';
ieee='ieee-be';
fid=fopen('U.init','w',ieee);fwrite(fid,uini,prec);fclose(fid);
fid=fopen('V.init','w',ieee);fwrite(fid,vini,prec);fclose(fid);
fid=fopen('U.data.daily','w',ieee);fwrite(fid,udata,prec);fclose(fid);
fid=fopen('V.data.daily','w',ieee);fwrite(fid,vdata,prec);fclose(fid);

