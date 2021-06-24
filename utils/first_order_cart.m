function [x, y, z] = first_order_cart(r_origin, az_origin, el_origin, r, az, el)
x = first_order_x(r_origin, az_origin, el_origin, r, az, el);
y = first_order_y(r_origin, az_origin, el_origin, r, az, el);
z = first_order_z(r_origin, az_origin, el_origin, r, az, el);
end

function [x] = first_order_x(r_origin, az_origin, el_origin, r, az, el)
dr = cosd(az_origin)*sind(el_origin);
daz = -r_origin*sind(az_origin)*sind(el_origin);
del = r_origin*cosd(az_origin)*cos(el_origin);
x = r_origin*cosd(az_origin)*sind(el_origin) + dr*(r-r_origin) + daz*(az-az_origin) + del*(el - el_origin);
end

function [y] = first_order_y(r_origin, az_origin, el_origin, r, az, el)
dr = sind(az_origin)*sind(el_origin);
daz = r_origin*cosd(az_origin)*sind(el_origin);
del = r_origin*sind(az_origin)*cosd(el_origin);
y = r_origin*sind(az_origin)*sind(el_origin) + dr*(r-r_origin) + daz*(az-az_origin) + del*(el - el_origin);
end

function [z] = first_order_z(r_origin, az_origin, el_origin, r, az, el)

dr = cosd(el_origin);
del = -r*sind(el_origin);
daz = 0;
z = r_origin*cosd(az_origin)*sind(el_origin)+ dr*(r-r_origin) + daz*(az-az_origin) + del*(el - el_origin);
end
