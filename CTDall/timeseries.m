d=dir('*.AWI');

data = cell(size(d));
for k = 1:length(d);
  fname = d(k).name;
  data{k} = loadctd(fname);
end
time = [];
for k = 1:length(data);
  tmp = data{k}.time;
  time = [time; tmp(1)*1+tmp(2)*100+tmp(3)*10000+(tmp(4)+tmp(5)/60)/24];
end
[stime,i]=sort(time);
datatmp = data;
for k = 1:length(i)
  data{k}=datatmp{i(k)};
end
clear datatmp

load('../timeline.mat')
tlid=timeline.station*100+timeline.cast;

stdpres = [0:4100]';
theta = NaN*ones(length(stdpres),length(data));
salt  = NaN*ones(length(stdpres),length(data));
for k = 1:length(data);
  lon(k) = data{k}.lon;
  lat(k) = data{k}.lat;
  ik=find(data{k}.stid==tlid);
  % assign a value of the general time line, in addition to the
  % local time variable
  if isempty(ik)
    data{k}.days_since_jan01  = NaN;
    data{k}.hours_since_jan01 = NaN;
  else
    data{k}.days_since_jan01  = timeline.days_since_jan01(ik);
    data{k}.hours_since_jan01 = timeline.hours_since_jan01(ik);
  end
  tmp = data{k}.time;
  time(k) = tmp(1)*1+tmp(2)*100+tmp(3)*10000+(tmp(4)+tmp(5)/60)/24;
  prestmp = data{k}.pres;
  [pt,itu] = unique(prestmp);
  [ps,its] = unique(prestmp);
  theta_tmp = data{k}.theta(itu);
  it = find(theta_tmp==-999);
  theta_tmp(it) = []; pt(it) = [];
  theta(:,k) = interp1(pt,theta_tmp,stdpres,'linear');
  salt_tmp = data{k}.salt(its);
  is=find(salt_tmp==-999);
  salt_tmp(it) = []; ps(it) = [];
  salt(:,k)  = interp1(ps,salt_tmp,stdpres,'linear');
end

save antxxi3 data 
