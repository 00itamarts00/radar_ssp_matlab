function [x, y, z] = Sphere_to_Cart(r, phi, theta)
x = r.*cos(theta).*sin(phi);
y = r.*sin(theta).*sin(phi);
z = r.*cos(phi - pi);
end
