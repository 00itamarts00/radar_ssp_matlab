function [r, phi, theta] = Cart_to_Sphere(x, y, z)
r = sqrt(x.^2 + y.^2 + z.^2);
phi = pi - acos(z./r);
theta = atan(y./x);
end
