%% Лабораторна робота №6
% Блокова обробка. Реалізація алгоритму JPEG

clear;
close all;
clc;

%% Шляхи до папок
input_folder = 'images/';
output_folder = 'results/';

if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

%% Завантаження зображень
img1 = imread([input_folder 'Peppers.png']);
img2 = imread([input_folder 'Cameraman.png']);

figure, imshow(img1), title('Оригінал image1');
figure, imshow(img2), title('Оригінал image2');

%% Перетворення в grayscale
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

imwrite(gray1, [output_folder 'gray1.png']);
imwrite(gray2, [output_folder 'gray2.png']);

%% Переведення в double
I1 = im2double(gray1);
I2 = im2double(gray2);

%% Матриця DCT 8x8
T = dctmtx(8);

%% Функції для blockproc
dct_fun    = @(block_struct) T * block_struct.data * T';
invdct_fun = @(block_struct) T' * block_struct.data * T;

%% Поблочне DCT
B1 = blockproc(I1, [8 8], dct_fun, 'PadPartialBlocks', true, 'PadMethod', 0);
B2 = blockproc(I2, [8 8], dct_fun, 'PadPartialBlocks', true, 'PadMethod', 0);

figure, imshow(log(abs(B1)+1), []), title('Block DCT image1');
figure, imshow(log(abs(B2)+1), []), title('Block DCT image2');

imwrite(mat2gray(log(abs(B1)+1)), [output_folder 'block_dct1.png']);
imwrite(mat2gray(log(abs(B2)+1)), [output_folder 'block_dct2.png']);

%% Відновлення без втрат
R1 = blockproc(B1, [8 8], invdct_fun, 'PadPartialBlocks', true, 'PadMethod', 0);
R2 = blockproc(B2, [8 8], invdct_fun, 'PadPartialBlocks', true, 'PadMethod', 0);

% Обрізаємо до початкового розміру
R1 = R1(1:size(I1,1), 1:size(I1,2));
R2 = R2(1:size(I2,1), 1:size(I2,2));

figure, imshow(R1, []), title('Reconstructed image1 without quantization');
figure, imshow(R2, []), title('Reconstructed image2 without quantization');

imwrite(mat2gray(R1), [output_folder 'reconstructed1_no_quant.png']);
imwrite(mat2gray(R2), [output_folder 'reconstructed2_no_quant.png']);

%% Просте квантування DCT коефіцієнтів
N_values = [10 20 40];

for k = 1:length(N_values)
    N = N_values(k);

    % просте квантування
    B1_q = N * round(B1 / N);
    B2_q = N * round(B2 / N);

    % показ DCT після квантування
    figure, imshow(log(abs(B1_q)+1), []), ...
        title(['Quantized Block DCT image1, N=' num2str(N)]);
    figure, imshow(log(abs(B2_q)+1), []), ...
        title(['Quantized Block DCT image2, N=' num2str(N)]);

    imwrite(mat2gray(log(abs(B1_q)+1)), ...
        [output_folder 'block_dct1_quant_N' num2str(N) '.png']);
    imwrite(mat2gray(log(abs(B2_q)+1)), ...
        [output_folder 'block_dct2_quant_N' num2str(N) '.png']);

    % відновлення після квантування
    R1_q = blockproc(B1_q, [8 8], invdct_fun, 'PadPartialBlocks', true, 'PadMethod', 0);
    R2_q = blockproc(B2_q, [8 8], invdct_fun, 'PadPartialBlocks', true, 'PadMethod', 0);

    R1_q = R1_q(1:size(I1,1), 1:size(I1,2));
    R2_q = R2_q(1:size(I2,1), 1:size(I2,2));

    figure, imshow(R1_q, []), ...
        title(['Reconstructed image1 after quantization, N=' num2str(N)]);
    figure, imshow(R2_q, []), ...
        title(['Reconstructed image2 after quantization, N=' num2str(N)]);

    imwrite(mat2gray(R1_q), ...
        [output_folder 'reconstructed1_quant_N' num2str(N) '.png']);
    imwrite(mat2gray(R2_q), ...
        [output_folder 'reconstructed2_quant_N' num2str(N) '.png']);
end

%% Маска для JPEG-подібного відсікання коефіцієнтів
mask = [1 1 1 1 0 0 0 0;
        1 1 1 0 0 0 0 0;
        1 1 0 0 0 0 0 0;
        1 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0];

%% Поблочне застосування маски
mask_fun = @(block_struct) mask .* block_struct.data;

B1_masked = blockproc(B1, [8 8], mask_fun, 'PadPartialBlocks', true, 'PadMethod', 0);
B2_masked = blockproc(B2, [8 8], mask_fun, 'PadPartialBlocks', true, 'PadMethod', 0);

figure, imshow(log(abs(B1_masked)+1), []), title('Masked Block DCT image1');
figure, imshow(log(abs(B2_masked)+1), []), title('Masked Block DCT image2');

imwrite(mat2gray(log(abs(B1_masked)+1)), [output_folder 'block_dct1_masked.png']);
imwrite(mat2gray(log(abs(B2_masked)+1)), [output_folder 'block_dct2_masked.png']);

%% Відновлення після маски
R1_masked = blockproc(B1_masked, [8 8], invdct_fun, 'PadPartialBlocks', true, 'PadMethod', 0);
R2_masked = blockproc(B2_masked, [8 8], invdct_fun, 'PadPartialBlocks', true, 'PadMethod', 0);

R1_masked = R1_masked(1:size(I1,1), 1:size(I1,2));
R2_masked = R2_masked(1:size(I2,1), 1:size(I2,2));

figure, imshow(R1_masked, []), title('Reconstructed image1 after mask');
figure, imshow(R2_masked, []), title('Reconstructed image2 after mask');

imwrite(mat2gray(R1_masked), [output_folder 'reconstructed1_masked.png']);
imwrite(mat2gray(R2_masked), [output_folder 'reconstructed2_masked.png']);

%% Квантування оригіналу для порівняння
% Для double у [0,1] беремо малий крок
n = 0.1;
I1_q_orig = round(I1 / n) * n;
I2_q_orig = round(I2 / n) * n;

figure, imshow(I1_q_orig, []), title('Original image1 quantized directly');
figure, imshow(I2_q_orig, []), title('Original image2 quantized directly');

imwrite(mat2gray(I1_q_orig), [output_folder 'orig1_quant_direct.png']);
imwrite(mat2gray(I2_q_orig), [output_folder 'orig2_quant_direct.png']);