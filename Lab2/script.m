%% Лабораторна робота №2
% Фільтрація й придушення шумів

clear;
close all;
clc;

%% Шляхи до папок
input_folder = 'images/';
output_folder = 'results/';

%% Завантаження зображень
I1 = imread([input_folder 'Eight.png']);
I2 = imread([input_folder 'Moon.jpg']);

figure, imshow(I1), title('Вихідне зображення 1');
figure, imshow(I2), title('Вихідне зображення 2');

%% 1. Додавання гаусівського шуму
gauss1 = imnoise(I1,'gaussian',0,0.01);
gauss2 = imnoise(I2,'gaussian',0,0.01);

figure, imshow(gauss1), title('Gaussian noise image1');
figure, imshow(gauss2), title('Gaussian noise image2');

imwrite(gauss1,[output_folder 'gaussian_eight.png']);
imwrite(gauss2,[output_folder 'gaussian_moon.jpg']);

%% 2. Додавання salt & pepper шуму
sp1 = imnoise(I1,'salt & pepper',0.05);
sp2 = imnoise(I2,'salt & pepper',0.05);

figure, imshow(sp1), title('Salt & Pepper image1');
figure, imshow(sp2), title('Salt & Pepper image2');

imwrite(sp1,[output_folder 'sp_eight.png']);
imwrite(sp2,[output_folder 'sp_moon.jpg']);

%% 3. Низькочастотна фільтрація
h_low = ones(3,3)/9;

low1 = imfilter(gauss1,h_low);
low2 = imfilter(gauss2,h_low);

figure, imshow(low1), title('Low-pass filter image1');
figure, imshow(low2), title('Low-pass filter image2');

imwrite(low1,[output_folder 'lowpass_eight.png']);
imwrite(low2,[output_folder 'lowpass_moon.jpg']);

%% 4. Високочастотна фільтрація
h_high = [0 -1 0;
          -1 5 -1;
          0 -1 0];

high1 = imfilter(I1,h_high);
high2 = imfilter(I2,h_high);

figure, imshow(high1), title('High-pass filter image1');
figure, imshow(high2), title('High-pass filter image2');

imwrite(high1,[output_folder 'highpass_eight.png']);
imwrite(high2,[output_folder 'highpass_moon.jpg']);

%% 5. Wiener фільтр

% перевірка чи зображення RGB
if size(gauss1,3) == 3
    gauss1_gray = rgb2gray(gauss1);
else
    gauss1_gray = gauss1;
end

if size(gauss2,3) == 3
    gauss2_gray = rgb2gray(gauss2);
else
    gauss2_gray = gauss2;
end

wiener1 = wiener2(gauss1_gray,[5 5]);
wiener2_img = wiener2(gauss2_gray,[5 5]);

figure, imshow(wiener1), title('Wiener filter image1');
figure, imshow(wiener2_img), title('Wiener filter image2');

imwrite(wiener1,[output_folder 'wiener_eight.png']);
imwrite(wiener2_img,[output_folder 'wiener_moon.jpg']);

%% 6. Медіанна фільтрація

if size(sp1,3) == 3
    sp1 = rgb2gray(sp1);
end

if size(sp2,3) == 3
    sp2 = rgb2gray(sp2);
end

median1 = medfilt2(sp1);
median2 = medfilt2(sp2);

figure, imshow(median1), title('Median filter image1');
figure, imshow(median2), title('Median filter image2');

imwrite(median1,[output_folder 'median_eight.png']);
imwrite(median2,[output_folder 'median_moon.jpg']);

%% 7. Спеціальний фільтр fspecial
h_unsharp = fspecial('unsharp');

sharp1 = imfilter(I1,h_unsharp);
sharp2 = imfilter(I2,h_unsharp);

figure, imshow(sharp1), title('Unsharp image1');
figure, imshow(sharp2), title('Unsharp image2');

imwrite(sharp1,[output_folder 'unsharp_eight.png']);
imwrite(sharp2,[output_folder 'unsharp_moon.jpg']);