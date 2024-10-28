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
for k = 1:length(zstrf)
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
load('../output_tmp/timeline.mat')
firstday = 31+11;
lastday  = 31+29+20;
it = find(t>=firstday & t<=lastday);
x = x(it);
y = y(it);
t = t(it);
ua = ua(:,it);
va = va(:,it);

addpath ../
nx = 42;
ny = 54;
[llonc,llatc,zc,nz] = create_grid(nx,ny);
lonc = llonc(1,:)';
latc = llatc(:,1);
% nx = 30;
% ny = 60;
% lonc = [min(alon(:)),max(alon(:))]; lonc = [lonc(1):diff(lonc)/(nx-1):lonc(2)]';
% latc = [min(alat(:)),max(alat(:))]; latc = [latc(1):diff(latc)/(ny-1):latc(2)]';
%nx = 42;
%ny = 54;
%lonb = [1.35, 3.445];
%lon_dc = diff(lonb)/(nx-1);
%lonc = ((lonb(1)+lon_dc):lon_dc:(lonb(end)+lon_dc))';
%latb = [-50.55, -48.80];
%lat_dc = diff(latb)/(ny-1);
%latc = ((latb(1)+lat_dc):lat_dc:(latb(end)+lat_dc))';
%zc = -[5:10:250]';
%zc = -[5:10:145 156 170.25 189.25 212.50:25:487.50]';
%nz = length(zc);

long = lonc;
latg = latc;
gmethod = 'linear';
clear utmp vtmp
for k = 1:length(zstrf)
  utmp1 = griddata(alon,alat,ustrf(:,:,k),long',latc,'nearest');
  utmp2 = griddata(alon,alat,ustrf(:,:,k),long',latc,gmethod);
  vtmp1 = griddata(alon,alat,vstrf(:,:,k),lonc',latg,'nearest');
  vtmp2 = griddata(alon,alat,vstrf(:,:,k),lonc',latg,gmethod);
  i0=isnan(utmp2)
  utmp2(i0) = utmp1(i0)
  i0=isnan(vtmp2)
  vtmp2(i0) = vtmp1(i0)
  utmp(:,:,k) = utmp2
  vtmp(:,:,k) = vtmp2
end
uini = zeros([length(zc) size(utmp,1) size(utmp,2)]);
vini = zeros([length(zc) size(utmp,1) size(utmp,2)]);
gmethod = 'cubic';
for j = 1:size(utmp,1)
  for i = 1:size(utmp,2)
    u1 = interp1(zstrf,squeeze(utmp(j,i,:)),zc,'nearest','extrap');
    u2 = interp1(zstrf,squeeze(utmp(j,i,:)),zc,gmethod,NaN);
    i0 = find(isnan(u2));
    u2(i0) = u1(i0);
    uini(:,j,i) = u2;
    v1 = interp1(zstrf,squeeze(vtmp(j,i,:)),zc,'nearest','extrap');
    v2 = interp1(zstrf,squeeze(vtmp(j,i,:)),zc,gmethod,NaN);
    i0 = find(isnan(v2));
    v2(i0) = v1(i0);
    vini(:,j,i) = v2;
  end
end

% initial fields
uini = permute(uini,[3 2 1]);
vini = permute(vini,[3 2 1]);

% daily data
datatime = (firstday:lastday)';
% hourly data
%datatime = [firstday-1:(1/24):lastday]';
kdiff = 1;

[llonc,llatc]=meshgrid(lonc,latc);
[llong,llatg]=meshgrid(long,latg);
nt=length(datatime);
udata = NaN*ones(nz,ny,nx,nt);
vdata = NaN*ones(nz,ny,nx,nt);
for kt = 1:nt
  fprintf('timestep %u (%u)\n',kt,nt)
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
    if length(i0) > 2
      utmp(:,:,k) = griddata(xx(i0),yy(i0),uu(i0),llong,llatc);
    end
    vv = va(k,it); i0 = find(~isnan(vv));
    if length(i0) > 2
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
fid=fopen('../output_tmp/U.init','w',ieee);fwrite(fid,uini,prec);fclose(fid);
fid=fopen('../output_tmp/V.init','w',ieee);fwrite(fid,vini,prec);fclose(fid);
fid=fopen('../output_tmp/U.data.daily','w',ieee);fwrite(fid,udata,prec);fclose(fid);
fid=fopen('../output_tmp/V.data.daily','w',ieee);fwrite(fid,vdata,prec);fclose(fid);

return
% check binary output
fid = fopen('/Users/yye/Models/OIF/eifex_input/sbcn','r');
%fid = fopen('../output_tmp/V.init','r');
dat1 = fread(fid,'real*8',ieee);
fclose(fid);
dat2 = reshape(dat1,[42 54 30]);
figure
colormap(jet)
pcolor(lonc, latc,squeeze(dat2(:,:,10))');shading flat
%caxis([3 7])
caxis([33.75 33.95])
colorbar
set(gca,'PlotBoxAspectRatio',[1,1.5,1],'fontsize',16)
yticks(-50.6:0.3:-49)
xticks(1.3:0.3:3.4)
ylabel('Latitude');
xlabel('Longitude');

% cut out open boundary conditions 
% too low spacial resolution at the northmost/eastmost boundary: thus end-1!
% salinity:
ubcs=squeeze(uini(:,1,:));
ubcn=squeeze(uini(:,end-1,:));
ubcw=squeeze(uini(1,:,:));
ubce=squeeze(uini(end-1,:,:));
% temperature:
vbcs=squeeze(vini(:,1,:));
vbcn=squeeze(vini(:,end-1,:));
vbcw=squeeze(vini(1,:,:));
vbce=squeeze(vini(end-1,:,:));

prec='real*8';
ieee='ieee-be';
fid=fopen('../output_tmp/vbcs','w',ieee);fwrite(fid,vbcs,prec);fclose(fid);
fid=fopen('../output_tmp/vbcn','w',ieee);fwrite(fid,vbcn,prec);fclose(fid);
fid=fopen('../output_tmp/vbcw','w',ieee);fwrite(fid,vbcw,prec);fclose(fid);
fid=fopen('../output_tmp/vbce','w',ieee);fwrite(fid,vbce,prec);fclose(fid);
fid=fopen('../output_tmp/ubcs','w',ieee);fwrite(fid,ubcs,prec);fclose(fid);
fid=fopen('../output_tmp/ubcn','w',ieee);fwrite(fid,ubcn,prec);fclose(fid);
fid=fopen('../output_tmp/ubcw','w',ieee);fwrite(fid,ubcw,prec);fclose(fid);
fid=fopen('../output_tmp/ubce','w',ieee);fwrite(fid,ubce,prec);fclose(fid);
