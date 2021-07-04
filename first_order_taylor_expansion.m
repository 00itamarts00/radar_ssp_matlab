function [x, y, z] = first_order_taylor_expansion(r_origin, az_origin, el_origin, r, az, el)
dxdr = cosd(az_origin)*sind(el_origin);
dxda = -r_origin*sind(az_origin)*sind(el_origin);
dxde = r_origin*cosd(az_origin)*sind(el_origin);

dydr = sind(az_origin)*sind(el_origin);
dyda = r_origin*cosd(az_origin)*sind(el_origin);
dyde = r_origin*sind(az_origin)*cosd(el_origin);

dzdr = cosd(el_origin);
dzda = 0;
dzde = -r_origin*sind(el_origin);

x = r_origin*cosd(az_origin)*sind(el_origin) + dxdr*(r_origin - r) + dxda*(az_origin - az) + dxde*(el_origin - el);
y = r_origin*sind(az_origin)*sind(el_origin) + dydr*(r_origin - r) + dyda*(az_origin - az) + dyde*(el_origin - el);
z = r_origin*cosd(el_origin)                 + dzdr*(r_origin - r) + dzda*(az_origin - az) + dzde*(el_origin - el);

end
