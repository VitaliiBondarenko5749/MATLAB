%% Лабораторна робота №5
% Стиснення зображень (DCT, квантування)

clear;
close all;
clc;

%% Папки
input_folder = 'images/';
output_folder = 'results/';

if ~exist(output_folder,'dir')
    mkdir(output_folder);
end

%% 1. Завантаження зображень
img1 = imread([input_folder 'Peppers.png']);
img2 = imread([input_folder 'Cameraman.png']);

figure, imshow(img1), title('Оригінал image1');
figure, imshow(img2), title('Оригінал image2');

%% 2. RGB → grayscale
if ndims(img1) == 3
    gray1 = rgb2gray(img1);
else
    gray1 = img1;
end

if ndims(img2) == 3
    gray2 = rgb2gray(img2);
else
    gray2 = img2;
end

figure, imshow(gray1), title('Gray image1');
figure, imshow(gray2), title('Gray image2');

imwrite(gray1,[output_folder 'gray1.png']);
imwrite(gray2,[output_folder 'gray2.png']);

%% 3. DCT
J1 = dct2(gray1);
J2 = dct2(gray2);

figure, imshow(log(abs(J1)+1),[]), title('DCT image1');
figure, imshow(log(abs(J2)+1),[]), title('DCT image2');

imwrite(mat2gray(log(abs(J1)+1)),[output_folder 'dct1.png']);
imwrite(mat2gray(log(abs(J2)+1)),[output_folder 'dct2.png']);

%% 4. Відновлення без втрат
rec1 = idct2(J1);
rec2 = idct2(J2);

figure, imshow(rec1,[]), title('Відновлення image1');
figure, imshow(rec2,[]), title('Відновлення image2');

imwrite(mat2gray(rec1),[output_folder 'reconstructed1.png']);
imwrite(mat2gray(rec2),[output_folder 'reconstructed2.png']);

%% 5. Квантування (різні N)
N_values = [10, 30, 50];

for i = 1:length(N_values)
    N = N_values(i);

    % Квантування
    J1_q = N * round(J1 / N);
    J2_q = N * round(J2 / N);

    % Відображення DCT
    figure, imshow(log(abs(J1_q)+1),[]), title(['DCT quantized image1 N=', num2str(N)]);
    figure, imshow(log(abs(J2_q)+1),[]), title(['DCT quantized image2 N=', num2str(N)]);

    imwrite(mat2gray(log(abs(J1_q)+1)), ...
        [output_folder 'dct1_q_N' num2str(N) '.png']);

    imwrite(mat2gray(log(abs(J2_q)+1)), ...
        [output_folder 'dct2_q_N' num2str(N) '.png']);

    % Відновлення
    rec1_q = idct2(J1_q);
    rec2_q = idct2(J2_q);

    figure, imshow(rec1_q,[]), title(['Reconstructed image1 N=', num2str(N)]);
    figure, imshow(rec2_q,[]), title(['Reconstructed image2 N=', num2str(N)]);

    imwrite(mat2gray(rec1_q), ...
        [output_folder 'rec1_q_N' num2str(N) '.png']);

    imwrite(mat2gray(rec2_q), ...
        [output_folder 'rec2_q_N' num2str(N) '.png']);
end

%% 6. Квантування оригіналу (для порівняння)
n = 20;

img1_q = round(double(gray1)/n)*n;
img2_q = round(double(gray2)/n)*n;

figure, imshow(img1_q,[]), title('Квантування оригіналу image1');
figure, imshow(img2_q,[]), title('Квантування оригіналу image2');

imwrite(mat2gray(img1_q),[output_folder 'orig_quant1.png']);
imwrite(mat2gray(img2_q),[output_folder 'orig_quant2.png']);