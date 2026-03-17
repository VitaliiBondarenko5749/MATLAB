%% Лабораторна робота №4
% Просторові перетворення зображень
% ДПФ, спектри, fftshift, ifft2, фільтрація у частотній і просторовій області

clear;
close all;
clc;

cd MATLAB/Lab4/

%% Шляхи до папок
input_folder = 'images/';
output_folder = 'results/';

if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%% 1. Завантаження зображень
f1 = imread([input_folder 'Cameraman.jpg']);
f2 = imread([input_folder 'Moon.jpg']);

% Якщо випадково RGB — перевести в grayscale
if ndims(f1) == 3
    f1 = rgb2gray(f1);
end

if ndims(f2) == 3
    f2 = rgb2gray(f2);
end

figure, imshow(f1), title('Вихідне зображення cameraman');
figure, imshow(f2), title('Вихідне зображення moon');

imwrite(f1, [output_folder 'original_cameraman.png']);
imwrite(f2, [output_folder 'original_moon.png']);

%% 2. Двовимірне ДПФ і спектри
F1 = fft2(f1);
F2 = fft2(f2);

S1 = abs(F1);
S2 = abs(F2);

S1_log = log(1 + S1);
S2_log = log(1 + S2);

figure, imshow(S1_log, []), title('Спектр cameraman');
figure, imshow(S2_log, []), title('Спектр moon');

imwrite(mat2gray(S1_log), [output_folder 'spectrum_cameraman.png']);
imwrite(mat2gray(S2_log), [output_folder 'spectrum_moon.png']);

%% 3. Зсув нульової частоти в центр
F1_shift = fftshift(F1);
F2_shift = fftshift(F2);

S1_shift = abs(F1_shift);
S2_shift = abs(F2_shift);

S1_shift_log = log(1 + S1_shift);
S2_shift_log = log(1 + S2_shift);

figure, imshow(S1_shift_log, []), title('Спектр cameraman зі зсувом у центр');
figure, imshow(S2_shift_log, []), title('Спектр moon зі зсувом у центр');

imwrite(mat2gray(S1_shift_log), [output_folder 'spectrum_shift_cameraman.png']);
imwrite(mat2gray(S2_shift_log), [output_folder 'spectrum_shift_moon.png']);

%% 4. Відновлення зображення за спектром
% 4.1 Відновлення зі спектра без fftshift
f1_ifft = ifft2(F1);
f2_ifft = ifft2(F2);

figure, imshow(abs(f1_ifft), []), title('Відновлення cameraman через ifft2');
figure, imshow(abs(f2_ifft), []), title('Відновлення moon через ifft2');

imwrite(mat2gray(abs(f1_ifft)), [output_folder 'restored_ifft_cameraman.png']);
imwrite(mat2gray(abs(f2_ifft)), [output_folder 'restored_ifft_moon.png']);

% 4.2 Відновлення після fftshift
F1_unshift = ifftshift(F1_shift);
F2_unshift = ifftshift(F2_shift);

f1_ifft_shift = ifft2(F1_unshift);
f2_ifft_shift = ifft2(F2_unshift);

figure, imshow(abs(f1_ifft_shift), []), title('Відновлення cameraman після fftshift/ifftshift');
figure, imshow(abs(f2_ifft_shift), []), title('Відновлення moon після fftshift/ifftshift');

imwrite(mat2gray(abs(f1_ifft_shift)), [output_folder 'restored_shift_ifft_cameraman.png']);
imwrite(mat2gray(abs(f2_ifft_shift)), [output_folder 'restored_shift_ifft_moon.png']);

%% 5. Gaussian фільтр у просторовій області
[M1, N1] = size(f1);
[M2, N2] = size(f2);

sigma1 = 1;
sigma2 = 5;

h1_small = fspecial('gaussian', [M1 N1], sigma1);
h1_large = fspecial('gaussian', [M1 N1], sigma2);

figure, imshow(250*h1_small, []), title('Вікно gaussian фільтра sigma=1');
figure, imshow(250*h1_large, []), title('Вікно gaussian фільтра sigma=5');

imwrite(mat2gray(250*h1_small), [output_folder 'gaussian_window_sigma1.png']);
imwrite(mat2gray(250*h1_large), [output_folder 'gaussian_window_sigma5.png']);

%% 6. Частотні характеристики gaussian фільтра
H1_small = fft2(h1_small);
H1_large = fft2(h1_large);

H1_small_shift = fftshift(abs(H1_small));
H1_large_shift = fftshift(abs(H1_large));

H1_small_log = log(1 + H1_small_shift);
H1_large_log = log(1 + H1_large_shift);

figure, imshow(H1_small_log, []), title('Частотна характеристика sigma=1');
figure, imshow(H1_large_log, []), title('Частотна характеристика sigma=5');

imwrite(mat2gray(H1_small_log), [output_folder 'gaussian_freq_sigma1.png']);
imwrite(mat2gray(H1_large_log), [output_folder 'gaussian_freq_sigma5.png']);

%% 7. Фільтрація у частотній області
% Для cameraman
IF_small = F1 .* H1_small;
IF_large = F1 .* H1_large;

filtered_freq_small = ifft2(IF_small);
filtered_freq_large = ifft2(IF_large);

figure, imshow(abs(filtered_freq_small), []), title('Фільтрація у частотній області sigma=1');
figure, imshow(abs(filtered_freq_large), []), title('Фільтрація у частотній області sigma=5');

imwrite(mat2gray(abs(filtered_freq_small)), [output_folder 'filtered_freq_sigma1.png']);
imwrite(mat2gray(abs(filtered_freq_large)), [output_folder 'filtered_freq_sigma5.png']);

%% 8. Спектри після фільтрації
SIF_small = abs(IF_small);
SIF_large = abs(IF_large);

SIF_small_shift = fftshift(SIF_small);
SIF_large_shift = fftshift(SIF_large);

SIF_small_log = log(1 + SIF_small_shift);
SIF_large_log = log(1 + SIF_large_shift);

figure, imshow(SIF_small_log, []), title('Спектр після фільтрації sigma=1');
figure, imshow(SIF_large_log, []), title('Спектр після фільтрації sigma=5');

imwrite(mat2gray(SIF_small_log), [output_folder 'filtered_spectrum_sigma1.png']);
imwrite(mat2gray(SIF_large_log), [output_folder 'filtered_spectrum_sigma5.png']);

%% 9. Фільтрація у просторовій області тим самим gaussian фільтром
% Для порівняння беремо вікна меншого реального розміру
h_spatial_sigma1 = fspecial('gaussian', [15 15], sigma1);
h_spatial_sigma5 = fspecial('gaussian', [15 15], sigma2);

filtered_spatial_sigma1 = imfilter(f1, h_spatial_sigma1, 'replicate');
filtered_spatial_sigma5 = imfilter(f1, h_spatial_sigma5, 'replicate');

figure, imshow(filtered_spatial_sigma1, []), title('Просторова фільтрація sigma=1');
figure, imshow(filtered_spatial_sigma5, []), title('Просторова фільтрація sigma=5');

imwrite(mat2gray(filtered_spatial_sigma1), [output_folder 'filtered_spatial_sigma1.png']);
imwrite(mat2gray(filtered_spatial_sigma5), [output_folder 'filtered_spatial_sigma5.png']);

%% 10. Порівняння для другого зображення moon
h2_small = fspecial('gaussian', [M2 N2], sigma1);
h2_large = fspecial('gaussian', [M2 N2], sigma2);

H2_small = fft2(h2_small);
H2_large = fft2(h2_large);

IF2_small = F2 .* H2_small;
IF2_large = F2 .* H2_large;

filtered2_freq_small = ifft2(IF2_small);
filtered2_freq_large = ifft2(IF2_large);

figure, imshow(abs(filtered2_freq_small), []), title('Moon: частотна фільтрація sigma=1');
figure, imshow(abs(filtered2_freq_large), []), title('Moon: частотна фільтрація sigma=5');

imwrite(mat2gray(abs(filtered2_freq_small)), [output_folder 'moon_filtered_freq_sigma1.png']);
imwrite(mat2gray(abs(filtered2_freq_large)), [output_folder 'moon_filtered_freq_sigma5.png']);