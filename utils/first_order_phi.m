function [phi] = first_order_phi(x_origin, y_origin, z_origin, x, y, z)
r0 = (x_origin^2+y_origin^2+z_origin^2)^0.5;
phi0 = acosd(z_origin/r0);

den = (sqrt(x_origin^2 + y_origin^2))*r0^2;
phix = (x_origin*z_origin) / den;
phiy = (y_origin*z_origin) / den;
phiz = (-x^2 - y^2) / den;

phi = phi0 + phix*(x-x_origin) + phiy*(y-y_origin) + phiz*(z-z_origin);

end
