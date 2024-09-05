% get the station time infromation from this file:
fname='CTDstationOverview.txt';
str=textread(fname,'%s','delimiter','\t','emptyvalue',NaN);

station=[];
cast=[];
year=[];
mon =[];
day =[];
hour=[];
minute=[];
lon=[];
lat=[];
inPatch = [];
inGrid = [];
for k=12:length(str)
  if ~isempty(str{k})
    if ~isempty(findstr(str{k},'PS'))
      % begining of new row
      stid=str{k};
      i1=findstr(stid,'/');
      i2=findstr(stid,'-');
      station = [station; str2num(stid(i1+1:i2-1))];
      cast    = [cast;    str2num(stid(i2+1:end))];
      dd=str{k+1};
      day=[day; str2num(dd(1:2))];
      mon=[mon; str2num(dd(4:5))];
      year=[year; str2num(dd(7:8))];
      tt=str{k+2};
      hour=[hour; str2num(tt(1:2))];
      minute=[minute; str2num(tt(4:5))];
      ll=str{k+3};
      ik=findstr(ll,'"'); if ~isempty(ik); ll(ik) = []; end
      ik=findstr(ll,',');
      lat = [lat; -(str2num(ll(1:ik-1))+str2num(ll(ik+1:end-3))/60)];
      ll=str{k+4};
      ik=findstr(ll,'"'); if ~isempty(ik); ll(ik) = []; end
      ik=findstr(ll,',');
      lon = [lon; (str2num(ll(1:ik-1))+str2num(ll(ik+1:end-3))/60)];
      if length(lat)~=length(lon);
	keyboard
      end
      ip = str{k+9};
      if isempty(ip); ip=NaN; end
      ig=findstr(ip,'Grid');
      if isempty(ig);
	inGrid = [inGrid; 0];
      else
	inGrid = [inGrid; str2num(ip(5:end))];
      end
      inPatch = [inPatch; strcmpi(ip,'in patch')];
    end
  end
end

% define common time line days or hours since Jan01,2004
offset = zeros(size(mon));
offset(find(mon==2))=31;
offset(find(mon==3))=31+29;

days_since_jan01  = offset+day;
hours_since_jan01 = days_since_jan01*24+hour;

%
timeline=struct('station',station,'cast',cast, ...
		'days_since_jan01',days_since_jan01, ...
		'hours_since_jan01',hours_since_jan01, ...
		'lon',lon,'lat',lat,'inPatch',inPatch,'inGrid',inGrid);

save timeline timeline

