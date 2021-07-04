function [r, az, el] = get_first_order_spherical_est(x_origin, y_origin, z_origin, x, y, z)
r = first_order_r(x_origin, y_origin, z_origin, x, y, z);
az = first_order_theta(x_origin, y_origin, z_origin, x, y, z);
el = first_order_phi(x_origin, y_origin, z_origin, x, y, z);
end

function [r] = first_order_r(x_origin, y_origin, z_origin, x, y, z)
r0 = (x_origin^2+y_origin^2+z_origin^2)^0.5;
rx = -x_origin*r0^(-3);
ry = -y_origin*r0^(-3);
rz = -z_origin*r0^(-3);
r = r0 + rx*(x-x_origin) + ry*(y-y_origin) + rz*(z-z_origin);
end

function [phi] = first_order_phi(x_origin, y_origin, z_origin, x, y, z)
r0 = (x_origin^2+y_origin^2+z_origin^2)^0.5;
phi0 = acosd(z_origin/r0);

den = (sqrt(x_origin^2 + y_origin^2))*r0^2;
phix = (x_origin*z_origin) / den;
phiy = (y_origin*z_origin) / den;
phiz = (-x^2 - y^2) / den;

phi = phi0 + phix*(x-x_origin) + phiy*(y-y_origin) + phiz*(z-z_origin);

end

function [theta] = first_order_theta(x_origin, y_origin, z_origin, x, y, z)
tmp = z_origin * z;
theta0 = atan2d(y, x);
theta_x = -y_origin/(x_origin^2 + y_origin^2);
theta_y = x_origin/(x_origin^2 + y_origin^2);
theta = theta0 + theta_x*(x-x_origin) + theta_y*(y-y_origin);
end
