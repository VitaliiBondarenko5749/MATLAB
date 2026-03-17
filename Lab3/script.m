%% Лабораторна робота №3
% Відновлення зображень

clear;
close all;
clc;

%% Папки
input_folder = 'images/';
output_folder = 'results/';

%% Створити results якщо немає
if ~exist(output_folder,'dir')
    mkdir(output_folder);
end

%% 1. Завантаження зображення
I = imread([input_folder 'Cameraman.jpg']);

figure
imshow(I)
title('Вихідне зображення')

%% 2. Параметри розмиття (motion blur)
LEN = 21;      % довжина зміщення
THETA = 0;     % кут руху

PSF = fspecial('motion', LEN, THETA);

%% 3. Створення змазаного зображення
blurred = imfilter(I, PSF, 'conv', 'circular');

figure
imshow(blurred)
title('Змазане зображення')

imwrite(blurred,[output_folder 'blurred.png'])

%% 4. Відновлення без шуму (Wiener)
restored = deconvwnr(blurred, PSF, 0);

figure
imshow(restored)
title('Відновлене зображення (без шуму)')

imwrite(restored,[output_folder 'restored_no_noise.png'])

%% 5. Додавання шуму
noisy = imnoise(blurred,'gaussian',0,0.001);

figure
imshow(noisy)
title('Змазане + шум')

imwrite(noisy,[output_folder 'noisy_blurred.png'])

%% 6. Відновлення з шумом
SNR = 0.01;

restored_noise = deconvwnr(noisy, PSF, SNR);

figure
imshow(restored_noise)
title('Відновлене зображення (з шумом)')

imwrite(restored_noise,[output_folder 'restored_with_noise.png'])

%% 7. Експеримент зі зміною параметрів руху
LEN2 = 35;
THETA2 = 45;

PSF2 = fspecial('motion', LEN2, THETA2);

blurred2 = imfilter(I, PSF2, 'conv','circular');

figure
imshow(blurred2)
title('Змазане зображення (інший кут руху)')

imwrite(blurred2,[output_folder 'blurred_angle.png'])

restored2 = deconvwnr(blurred2, PSF2, 0);

figure
imshow(restored2)
title('Відновлення другого варіанту')

imwrite(restored2,[output_folder 'restored_angle.png'])