function distance = coord_dist(lon1,lat1,lon2,lat2)
lon1 = deg2rad(lon1);
lat1 = deg2rad(lat1);
lon2 = deg2rad(lon2);
lat2 = deg2rad(lat2);
r_E = 6371*1000;
dlon = lon2 - lon1;
dlat = lat2-lat1;
a = sin(dlat/2).^2 +cos(lat1).*cos(lat2).*sin(dlon/2).^2;
c = 2*asin(sqrt(a));
distance = c*r_E;
end
