load eifex_cdata

inpatchstations = [424 466 508 511 540 543 544 545 553 580 591 593];
outpatchstations= [ 464 470 509 587 ];

ip = find(ismember(cData.station,inpatchstations));

h = scatter(cData.time(ip),-cData.depth(ip),20,cData.tco2(ip),'filled');
set(gca,'ylim',[-500 0],'clim',[2115 2250])
colorbar('h')
title('observed TCO2 [mol/l]')
ylabel('depth [m]')

hmax = 150;
z = -[0:1:hmax]';
for k=1:length(inpatchstations);
  ip = find(cData.station==inpatchstations(k));
  co2  = interp1(-cData.depth(ip),cData.tco2(ip),z,'linear');
  co2n = interp1(-cData.depth(ip),cData.tco2(ip),z,'nearest','extrap');
  in = find(isnan(co2));
  co2(in) = co2n(in);
  totco2(k) = trapz(z,co2)/hmax;
end