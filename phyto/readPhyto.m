%
t0 = datenum('13-Feb-2004');
t1 = t0-datenum('01-Jan-2004');
load EIFEX_phytobiomass

% outpatch
% inpatch

lon = [];
lat = [];
station=[];
time = [];
depth = [];
inpatch = [];
diatoms =[];
detritus =[];

ks=1;
for k=134:size(phyto_raw{ks},1)
  statid = phyto_raw{ks}{k,2};
  if ~isempty(statid) & ~isnan(statid) & isempty(strmatch('Station',statid))
    ia = findstr(statid,'(');
    ie = findstr(statid,')');
    statnr = str2num(statid(1:ia-1));
    castnr = str2num(statid(ia+1:ie-1));
    station = [station; statnr*100+castnr];
    ip = phyto_raw{ks}{k,3};
    if findstr(ip,'Prior');
      ip=NaN;
    elseif strcmpi(ip,'In');
      ip=1;
    elseif strcmpi(ip,'Out');
      ip=0;
    end
    inpatch = [inpatch; ip];
    dstr = datenum(phyto_raw{ks}{k,4},'dd.mm.yyyy');
    tstr = phyto_raw{ks}{k,5};
    time = [time; dstr+tstr];
    lon = [lon; phyto_raw{ks}{k,8}];
    lat = [lat; phyto_raw{ks}{k,9}];
    depth = [depth; phyto_raw{ks}{k,11}];
    dtoms = phyto_raw{ks}{k,12};
    if isstr(dtoms); dtoms = str2num(dtoms); end
    diatoms = [diatoms; dtoms];
    det1 = phyto_raw{ks}{k,24+12};
    det2 = phyto_raw{ks}{k,24*2+12};
    if isstr(det1); det1 = str2num(det1); end
    if isstr(det2); det2 = str2num(det2); end
    detritus = [detritus; det1+det2];
  end
end

time0 = time - t0;
phytoData = struct('lon',lon,'lat',lat,'depth',depth, ...
		   'time',time0,'station',station, ...
		   'days_since_jan01',time - t0 + t1, ...
		   'hours_since_jan01',(time - t0 + t1)*24, ...
		   'inpatch',inpatch, ...
		   'totalDiatomsC',diatoms, ...
		   'totalDetritusC',detritus);
save eifexPhyto phytoData

return
scatter(phytoData.time,-phytoData.depth,20,phytoData.totalDiatomsC,'filled')
scatter(phytoData.time,-phytoData.depth,20,phytoData.totalDetritusC,'+')
