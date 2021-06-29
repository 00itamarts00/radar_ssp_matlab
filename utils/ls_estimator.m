function [x, y, z] = Sphere_to_Cart(r, phi, theta)
hx = [1, t(i)]';
x_ls = inv(h'*h)*h'
y = r.*sind(theta).*sind(phi);
z = r.*cosd(theta);
end

inv(h'*h)*h'