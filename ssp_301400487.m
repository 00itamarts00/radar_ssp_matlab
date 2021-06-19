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
T0 = 0.1; % sec

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
% xlabel('r noise')
% ylabel('phi noise')
% zlabel('theta noise')
% title('Plot of noise')
% grid()

% decompose velocity
V_decompose = V0_abs.*[cos(theta_0)*cos(phi_0), sin(theta_0)*cos(phi_0), sin(phi_0)];
Vx = V_decompose(1);
Vy = V_decompose(2);
Vz = V_decompose(3);
% Time of flight (assuming z0=zl=0)
TOF = 2*V0_abs/g_acc;
N = round((TOF - T0)*Fs);
t = linspace(T0, TOF, N); 

% generating noise
mu = [0, 0, 0];
rng('default')  % For reproducibility
sigma_vec = [sigma_r2, sigma_phi2, sigma_theta2];
R = mvnrnd(mu,  [sigma_r2, sigma_phi2, sigma_theta2], N);
noise_r =  R(:, 1);
noise_phi = R(:, 2);
noise_theta = R(:, 3);


% cartesian coordinates GT
r0 = [0, 0, 0];
x = r0(1) + Vx.*t;
y = r0(2) + Vy.*t;
z = r0(3) + Vz.*t -0.5*g_acc.*t.^2;

% convert xyz to rpt
[r_vec, phi, theta] = Cart_to_Sphere(x, y, z);
% add noise
r_n = r_vec + noise_r';
phi_n = phi + noise_phi';
theta_n = theta + noise_theta';

% plot projectile noisy, and gt
figure(2)
plot3(x, y, z);
grid();
xlabel('x'); ylabel('y'); zlabel('z');
hold on;
arrow3(r0, 20.*[Vx, Vy, Vz]);
title('projectile - GT/Noise');

hold on;
[xn, yn, zn] = Sphere_to_Cart(r_n, phi_n, theta_n);
scatter3(xn, yn, zn, 1, 'filled');
