function [xls, yls, zls] = ls_estimator(t, xml, yml, zml)
hx = [1, t]';
res = inv(hx'*hx)*hx'*xml;
x0_ls = res(1); v0x_ls = res(2);
hy = [1, t]';
res = inv(hy'*hy)*hy'*yml;
y0_ls = res(1); v0y_ls = res(2);
hz = [1, t, t^2]';
res = inv(hz'*hz)*hz'*zml;
z0_ls = res(1); v0z_ls = res(2); g_z = res(3);

xls = x0_ls+v0x_ls*t;
yls = y0_ls+v0y_ls*t;
zls = z0_ls+v0z_ls*t-0.5*g_z^2;
end