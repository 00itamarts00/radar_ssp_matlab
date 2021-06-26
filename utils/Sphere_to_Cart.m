function [x, y, z] = Sphere_to_Cart(r, phi, theta)
x = r.*cosd(theta).*sind(phi);
y = r.*sind(theta).*sind(phi);
z = r.*cosd(phi);
end

