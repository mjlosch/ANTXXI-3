a=load('m_eifex_mss_stat.tab');
load fields3d_for_boris_hour

aday=a(:,2); % I hope that this is julian day
akz = zeros(size(kppdiff,1),length(aday));
for k=1:length(aday)
  dday = julian_day-aday(k);
  [ddays,is]=sort(abs(dday));
  t1 = julian_day(is(1));
  t2 = julian_day(is(2));
  akz(:,k)= (kppdiff(:,is(1))/abs(t1-aday(k)) ...
	     + kppdiff(:,is(2))/abs(t2-aday(k)))*abs(t2-t1);
end
