function [x, y, z] = Sphere_to_Cart(r, phi, theta)
x = r.*cosd(phi).*sind(theta);
y = r.*sind(theta).*sind(phi);
z = r.*cosd(theta);
end

