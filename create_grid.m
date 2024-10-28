function [llonc,llatc,zc,nz] = create_grid(nx,ny)
% define grid based on the following information:
% coordinates of the south-west corner of the patch: 1d21m,-50d33m
% length of one grid: 3.6km
% lon and lat of the patch center: 2d15m,-49d24m
% length of one degree longitude at equator: 111.321km
% length of one degree latitude: 111.0km
% length of circumference at 49.4N: 111.321*cos(49.4)
% east-end longitude of the patch: 42*3.6/(111.321*cos(49.4))+1.35
% north-end latitude of the patch: 54*3.6/111-50.55

nx = 42;
ny = 54;

% lonc = [  1.3166,  3.4871]; lonc = (lonc(1):diff(lonc)/(nx-1):lonc(2))';
% latc = [-50.6027,-48.7902]; latc = (latc(1):diff(latc)/(ny-1):latc(2))';

lonb = [1.35, 3.445]; 
lon_dc = diff(lonb)/(nx-1);
lonc = ((lonb(1)+lon_dc):lon_dc:(lonb(end)+lon_dc))';

latb = [-50.55, -48.80]; 
lat_dc = diff(latb)/(ny-1);
latc = ((latb(1)+lat_dc):lat_dc:(latb(end)+lat_dc))';

zc = -[5:10:145 156 170.25 189.25 212.50:25:487.50]';
nz = length(zc);

[llonc,llatc,lzc]=meshgrid(lonc,latc,zc);

prec='real*8';
ieee='ieee-be';
fid=fopen('../output_tmp/lon','w',ieee);fwrite(fid,llonc,prec);fclose(fid);
fid=fopen('../output_tmp/lat','w',ieee);fwrite(fid,llatc,prec);fclose(fid);
fid=fopen('../output_tmp/dep','w',ieee);fwrite(fid,lzc,prec);fclose(fid);

gridfile = '../output_tmp/grid.nc';
nccreate(gridfile,'lon','Dimensions',{'x',42});
ncwrite(gridfile,'lon',lonc);
ncwriteatt(gridfile,"lon","description","longitude")
nccreate(gridfile,'lat','Dimensions',{'y',54});
ncwrite(gridfile,'lat',latc);
ncwriteatt(gridfile,"lat","description","latitude")
nccreate(gridfile,'depth','Dimensions',{'z',30});
ncwrite(gridfile,'depth',zc);
ncwriteatt(gridfile,"depth","description","center of vertical layer")
ncwriteatt(gridfile,"depth","unit","meter")


