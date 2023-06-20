freq_min = 0;
freq_max = 22050;
f = linspace(-0.5, 0.5, 3000);
Magnitude_95 = abs(1 - 0.95 * exp(-1i*2*pi*f));
Magnitude_99 = abs(1 - 0.99 * exp(-1i*2*pi*f));
Magnitude_65 = abs(1 - 0.65 * exp(-1i*2*pi*f));

figure(1)
plot(f * 2 * pi, Magnitude_95, '-', 'linewidth', 2)
ylabel('Magnitude Response');
xlabel('frequency(from -pi to pi)');
title('Magnitude response of Pre-emphasized with coeff = 0.95');

figure(2)
plot(f * 2 * pi, Magnitude_99, '-', 'linewidth', 2)
ylabel('Magnitude Response');
xlabel('frequency(from -pi to pi)');
title('Magnitude response of Pre-emphasized with coeff = 0.99');

figure(3)
plot(f * 2 * pi, Magnitude_65, '-', 'linewidth', 2)
ylabel('Magnitude Response');
xlabel('frequency(from -pi to pi)');
title('Magnitude response of Pre-emphasized with coeff = 0.65');

