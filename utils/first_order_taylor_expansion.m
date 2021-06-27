function [x, y, z] = first_order_taylor_expansion(r_origin, az_origin, el_origin, r, az, el)
dxdr = cosd(az_origin)*sind(el_origin);
dxda = -r_origin*sind(az_origin)*sind(el_origin);
dxde = r_origin*cosd(az_origin)*sind(el_origin);

dydr = sind(az_origin)*sind(el_origin);
dyda = r_origin*cosd(az_origin)*sind(el_origin);
dyde = r_origin*sind(az_origin)*cosd(el_origin);

dzdr = cosd(el_origin);
dzda = 0;
dzde = -r_origin*cosd(el_origin);

x = r_origin*cosd(az_origin)*sind(el_origin) + dxdr*(r-r_origin) + dxda*(az - az_origin) + dxde*(el - el_origin);
y = r_origin*sind(az_origin)*sind(el_origin) + dydr*(r-r_origin) + dyda*(az - az_origin) + dyde*(el - el_origin);
z = r_origin*sind(el_origin) + dzdr*(r-r_origin) + dzda*(az - az_origin) + dzde*(el - el_origin);

end
