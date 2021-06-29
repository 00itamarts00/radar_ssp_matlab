function [r, phi, theta] = Cart_to_Sphere(x, y, z)
r = sqrt(x.^2 + y.^2 + z.^2);
theta = acosd(z./r);
phi = atan2d(y, x);
end
