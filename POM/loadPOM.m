load EIFEX_final_PONPOC
load ../timeline

in=[];
for k = 1:size(raw,1)
  if isfloat(raw{k,1})&~isnan(raw{k,1})
    in = [in; k];
  end
end
raw2 = cell(length(in),8);
for k = 1:length(in)
  for kk = 1:8
    raw2{k,kk} = raw{in(k),kk};
  end
end
for k = 1:size(raw2,1)
  POM.station(k) = raw2{k,3};
  if isnan(POM.station(k)); POM.station(k) = POM.station(k-1); end
  cast = raw2{k,4};
  if ~isfloat(cast) 
    POM.cast(k)    = POM.cast(k-1);
  else
    POM.cast(k) = cast;
  end
  kt = find(POM.station(k)==timeline.station&POM.cast(k)==timeline.cast);
  if isempty(kt); 
    kt = find(POM.station(k)==timeline.station); 
  end
  kt = kt(1);
  POM.days_since_jan01(k)  = timeline.days_since_jan01(kt);
  POM.hours_since_jan01(k) = timeline.hours_since_jan01(kt);
  POM.inPatch(k) = timeline.inPatch(kt);
  POM.inPatchPOM(k) = 0;
  if findstr(raw2{k,8},'IN PATCH')
    POM.inPatchPOM(k) = 1;
  end
  POM.lon(k)     = raw2{k,2};
  POM.lat(k)     = raw2{k,1};
  POM.depth(k)   = raw2{k,5};
  POM.PON(k)     = raw2{k,6};
  POM.POC(k)     = raw2{k,7};
end
  
save -v6 EIFEX_POM POM
