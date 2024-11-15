% read GLODAP TALK
dir = '/Users/yye/Models/Gledhill/GLODAPv2.2016b_MappedClimatologies/init4MITgcm/';
file = 'GLODAP_TALK_180x126x30_rtopo_mmol.bin';
fid = fopen([dir,file],'r');
ieee='ieee-be';
alk1 = fread(fid,'real*8',ieee);
fclose(fid);
alk2 = reshape(alk1,[180 126 30]);

% mitgcm grid
addpath ~/matlab_central
modelrun0 = '/Users/yye/Models/recom_Fe_isotope/model_output/run_ollie';
filename = [modelrun0,'/grid_glue.nc'];
grid = read_one_netcdf(filename);
X = grid.XC;
Y = grid.YC;

% interpolate GLODAP data to eifex grid
nx = 42;
ny = 54;

lonb = [1.35, 3.445]; 
lon_dc = diff(lonb)/(nx-1);
lonc2 = ((lonb(1)+lon_dc):lon_dc:(lonb(end)+lon_dc))';

latb = [-50.55, -48.80]; 
lat_dc = diff(latb)/(ny-1);
latc2 = ((latb(1)+lat_dc):lat_dc:(latb(end)+lat_dc))';

[X2,Y2] = ndgrid(lonc2,latc2);

for i = 1:length(grid.Z)
    F = griddedInterpolant(X,Y,alk2(:,:,i));
    alk3(:,:,i) = F(X2,Y2);
end

% vertical interpolation
addpath ../
[llonc,llatc,zc,nz] = create_grid(nx,ny);
for i = 1:nx
    for j = 1:ny
        tmp1 = interp1(grid.Z,squeeze(alk3(i,j,:)),zc,'nearest','extrap');
        tmp2 = interp1(grid.Z,squeeze(alk3(i,j,:)),zc,'linear');
        inan=find(isnan(tmp2));
        tmp2(inan) = tmp1(inan);
        alk4(i,j,:) = tmp2;
    end
end

prec='real*8';
ieee='ieee-be';
fid=fopen('../output_tmp/alk.init','w',ieee);...
    fwrite(fid,alk4,prec);fclose(fid);

bcs=squeeze(alk4(:,1,:));
bcn=squeeze(alk4(:,end,:));
bcw=squeeze(alk4(1,:,:));
bce=squeeze(alk4(end,:,:));

prec='real*8';
ieee='ieee-be';
fid=fopen('../output_tmp/alk_bcs','w',ieee);fwrite(fid,bcs,prec);fclose(fid);
fid=fopen('../output_tmp/alk_bcn','w',ieee);fwrite(fid,bcn,prec);fclose(fid);
fid=fopen('../output_tmp/alk_bcw','w',ieee);fwrite(fid,bcw,prec);fclose(fid);
fid=fopen('../output_tmp/alk_bce','w',ieee);fwrite(fid,bce,prec);fclose(fid);



