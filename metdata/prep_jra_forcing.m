dir = '/Users/yye/Models/OIF/eifex_input/';
file = 'prra_2004';
fid = fopen([dir,file],'r');
ieee='ieee-be';
prec1 = fread(fid,'real*4',ieee);
fclose(fid);
prec2 = reshape(prec1,[640 320 2928]);

file = 'rsds_2004';
fid = fopen([dir,file],'r');
ieee='ieee-be';
swlw1 = fread(fid,'real*4',ieee);
fclose(fid);
swlw2 = reshape(swlw1,[640 320 2928]);


% jra grid
lonc = 0.5625/2:0.5625:360;
latc = zeros(1,320)*NaN;
latc(1) = -89.57009;
inc1 = [0.556914, 0.560202, 0.560946, 0.561227, 0.561363,...
       0.561440, 0.561487, 0.561518, 0.561539, 0.561554,...
       0.561566, 0.561575, 0.561582, 0.561587, 0.561592];
inc2 = zeros(1,289)+0.561619268965519;
inc3 = [0.561592, 0.561587, 0.561582, 0.561575, 0.561566,...
        0.561554, 0.561539, 0.561518, 0.561487, 0.561440,...
        0.561363, 0.561227, 0.560946, 0.560202, 0.556914];
inc = [inc1,inc2,inc3];
for i = 1:length(inc)
    latc(i+1) = latc(i) + inc(i);
end

% find nearest jra data to eifex grid
lonb = [1.35, 3.445]; 
lon_dc = diff(lonb)/(42-1);
lonc2 = ((lonb(1)+lon_dc):lon_dc:(lonb(end)+lon_dc))';

latb = [-50.55, -48.80]; 
lat_dc = diff(latb)/(54-1);
latc2 = ((latb(1)+lat_dc):lat_dc:(latb(end)+lat_dc))';

[X,Y] = ndgrid(lonc,latc);
F = griddedInterpolant(X,Y,prec2);
[X2,Y2] = ndgrid(lonc2,latc2);
prec3 = F(lonc2,latc2);

% for i = 1:54
%     ydiff = abs(latc - latc2(i));
%     [m,iy(i)] = min(ydiff);
% end
% for j = 1:42
%     xdiff = abs(lonc - lonc2(j));
%     [n,ix(j)] = min(xdiff);
% end
% sw_down = swlw2(ix,iy,t1:tn);

t1 = 20*8+7;
tn = t1+507;
precip = prec3(:,:,t1:tn);

prec='real*8';
ieee='ieee-be';
fid=fopen('../output_tmp/precip.42x54.3hourly','w',ieee);fwrite(fid,precip,prec);fclose(fid);
fid=fopen('../output_tmp/swdown.42x54.3hourly','w',ieee);fwrite(fid,sw_down,prec);fclose(fid);
