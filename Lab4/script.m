%% Лабораторна робота №4
% Просторові перетворення зображень
% ДПФ, спектри, fftshift, ifft2, фільтрація у частотній і просторовій області

clear;
close all;
clc;

%% Шляхи до папок
input_folder = 'images/';
output_folder = 'results/';

if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%% 1. Завантаження зображень
f1 = imread([input_folder 'Cameraman.jpg']);
f2 = imread([input_folder 'Moon.jpg']);

% Якщо RGB — перевести в grayscale
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
F1 = fft2(double(f1));
F2 = fft2(double(f2));

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

%% 5. Gaussian-фільтр у частотній області
% Будуємо Gaussian low-pass filter без fspecial/psf2otf

[M1, N1] = size(f1);
[M2, N2] = size(f2);

% Координатні сітки для cameraman
[u1, v1] = meshgrid((-floor(N1/2)):(ceil(N1/2)-1), ...
                    (-floor(M1/2)):(ceil(M1/2)-1));

% Координатні сітки для moon
[u2, v2] = meshgrid((-floor(N2/2)):(ceil(N2/2)-1), ...
                    (-floor(M2/2)):(ceil(M2/2)-1));

D1 = sqrt(u1.^2 + v1.^2);
D2 = sqrt(u2.^2 + v2.^2);

% Параметри Gaussian LPF
D0_small = 20;
D0_large = 50;

H1_small = exp(-(D1.^2) / (2 * D0_small^2));
H1_large = exp(-(D1.^2) / (2 * D0_large^2));

H2_small = exp(-(D2.^2) / (2 * D0_small^2));
H2_large = exp(-(D2.^2) / (2 * D0_large^2));

%% 6. Частотна характеристика Gaussian-фільтра
figure, imshow(H1_small, []), title('Gaussian LPF cameraman, D0=20');
figure, imshow(H1_large, []), title('Gaussian LPF cameraman, D0=50');

figure, imshow(H2_small, []), title('Gaussian LPF moon, D0=20');
figure, imshow(H2_large, []), title('Gaussian LPF moon, D0=50');

imwrite(mat2gray(H1_small), [output_folder 'gaussian_freq_sigma1.png']);
imwrite(mat2gray(H1_large), [output_folder 'gaussian_freq_sigma5.png']);

%% 7. Фільтрація у частотній області
F1 = fft2(double(f1));
F2 = fft2(double(f2));

F1_shift = fftshift(F1);
F2_shift = fftshift(F2);

G1_small = F1_shift .* H1_small;
G1_large = F1_shift .* H1_large;

G2_small = F2_shift .* H2_small;
G2_large = F2_shift .* H2_large;

filtered_freq1_small = real(ifft2(ifftshift(G1_small)));
filtered_freq1_large = real(ifft2(ifftshift(G1_large)));

filtered_freq2_small = real(ifft2(ifftshift(G2_small)));
filtered_freq2_large = real(ifft2(ifftshift(G2_large)));

figure, imshow(mat2gray(filtered_freq1_small)), ...
    title('Cameraman filtered in frequency domain, D0=20');

figure, imshow(mat2gray(filtered_freq1_large)), ...
    title('Cameraman filtered in frequency domain, D0=50');

figure, imshow(mat2gray(filtered_freq2_small)), ...
    title('Moon filtered in frequency domain, D0=20');

figure, imshow(mat2gray(filtered_freq2_large)), ...
    title('Moon filtered in frequency domain, D0=50');

imwrite(mat2gray(filtered_freq1_small), [output_folder 'filtered_freq_sigma1.png']);
imwrite(mat2gray(filtered_freq1_large), [output_folder 'filtered_freq_sigma5.png']);
imwrite(mat2gray(filtered_freq2_small), [output_folder 'moon_filtered_freq_sigma1.png']);
imwrite(mat2gray(filtered_freq2_large), [output_folder 'moon_filtered_freq_sigma5.png']);

%% 8. Спектри після фільтрації
S1_small = log(1 + abs(G1_small));
S1_large = log(1 + abs(G1_large));

figure, imshow(mat2gray(S1_small)), title('Спектр cameraman після фільтрації D0=20');
figure, imshow(mat2gray(S1_large)), title('Спектр cameraman після фільтрації D0=50');

imwrite(mat2gray(S1_small), [output_folder 'filtered_spectrum_sigma1.png']);
imwrite(mat2gray(S1_large), [output_folder 'filtered_spectrum_sigma5.png']);

%% 9. Фільтрація у просторовій області для cameraman
h_small = fspecial('gaussian', [15 15], 1);
h_large = fspecial('gaussian', [15 15], 5);

filtered_spatial_sigma1 = imfilter(double(f1), h_small, 'replicate');
filtered_spatial_sigma5 = imfilter(double(f1), h_large, 'replicate');

figure, imshow(mat2gray(filtered_spatial_sigma1)), ...
    title('Просторова фільтрація cameraman sigma=1');

figure, imshow(mat2gray(filtered_spatial_sigma5)), ...
    title('Просторова фільтрація cameraman sigma=5');

imwrite(mat2gray(filtered_spatial_sigma1), [output_folder 'filtered_spatial_sigma1.png']);
imwrite(mat2gray(filtered_spatial_sigma5), [output_folder 'filtered_spatial_sigma5.png']);

%% 10. Просторова фільтрація для moon
filtered2_spatial_sigma1 = imfilter(double(f2), h_small, 'replicate');
filtered2_spatial_sigma5 = imfilter(double(f2), h_large, 'replicate');

figure, imshow(mat2gray(filtered2_spatial_sigma1)), ...
    title('Moon: просторова фільтрація sigma=1');

figure, imshow(mat2gray(filtered2_spatial_sigma5)), ...
    title('Moon: просторова фільтрація sigma=5');

imwrite(mat2gray(filtered2_spatial_sigma1), [output_folder 'moon_filtered_spatial_sigma1.png']);
imwrite(mat2gray(filtered2_spatial_sigma5), [output_folder 'moon_filtered_spatial_sigma5.png']);