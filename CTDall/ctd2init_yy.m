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
% zc = -[5:10:250 500:250:4500]';
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
  if timeline.inGrid(k)==5
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
    tmp1 = interp1(-pt,theta_tmp,zc,'nearest','extrap');
    tmp2 = interp1(-pt,theta_tmp,zc,'linear');
    inan=find(isnan(tmp2));
    tmp2(inan) = tmp1(inan);
    theta(:,k) = tmp2;
    salt_tmp = data{k}.salt(its);
    is=find(salt_tmp==-999);
    salt_tmp(it) = []; ps(it) = [];
    tmp1 = interp1(-pt,salt_tmp,zc,'nearest','extrap');
    tmp2 = interp1(-pt,salt_tmp,zc,'linear');
    inan=find(isnan(tmp2));
    tmp2(inan) = tmp1(inan);
    salt(:,k) = tmp2;
  end %if
end %for
ik = find(isnan(lon));
lon(ik) = [];
lat(ik) = [];
tloc(ik) = [];
theta(:,ik) = [];
salt(:,ik) = [];

nt=length(datatime);
tinit = NaN*ones(ny,nx,nz);
sinit = NaN*ones(ny,nx,nz);
warning off MATLAB:griddata:DuplicateDataPoints
ttmp = NaN*ones(ny,nx,nz);
stmp = NaN*ones(ny,nx,nz);
for k = 1:nz
  xx = lon;
  yy = lat;
  tt = theta(k,:); i0 = find(~isnan(tt));
  if length(i0) > 2
    tmp1 = griddata(xx(i0),yy(i0),tt(i0),llonc,llatc,'nearest');
    tmp2 = griddata(xx(i0),yy(i0),tt(i0),llonc,llatc,'linear');
    inan=isnan(tmp2); tmp2(inan)=tmp1(inan);
    tinit(:,:,k) = tmp2;
  end
  ss = salt(k,:); i0 = find(~isnan(ss));
  if length(i0) > 2
    tmp1 = griddata(xx(i0),yy(i0),ss(i0),llonc,llatc,'nearest');
    tmp2 = griddata(xx(i0),yy(i0),ss(i0),llonc,llatc,'linear');
    inan=isnan(tmp2); tmp2(inan)=tmp1(inan);
    sinit(:,:,k) = tmp2;
  end
end
warning on MATLAB:griddata:DuplicateDataPoints

tinit = permute(tinit,[2 1 3]);
sinit = permute(sinit,[2 1 3]);

tinit(find(isnan(tinit))) = 0;
sinit(find(isnan(sinit))) = 0;

prec='real*8';
ieee='ieee-be';
fid=fopen('../output_tmp/theta.init','w',ieee);fwrite(fid,tinit,prec);fclose(fid);
fid=fopen('../output_tmp/salt.init','w',ieee);fwrite(fid,sinit,prec);fclose(fid);

return

% check binary output
fid = fopen('../output_tmp/salt.init','r');
ieee='ieee-be';
dat1 = fread(fid,'real*8',ieee);
fclose(fid);
dat2 = reshape(dat1,[42 54 30]);

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
pcolor(llonc, llatc,squeeze(dat2(:,:,1))');shading flat
hold on; plot(lon,lat,'+'); hold off
%caxis([3 7])
caxis([33.75 33.95])
colorbar
set(gca,'PlotBoxAspectRatio',[1,1.5,1],'fontsize',16)
yticks(-50.6:0.3:-49)
xticks(1.3:0.3:3.4)
ylabel('Latitude');
xlabel('Longitude');
fout = 'salt_init.jpg';
print('-djpeg90','-r300',fout);

% cut out open boundary conditions 
% too low spacial resolution at the northmost/eastmost boundary: thus end-1!
% salinity:
sbcs=squeeze(sinit(:,1,:));
sbcn=squeeze(sinit(:,end-1,:));
sbcw=squeeze(sinit(1,:,:));
sbce=squeeze(sinit(end-1,:,:));
% temperature:
tbcs=squeeze(tinit(:,1,:));
tbcn=squeeze(tinit(:,end-1,:));
tbcw=squeeze(tinit(1,:,:));
tbce=squeeze(tinit(end-1,:,:));

prec='real*8';
ieee='ieee-be';
fid=fopen('../output_tmp/tbcs','w',ieee);fwrite(fid,tbcs,prec);fclose(fid);
fid=fopen('../output_tmp/tbcn','w',ieee);fwrite(fid,tbcn,prec);fclose(fid);
fid=fopen('../output_tmp/tbcw','w',ieee);fwrite(fid,tbcw,prec);fclose(fid);
fid=fopen('../output_tmp/tbce','w',ieee);fwrite(fid,tbce,prec);fclose(fid);
fid=fopen('../output_tmp/sbcs','w',ieee);fwrite(fid,sbcs,prec);fclose(fid);
fid=fopen('../output_tmp/sbcn','w',ieee);fwrite(fid,sbcn,prec);fclose(fid);
fid=fopen('../output_tmp/sbcw','w',ieee);fwrite(fid,sbcw,prec);fclose(fid);
fid=fopen('../output_tmp/sbce','w',ieee);fwrite(fid,sbce,prec);fclose(fid);