% start
clear;
close all;

% PARAMS
itamar_id = 301400487;
% Change to the correct ID
ran_id = 301400487; 
V0_limits = [500, 1000]; % m/s
g_acc = 10; % m/s^2
Fs = 100; % samples/sec
T_start = 0.1; % sec

% INIT
V0_abs = unifrnd(V0_limits(1), V0_limits(2));

phi_0 = sum_digits(ran_id);
theta_0 = sum_digits(itamar_id);

sigma_r2 = get_first_digit(itamar_id, 1) / 10;
sigma_phi2 = get_first_digit(itamar_id, 3) / 10;
sigma_theta2 = get_first_digit(itamar_id, 4) / 10;

% plot the noise
% figure(1)
% scatter3(noise_r, noise_phi, noise_theta, 10, 'filled')
% xlabphi('r noise')
% ylabphi('phi noise')
% zlabphi('theta noise')
% title('Plot of noise')
% grid()

% decompose vphiocity
V_decompose = V0_abs.*[cosd(phi_0)*sind(theta_0), sind(phi_0)*sind(theta_0), cosd(theta_0)];
Vx = V_decompose(1);
Vy = V_decompose(2);
Vz = V_decompose(3);
% Time of flight (assuming z0=zl=0)
TOF = 2*Vz/g_acc;
N = round((TOF - T_start)*Fs);
t = linspace(T_start, TOF, N); 

% generating noise
rng('default')  % For reproducibility
sigma_vec = [sigma_r2, sigma_phi2, sigma_theta2];
R = mvnrnd([0, 0, 0], [sigma_r2, sigma_phi2, sigma_theta2], N);
noise_r =  R(:, 1);
noise_phi = R(:, 2);
noise_theta = R(:, 3);


% cartesian coordinates GT
xyz0 = [1000, 1000, 1000];
x = xyz0(1) + Vx.*t;
y = xyz0(2) + Vy.*t;
z = xyz0(3) + Vz.*t -0.5*g_acc.*t.^2;

% convert xyz to rpt
[r_vec, phi, theta] = Cart_to_Sphere(x, y, z);
% add noise
r_n = r_vec + noise_r';
phi_n = phi + noise_phi';
theta_n = theta + noise_theta';
%%%%%%%%%%%%%%%%%%%%%5

% plot projectile noisy, and gt
figure(2)
plot3(x, y, z);
grid();
xlabel('x'); ylabel('y'); zlabel('z');
hold on;
% arrow3(xyz0, [Vx, Vy, Vz]);
title('projectile - GT/Noise');
hold on;

% ML Estimation if x0, y0, z0
[x_ml, y_ml, z_ml] = Sphere_to_Cart(r_n, phi_n, theta_n);
scatter3(x_ml, y_ml, z_ml, 1, 'filled');
hold on;

% LS Estimation given
i = 1;
hx = [1, t(i)]';
res = inv(hx'*hx)*hx'*x_ml(i);
x0_ls = res(1); v0x_ls = res(2);
hy = [1, t(i)]';
res = inv(hy'*hy)*hy'*y_ml(i);
y0_ls = res(1); v0y_ls = res(2);
hz = [1, t(i), t(i)^2]';
res = inv(hz'*hz)*hz'*z_ml(i);
z0_ls = res(1); v0z_ls = res(2); g_z = res(3);

scatter3(x0_ls, y0_ls, z0_ls, 50, 'filled')

% CRB
VAR_x_ml_fo = sigma_theta2*(r_n(i)*cosd(phi_n(i))*cosd(theta_n(i)))^2 + sigma_phi2*(r_n(i)*sind(phi_n(i))*sind(theta_n(i)))^2 + sigma_r2*(cosd(phi_n(i))*sind(theta_n(i)))^2;
CRB_x_ml_fo = 1/VAR_x_ml_fo;

VAR_y_ml_fo = sigma_theta2*(r_n(i)*sind(phi_n(i))*cosd(theta_n(i)))^2 + sigma_phi2*(r_n(i)*cosd(phi_n(i))*sind(theta_n(i)))^2 + sigma_r2*(sind(phi_n(i))*sind(theta_n(i)))^2;
CRB_y_ml_fo = 1/VAR_y_ml_fo;

VAR_z_ml_fo = sigma_theta2*(r_n(i)*sind(theta_n(i)))^2 + sigma_r2*(cosd(theta_n(i)))^2;
CRB_z_ml_fo = 1/VAR_z_ml_fo;


% LS Estimation given
i = length(x_ml);
hx = [1, t(i)]';
res = inv(hx'*hx)*hx'*x_ml(i);
x0_ls = res(1); v0x_ls = res(2);
hy = [1, t(i)]';
res = inv(hy'*hy)*hy'*y_ml(i);
y0_ls = res(1); v0y_ls = res(2);
hz = [1, t(i), t(i)^2]';
res = inv(hz'*hz)*hz'*z_ml(i);
z0_ls = res(1); v0z_ls = res(2); g_z = res(3);

scatter3(x0_ls+v0x_ls*t(i), y0_ls+v0y_ls*t(i), z0_ls+v0z_ls*t(i)-0.5*g_z^2, 50, 'filled')


