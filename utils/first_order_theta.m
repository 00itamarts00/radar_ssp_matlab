function [theta] = first_order_theta(x_origin, y_origin, z_origin, x, y, z)
tmp = z_origin * z;
theta0 = atan2d(y, x);
theta_x = -y_origin/(x_origin^2 + y_origin^2);
theta_y = x_origin/(x_origin^2 + y_origin^2);
theta = theta0 + theta_x*(x-x_origin) + theta_y*(y-y_origin);
end
