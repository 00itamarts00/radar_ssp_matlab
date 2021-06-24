function [r] = first_order_r(x_origin, y_origin, z_origin, x, y, z)
r0 = (x_origin^2+y_origin^2+z_origin^2)^0.5;
rx = -x_origin*r0^(-3);
ry = -y_origin*r0^(-3);
rz = -z_origin*r0^(-3);
r = r0 + rx*(x-x_origin) + ry*(y-y_origin) + rz*(z-z_origin);
end
