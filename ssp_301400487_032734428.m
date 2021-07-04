% start
clear all;
close all;

% PARAMS
itamar_id = 301400487;
% Change to the correct ID
ran_id = 032734428; 
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
R = mvnrnd([0, 0, 0], [sigma_r2, sigma_phi2, sigma_theta2].*10, N);
noise_r =  R(:, 1);
noise_phi = R(:, 2);
noise_theta = R(:, 3);

% plot the noise
figure()
grid();
scatter3(noise_r, noise_phi, noise_theta, 10, 'filled')
xlabel('r noise')
ylabel('phi noise');
zlabel('theta noise');
title('Plot of noise');

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
%%%%%%%%%%%%%%%%%%%%%

% plot projectile noisy, and gt
figure(2)
plot3(x, y, z, 'linewidth',3);
grid();
xlabel('x'); ylabel('y'); zlabel('z');
hold on;
title('projectile - GT/Noise');
hold on;

% ML Estimation
[x_ml, y_ml, z_ml] = sphere_to_cart_noisy(r_n, phi_n, theta_n);
scatter3(x_ml, y_ml, z_ml, 1, 'filled');
hold on;

% LS Estimation at r0
i = 1;
[x0_ls, y0_ls, z0_ls] = ls_estimator(t(i), x_ml(i), y_ml(i), z_ml(i));
scatter3(x0_ls, y0_ls, z0_ls, 50, 'filled')
hold on;

% CRB
VAR_x0_ml_fo = sigma_theta2*(r_n(i)*cosd(phi_n(i))*cosd(theta_n(i)))^2 + sigma_phi2*(r_n(i)*sind(phi_n(i))*sind(theta_n(i)))^2 + sigma_r2*(cosd(phi_n(i))*sind(theta_n(i)))^2;
CRB_x0_ml_fo = 1/VAR_x0_ml_fo;

VAR_y0_ml_fo = sigma_theta2*(r_n(i)*sind(phi_n(i))*cosd(theta_n(i)))^2 + sigma_phi2*(r_n(i)*cosd(phi_n(i))*sind(theta_n(i)))^2 + sigma_r2*(sind(phi_n(i))*sind(theta_n(i)))^2;
CRB_y0_ml_fo = 1/VAR_y0_ml_fo;

VAR_z0_ml_fo = sigma_theta2*(r_n(i)*sind(theta_n(i)))^2 + sigma_r2*(cosd(theta_n(i)))^2;
CRB_z0_ml_fo = 1/VAR_z0_ml_fo;

% LS Estimation given hit point
i = length(x_ml);
[xl_ls, yl_ls, zl_ls] = ls_estimator(t(i), x_ml(i), y_ml(i), z_ml(i));
scatter3(xl_ls, yl_ls, zl_ls, 50, 'filled')
hold on;

% CRB
VAR_xl_ml_fo = sigma_theta2*(r_n(i)*cosd(phi_n(i))*cosd(theta_n(i)))^2 + sigma_phi2*(r_n(i)*sind(phi_n(i))*sind(theta_n(i)))^2 + sigma_r2*(cosd(phi_n(i))*sind(theta_n(i)))^2;
CRB_xl_ml_fo = 1/VAR_xl_ml_fo;

VAR_yl_ml_fo = sigma_theta2*(r_n(i)*sind(phi_n(i))*cosd(theta_n(i)))^2 + sigma_phi2*(r_n(i)*cosd(phi_n(i))*sind(theta_n(i)))^2 + sigma_r2*(sind(phi_n(i))*sind(theta_n(i)))^2;
CRB_yl_ml_fo = 1/VAR_yl_ml_fo;

VAR_zl_ml_fo = sigma_theta2*(r_n(i)*sind(theta_n(i)))^2 + sigma_r2*(cosd(theta_n(i)))^2;
CRB_zl_ml_fo = 1/VAR_zl_ml_fo;

