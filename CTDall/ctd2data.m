load('../output_tmp/antxxi3.mat')
load('../output_tmp/timeline.mat')
%tlid=timeline.station*100+timeline.cast;
firstday = 31+11; 
lastday  = 31+29+20;

% define grid
addpath ../
nx = 42;
ny = 54;
[llonc,llatc,zc,nz] = create_grid(nx,ny);
% nx = 30;
% ny = 60;
% lonc = [  1.3166,  3.4871]; lonc = (lonc(1):diff(lonc)/(nx-1):lonc(2))';
% latc = [-50.6027,-48.7902]; latc = (latc(1):diff(latc)/(ny-1):latc(2))';
% zc = -(5:10:250)';
% nz = length(zc);
% [llonc,llatc]=meshgrid(lonc,latc);

% daily data
datatime = (firstday:lastday)';
nt = length(datatime);
% hourly data
%datatime = [firstday-1:(1/24):lastday]';
kdiff = 3;

% time selection and vertical interpolation
theta = NaN*ones(nz,length(data));
salt  = theta;
lon = NaN*ones(size(data));
lat = lon;
tloc = lon;
for k = 1:length(data)
  if ismember(data{k}.days_since_jan01,datatime)
    lon(k) = data{k}.lon;
    lat(k) = data{k}.lat;
    tmp = data{k}.time;
    if tmp(2)==1
      ndays = 0;
    elseif tmp(2) == 2
      ndays = 31;
    elseif tmp(2) == 3
      ndays = 31+29;
    else
      error('unknown month')
    end
    tloc(k) = tmp(1)+ndays+(tmp(4)+tmp(5)/60)/24;
    prestmp = data{k}.pres;
    [pt,itu] = unique(prestmp);
    [ps,its] = unique(prestmp);
    theta_tmp = data{k}.theta(itu);
    it = find(theta_tmp==-999);
    theta_tmp(it) = []; pt(it) = [];
    theta(:,k) = interp1(-pt,theta_tmp,zc,'linear');
    salt_tmp = data{k}.salt(its);
    is=find(salt_tmp==-999);
    salt_tmp(it) = []; ps(it) = [];
    salt(:,k)  = interp1(-ps,salt_tmp,zc,'linear');
  end %if
end %for
ik = find(isnan(lon));
lon(ik) = [];
lat(ik) = [];
tloc(ik) = [];
theta(:,ik) = [];
salt(:,ik) = [];

nt=length(datatime);
tdata = NaN*ones(ny,nx,nz,nt);
sdata = NaN*ones(ny,nx,nz,nt);
for kt = 1:nt
  fprintf('timestep %u (%u)\n',kt,nt)
  km1 = max(kt-kdiff,1);
  kp1 = min(kt+kdiff,nt);
  it = find(tloc>=datatime(km1) & tloc<=datatime(kp1));
  warning off MATLAB:griddata:DuplicateDataPoints
  ttmp = NaN*ones(ny,nx,nz);
  stmp = NaN*ones(ny,nx,nz);
  for k = 1:nz
    xx = lon(it);
    yy = lat(it);
    tt = theta(k,it); i0 = find(~isnan(tt));
    if length(i0) > 2
      tdata(:,:,k,kt) = griddata(xx(i0),yy(i0),tt(i0),llonc,llatc);
    end
    ss = salt(k,it); i0 = find(~isnan(ss));
    if length(i0) > 2
      sdata(:,:,k,kt) = griddata(xx(i0),yy(i0),ss(i0),llonc,llatc);
    end
  end
  warning on MATLAB:griddata:DuplicateDataPoints
end

tdata = permute(tdata,[2 1 3 4]);
sdata = permute(sdata,[2 1 3 4]);

tdata(find(isnan(tdata))) = -999;
sdata(find(isnan(sdata))) = -999;

prec='real*8';
ieee='ieee-be';
fid=fopen('../output_tmp/theta.data.daily','w',ieee);fwrite(fid,tdata,prec);fclose(fid);
fid=fopen('../output_tmp/salt.data.daily','w',ieee);fwrite(fid,sdata,prec);fclose(fid);

return

% check binary output
fid = fopen('../output_tmp/theta.data.daily','r');
ieee='ieee-be';
dat1 = fread(fid,'real*8',ieee);
fclose(fid);
dat2 = reshape(dat1,[42 54 30 39]);

nx = 42;
ny = 54;
lonb = [1.35, 3.445]; 
lon_dc = diff(lonb)/(nx-1);
lonc = ((lonb(1)+lon_dc):lon_dc:(lonb(end)+lon_dc))';
latb = [-50.55, -48.80]; 
lat_dc = diff(latb)/(ny-1);
latc = ((latb(1)+lat_dc):lat_dc:(latb(end)+lat_dc))';

figure
colormap(jet)
pcolor(llonc,llatc,squeeze(dat2(:,:,1,1))');shading flat
hold on; plot(lon,lat,'+'); hold off
caxis([0 7])
%caxis([33.75 34.5])
colorbar
set(gca,'PlotBoxAspectRatio',[1,1.5,1],'fontsize',16)
yticks(-50.6:0.3:-49)
xticks(1.3:0.3:3.4)
ylabel('Latitude');
xlabel('Longitude');

