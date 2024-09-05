content=dir('*.fb2');

clear cast
for k=1:length(content)
  fname = content(k).name;
  str=textread(fname,'%10c',1);
  stid = num2str(str(2:end));
  str=textread(fname,'%50c',1,'headerlines',1);
  lat = str2num(str(2:6))+str2num(str(7:15))/60;
  lon = str2num(str(16:20))+str2num(str(21:end))/60;
  fld = load(fname,'-ascii');
  in = find(fld==-9999);
  fld(in) = NaN;
  cast(k).bottle = fld(:,1);
  cast(k).press  = fld(:,2);
  cast(k).temp1  = fld(:,3);
  cast(k).cond1  = fld(:,4);
  cast(k).salt1   = fld(:,5);
  cast(k).ptemp1  = fld(:,6);
  cast(k).sigth1  = fld(:,7);
  cast(k).temp2  = fld(:,8);
  cast(k).cond2  = fld(:,9);
  cast(k).salt2  = fld(:,10);
  cast(k).ptemp2  = fld(:,11);
  cast(k).sigth2  = fld(:,12);
  cast(k).xmiss  = fld(:,13);
  cast(k).fluor  = fld(:,14);
  cast(k).altm   = fld(:,15);
  cast(k).botnut = fld(:,16);
  cast(k).fuco = fld(:,17);
  cast(k).hplc_chla = fld(:,18);
  cast(k).tot_phaeopig = fld(:,19);
  cast(k).ration_phaoe_chla = fld(:,20);
  cast(k).NO2   = fld(:,21);
  cast(k).NH4   = fld(:,22);
  cast(k).Si    = fld(:,23);
  cast(k).PO4   = fld(:,24);
  cast(k).NO3   = fld(:,25);
  cast(k).DIN   = cast(k).NO2+cast(k).NH4+cast(k).NO3;
end

save botpignut cast

t=[];
s=[];
din=[];
si=[];
p=[];
for k=1:length(cast)
  p = [p; cast(k).press];
  t = [t; cast(k).ptemp1];
  s = [s; cast(k).salt1];
  din = [din; cast(k).DIN];
  si = [si; cast(k).Si];
end

ip = find(p>500);
t(ip) = [];
s(ip) = [];
din(ip) = [];
si(ip) = [];

t=s;
it   = find(~isnan(t));
is   = find(~isnan(s));
in   = find(~isnan(din));
isi  = find(~isnan(si));
itn  = intersect(it,in);
itsi = intersect(it,isi);
isn  = intersect(is,in);
issi = intersect(is,isi);

[cdin,sdin]=polyfit(t(itn),din(itn),3);
[cdsi,sdsi]=polyfit(t(itsi),si(itsi),3);

xt = linspace(min(t(:)),max(t(:)));
sh = subplot(2,1,1);
h1=plot(t(itn),din(itn),'k.',xt,polyval(cdin,xt),'r-');
title('DIN')
sh(2) = subplot(2,1,2);
h2=plot(t(itsi),si(itsi),'k.',xt,polyval(cdsi,xt),'r-');
title('Si')
xlabel('\theta')
set([h1;h2],'MarkerSize',3,'LineWidth',2)
