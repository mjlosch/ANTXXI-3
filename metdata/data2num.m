function dp = data2num(str);
%function dp = data2num(str);

  dp = str2num(str);
  if isempty(dp); dp = NaN; end
  return
