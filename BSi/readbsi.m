load eifex_bsi

bsi.lon = bsiNum(:,1);
bsi.lat = bsiNum(:,2);
month = bsiNum(:,4);
month(find(month==3)) = 31+29;
month(find(month==2)) = 31;
bsi.julian_day = month + (bsiNum(:,3)-1) + (bsiNum(:,6) + bsiNum(:,7)/60)/24;
bsi.station = bsiNum(:,8);
bsi.cast = bsiNum(:,9);
bsi.depth = bsiNum(:,10);
bsi.concentration = bsiNum(:,11);
bsi.standingStock = bsiNum(:,12);

save eifex_bsi bsi -append
