function [r, az, el] = get_first_order_spherical_est(x_origin, y_origin, z_origin, x, y, z)
r = first_order_r(x_origin, y_origin, z_origin, x, y, z);
az = first_order_theta(x_origin, y_origin, z_origin, x, y, z);
el = first_order_phi(x_origin, y_origin, z_origin, x, y, z);
end
