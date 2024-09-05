%
te=textread('POCspMartin/pocsp_attc_method4_500_10m_edge.asc','','headerlines',1);
ti=textread('POCspMartin/pocsp_attc_method4_500_10m_in.asc','','headerlines',1);
to=textread('POCspMartin/pocsp_attc_method4_500_10m_out.asc','','headerlines',1);

% reshape

pocspin   = ti(:,3:7);
pocspout  = to(:,3:7);
pocspedge = te(:,3:7);

depthin   = ones(size(pocspin(:,1)))*[100 200 300 400 500];
depthout  = ones(size(pocspout(:,1)))*[100 200 300 400 500];
depthedge = ones(size(pocspedge(:,1)))*[100 200 300 400 500];

timein   = ti(:,2)*ones(1,size(pocspin,2));
timeout  = to(:,2)*ones(1,size(pocspout,2));
timeedge = te(:,2)*ones(1,size(pocspedge,2));

stdidin   = ti(:,1)*ones(1,size(pocspin,2));
stdidout  = to(:,1)*ones(1,size(pocspout,2));
stdidedge = te(:,1)*ones(1,size(pocspedge,2));

cmax=0.3;
plev = [0:.05:1]*cmax;

sh = subplot(321);
s1 = scatter(timein(:),-depthin(:),20,pocspin(:),'filled');
title('in patch: POC spikes [mg/m^2]')
sh(2) = subplot(322);
[cs,h1] = contourf(timein(:,1),-depthin(1,:),pocspin',plev);
set(h1,'edgecolor','none')
sh(3) = subplot(323);
s2 = scatter(timeedge(:),-depthedge(:),20,pocspedge(:),'filled');
title('edge patch: POC spikes [mg/m^2]')
sh(4) = subplot(324);
[cs,h1] = contourf(timeedge(:,1),-depthedge(1,:),pocspedge',plev);
set(h1,'edgecolor','none')
sh(5) = subplot(325);
s3 = scatter(timeout(:),-depthout(:),20,pocspout(:),'filled');
title('out patch: POC spikes [mg/m^2]')
sh(6) = subplot(326);
[cs,h1] = contourf(timeout(:,1),-depthout(1,:),pocspout',plev);
set(h1,'edgecolor','none')

set([s1;s2;s3],'SizeData',30)
set(sh,'ylim',[-500 -100],'xlim',[40 80])
set(sh,'box','on','layer','top')
set(sh,'clim',[0 cmax])
for k=2:2:6
  colorbar('peer',sh(k))
end

%return
% interpolates to a reasonable grid:
time = [40:.1:80];
depth = [100:10:500];
tfac = 40;
[t,z]=meshgrid(time,depth);
method='cubic';
in = find(~isnan(pocspin));
pin=griddata(timein(in)*tfac,depthin(in),pocspin(in),t*tfac,z,method);
ped=griddata(timeedge(:)*tfac,depthedge(:),pocspedge(:),t*tfac,z,method);
pou=griddata(timeout(:)*tfac,depthout(:),pocspout(:),t*tfac,z,method);

figure
sh = subplot(321);
s1 = scatter(timein(:),-depthin(:),20,pocspin(:),'filled');
title('in patch: POC spikes (mg/m^2)')
sh(2) = subplot(322);
[cs,h1] = contourf(time,-depth,pin,plev);
set(h1,'edgecolor','none')
hold on; ph1=plot(timein(in),-depthin(in),'k.'); hold off
title(sprintf('max. value = %f mg/m^2',max(pocspin(:))))
sh(3) = subplot(323);
s2 = scatter(timeedge(:),-depthedge(:),20,pocspedge(:),'filled');
title('edge patch: POC spikes (mg/m^2)')
sh(4) = subplot(324);
[cs,h1] = contourf(time,-depth,ped,plev);
set(h1,'edgecolor','none')
hold on; ph2=plot(timeedge(:),-depthedge(:),'k.'); hold off
title(sprintf('max. value = %f mg/m^2',max(pocspedge(:))))
sh(5) = subplot(325);
s3 = scatter(timeout(:),-depthout(:),20,pocspout(:),'filled');
title('out patch: POC spikes (mg/m^2)')
sh(6) = subplot(326);
[cs,h1] = contourf(time,-depth,pou,plev);
set(h1,'edgecolor','none')
hold on; ph3=plot(timeout(:),-depthout(:),'k.'); hold off
title(sprintf('max. value = %f mg/m^2',max(pocspout(:))))

set([s1;s2;s3],'SizeData',30)
set(sh,'ylim',[-500 -100],'xlim',[40 80])
set(sh,'clim',[0 cmax])
set(sh,'box','on','layer','top')
for k=2:2:6
  colorbar('peer',sh(k))
end
