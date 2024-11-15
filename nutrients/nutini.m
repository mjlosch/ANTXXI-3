% prepare initial data for biogeochemistry for EIFEX simulation
% DIN, DSi, DIC and DFe

load('../output_tmp/timeline.mat')
firstday = 31+11;
lastday  = 31+29+20;

addpath ../
nx = 42;
ny = 54;
lonb = [1.35, 3.445]; 
lon_dc = diff(lonb)/(nx-1);
lonc = ((lonb(1)+lon_dc):lon_dc:(lonb(end)+lon_dc))';
latb = [-50.55, -48.80]; 
lat_dc = diff(latb)/(ny-1);
latc = ((latb(1)+lat_dc):lat_dc:(latb(end)+lat_dc))';
[llonc,llatc,zc,nz] = create_grid(nx,ny);

data = readtable('/Users/yye/Models/EIFEX/additional_data/EIFEX_data/EIFEX_start_nuts.txt');
depth = data.Var1;
datar(:,1) = data.Var2;
datar(:,2) = data.Var3;
datar(:,3) = data.Var4;
datar(:,4) = data.Var5;

% vertical interpolation
for i = 1:4
    tmp1 = interp1(-depth,datar(:,i),zc,'nearest','extrap');
    tmp2 = interp1(-depth,datar(:,i),zc,'linear');
    inan=find(isnan(tmp2));
    tmp2(inan) = tmp1(inan);
    nut_ini(:,i) = tmp2;
end

clear nut_ini2
% horizontally 
for i=1:nz
    for j = 1:4
        nut_ini2(:,:,i,j)=repmat(nut_ini(i,j),[nx,ny]);
    end
end

prec='real*8';
ieee='ieee-be';
fid=fopen('../output_tmp/din.init','w',ieee);...
    fwrite(fid,nut_ini2(:,:,:,1),prec);fclose(fid);
fid=fopen('../output_tmp/dsi.init','w',ieee);...
    fwrite(fid,nut_ini2(:,:,:,2),prec);fclose(fid);
fid=fopen('../output_tmp/dic.init','w',ieee);...
    fwrite(fid,nut_ini2(:,:,:,3),prec);fclose(fid);
fid=fopen('../output_tmp/dfe.init','w',ieee);...
    fwrite(fid,nut_ini2(:,:,:,4),prec);fclose(fid);

% cut out open boundary conditions 
bcs=squeeze(nut_ini2(:,1,:,:));
bcn=squeeze(nut_ini2(:,end,:,:));
bcw=squeeze(nut_ini2(1,:,:,:));
bce=squeeze(nut_ini2(end,:,:,:));

prec='real*8';
ieee='ieee-be';
fid=fopen('../output_tmp/din_bcs','w',ieee);fwrite(fid,bcs(:,:,1),prec);fclose(fid);
fid=fopen('../output_tmp/din_bcn','w',ieee);fwrite(fid,bcn(:,:,1),prec);fclose(fid);
fid=fopen('../output_tmp/din_bcw','w',ieee);fwrite(fid,bcw(:,:,1),prec);fclose(fid);
fid=fopen('../output_tmp/din_bce','w',ieee);fwrite(fid,bce(:,:,1),prec);fclose(fid);
fid=fopen('../output_tmp/dsi_bcs','w',ieee);fwrite(fid,bcs(:,:,2),prec);fclose(fid);
fid=fopen('../output_tmp/dsi_bcn','w',ieee);fwrite(fid,bcn(:,:,2),prec);fclose(fid);
fid=fopen('../output_tmp/dsi_bcw','w',ieee);fwrite(fid,bcw(:,:,2),prec);fclose(fid);
fid=fopen('../output_tmp/dsi_bce','w',ieee);fwrite(fid,bce(:,:,2),prec);fclose(fid);
fid=fopen('../output_tmp/dic_bcs','w',ieee);fwrite(fid,bcs(:,:,3),prec);fclose(fid);
fid=fopen('../output_tmp/dic_bcn','w',ieee);fwrite(fid,bcn(:,:,3),prec);fclose(fid);
fid=fopen('../output_tmp/dic_bcw','w',ieee);fwrite(fid,bcw(:,:,3),prec);fclose(fid);
fid=fopen('../output_tmp/dic_bce','w',ieee);fwrite(fid,bce(:,:,3),prec);fclose(fid);
fid=fopen('../output_tmp/dfe_bcs','w',ieee);fwrite(fid,bcs(:,:,4),prec);fclose(fid);
fid=fopen('../output_tmp/dfe_bcn','w',ieee);fwrite(fid,bcn(:,:,4),prec);fclose(fid);
fid=fopen('../output_tmp/dfe_bcw','w',ieee);fwrite(fid,bcw(:,:,4),prec);fclose(fid);
fid=fopen('../output_tmp/dfe_bce','w',ieee);fwrite(fid,bce(:,:,4),prec);fclose(fid);

