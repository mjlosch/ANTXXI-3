% t0 is defined as 00:00 UTC of the 13th of February, 2004, per email by
% Volker Strass of Oct26, 2006
t0 = datenum('13-Feb-2004')-datenum('01-Jan-2004');
boris = load('Boris_Stationstabelle.txt');

borisinpatch = find(boris(:,end));
borisoutpatch = find(boris(:,end)==0);
statidboris = boris(:,1)*100+boris(:,2);
t0 = datenum('13-Feb-2004')-datenum('01-Jan-2004');
timeboris = datenum(boris(:,[7 6 5 8:10]))-datenum('13-Feb-2004');


load eifexDOMxlsSheets

% DON
station=[];
time = [];
days_since_jan01=[];
hours_since_jan01=[];
depth =[];
don = [];
inpatch = [];
for k = 1:317
  statstr = don_raw{k,1};
  if ~isnan(statstr)
    statid = statstr(1:min(3,length(statstr)));
    statnr = str2num(statid);
    if ~isempty(statnr)
      castnr = statstr(4:end);
      ik = findstr(castnr,'_');
      castnr = str2num(castnr(2:ik-1));
      statid = statnr*100 + castnr;
      station = [station; statid];
      ip = find(statidboris(borisinpatch)==statid);
      op = find(statidboris(borisoutpatch)==statid);
      depth = [depth; don_raw{k,2}];
      don = [don; don_raw{k,4}];
      if ~isempty(ip)
	time = [time; timeboris(borisinpatch(ip))];
	inpatch = [inpatch; 1];
      elseif ~isempty(op)
	time = [time; timeboris(borisoutpatch(op))];
	inpatch = [inpatch; 0];
      else
	% not within eddy
	time = [time; NaN];
	inpatch = [inpatch; NaN];
      end
    end
  end
end

DON = struct('time',time,'station',station, ...
	     'days_since_jan01',t0+floor(time), ...
	     'hours_since_jan01',floor((t0+time)*24), ...
	     'depth',depth, ...
	     'don',don,'inpatch',inpatch);

% DOC
station=[];
time = [];
days_since_jan01=[];
hours_since_jan01=[];
depth =[];
doc = [];
inpatch = [];
for k = 1:size(doc_numeric,1)
  statnr = doc_numeric(k,1);
  if ~isempty(statnr)
    castnr = doc_numeric(k,2);
    statid = statnr*100 + castnr;
    station = [station; statid];
    ip = find(statidboris(borisinpatch)==statid);
    op = find(statidboris(borisoutpatch)==statid);
    depth = [depth; doc_numeric(k,5)];
    doc = [doc; doc_numeric(k,7)];
    if ~isempty(ip)
      time = [time; timeboris(borisinpatch(ip))];
      inpatch = [inpatch; 1];
    elseif ~isempty(op)
      time = [time; timeboris(borisoutpatch(op))];
      inpatch = [inpatch; 0];
    else
      % not within eddy
      time = [time; NaN];
      inpatch = [inpatch; NaN];
    end
  end
end

DOC = struct('time',time,'station',station, ...
	     'days_since_jan01',t0+floor(time), ...
	     'hours_since_jan01',floor((t0+time)*24), ...
	     'depth',depth, ...
	     'doc',doc,'inpatch',inpatch);


save eifex_DOM DON DOC -v6