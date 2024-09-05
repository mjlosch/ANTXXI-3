% load model data
load fields3d_for_boris_hour

% load mss mixed layer data
fid = fopen('mss-amld-mld.txt');
fgetl(fid); % skip header line
mss = fscanf(fid,'%f%f%f%f%f%f',inf);
fclose(fid);
mss = reshape(mss,[6 length(mss)/6])';
% load ctd mixed layer data
fid = fopen('ctd-mld.txt');
fgetl(fid); % skip header line
ctd = fscanf(fid,'%f%f%f%f%f',inf);
fclose(fid);
ctd = reshape(ctd,[5 length(ctd)/5])';

% interpolate/bin
fld = kppdiffm;
nz = size(fld,1);
fldmss = zeros(nz,size(mss,1));
method = 'nearest';
for k=1:size(mss,1)
  fldmss(:,k)=interp2(julian_day,zg(1:nz),fld,mss(k,2),zg(1:nz),method);
end


clf
sh = subplot(211);
h = plot(julian_day,-mld,'-', ...
	 mss(:,2),-mss(:,5),'+', ...
	 ctd(:,2),-ctd(:,5),'x');
set(h(2:3),'lineWidth',2);
lh = legend('model','MSS','CTD',-1);
ylabel('depth [m]')
title('mixed layer depth (MLD)')

sh = subplot(212);
h = plot(julian_day,-hbl,'-', ...
	 mss(:,2),-mss(:,6),'+');
set(h(2),'lineWidth',2);

lh = legend('model','MSS',-1);
ylabel('depth [m]'); xlabel('julian day')
title('actively mixed layer depth (h_{bl})')

print -dpng -painters mixed_layer.png
%print -depsc -painters mixed_layer.eps

d=load('eifex_K_mss.mat');
ah = axes;
set(ah,'nextplot','replacechildren');
clear mov
for k=1:length(d.jday)
  clf
  h=plot(fldmss(:,k),-zg,'--',d.iKT(:,k),-d.z,'-');
  set(h,'lineWidth',1);
  set(gca,'xlim',[0 .16],'ylim',[-200 0])
  lh=legend('model','MSS',4);
  str = to_date(2004,d.jday(k));
  title(sprintf('\\kappa_{T} on %s', str(1:10)))
  ylabel('depth [m]'); xlabel('\kappa_{T} [m^2 s^{-1}]')
  drawnow
  print(gcf,'-dpng',sprintf('profile%02u.png',k));
  mov(k) = getframe(gcf);
%  pause
end
%movie2avi(mov,'profiles.avi','fps',1)
