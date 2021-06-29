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

el_0 = sum_digits(ran_id);
az_0 = sum_digits(itamar_id);
% el_0 = sum_digits(ran_id);
% az_0 = sum_digits(itamar_id);

sigma_r2 = get_first_digit(itamar_id, 1) / 10;
sigma_el2 = get_first_digit(itamar_id, 3) / 10;
sigma_az2 = get_first_digit(itamar_id, 4) / 10;

% plot the noise
% figure(1)
% scatter3(noise_r, noise_el, noise_az, 10, 'filled')
% xlabel('r noise')
% ylabel('el noise')
% zlabel('az noise')
% title('Plot of noise')
% grid()

% decompose velocity
V_decompose = V0_abs.*[cosd(az_0)*cosd(el_0), sind(az_0)*cosd(el_0), cosd(el_0)];
Vx = V_decompose(1);
Vy = V_decompose(2);
Vz = V_decompose(3);
% Time of flight (assuming z0=zl=0)
TOF = 2*Vz/g_acc;
N = round((TOF - T0)*Fs);
t = linspace(T0, TOF, N); 

% generating noise
mu = [0, 0, 0];
rng('default')  % For reproducibility
sigma_vec = [sigma_r2, sigma_el2, sigma_az2];
R = mvnrnd(mu, [sigma_r2, sigma_el2, sigma_az2], N);
noise_r =  R(:, 1);
noise_el = R(:, 2);
noise_az = R(:, 3);


% cartesian coordinates GT
r0 = [1000, 1000, 0];
x = r0(1) + Vx.*t;
y = r0(2) + Vy.*t;
z = r0(3) + Vz.*t -0.5*g_acc.*t.^2;

% convert xyz to rpt
[r_vec, el, az] = Cart_to_Sphere(x, y, z);
% add noise
r_n = r_vec + noise_r';
el_n = el + noise_el';
az_n = az + noise_az';

% plot projectile noisy, and gt
figure(2)
plot3(x, y, z);
grid();
xlabel('x'); ylabel('y'); zlabel('z');
hold on;
arrow3(r0, 10.*[Vx, Vy, Vz]);
title('projectile - GT/Noise');
hold on;
[xn, yn, zn] = Sphere_to_Cart(r_n, el_n, az_n);
scatter3(xn, yn, zn, 1, 'filled');
hold on;

% Estimation if x0, y0, z0
i = 1;
[x_init_est, y_init_est, z_init_est] = first_order_taylor_expansion(r_vec(i), az(i), el(i), r_n(i), az_n(i), el_n(i));
x0_est = x_init_est - Vx*t(i);
y0_est = y_init_est - Vy*t(i);
z0_est = z_init_est - Vz*t(i) + 0.5*g_acc*t(i)^2;


% Estimation if xl, yl, zl
i = length(r_vec);
[x_init_est, y_init_est, z_init_est] = first_order_taylor_expansion(r_vec(i), az(i), el(i), r_n(i), az_n(i), el_n(i));
xl_est = x_init_est + Vx*t(i) + x0_est;
yl_est = y_init_est + Vy*t(i) + y0_est;
zl_est = z_init_est + Vz*t(i) - 0.5*g_acc.*t(i)^2 +z0_est;

scatter3(x0_est, y0_est, z0_est, 50, 'filled')
scatter3(xl_est, yl_est, zl_est, 50, 'filled')

