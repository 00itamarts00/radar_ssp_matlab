function Plot_rpt_with_noise(t, r, rn, rc, tt, ttn, ttc, p, pn, pc)
figure()
subplot(3,1,1)
plot(t, r)
hold on;
scatter(t, rn, 1, 'r')
hold on;
scatter(t, rc, 1, 'b')
grid()
title('r vs time')
subplot(3,1,2)
plot(t, tt)
hold on;
scatter(t, ttn, 1, 'r')
hold on;
scatter(t, ttc, 1, 'b')
grid()
title('theta vs time')
subplot(3,1,3)
plot(t, p)
hold on;
scatter(t, pn, 1, 'r')
hold on;
scatter(t, pc, 1, 'b')
grid()
title('phi vs time')
end
