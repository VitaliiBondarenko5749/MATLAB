clear;
close all;
clc;

%% Зчитування зображень
river_image = imread('images/input/River.jpg');
moon_image = imread('images/input/Moon.jpg');
jerry_image = imread('images/input/Jerry.png');

%% Відображення початкових зображень
figure, imshow(river_image), title('Зображення River.jpg');
figure, imshow(moon_image), title('Зображення Moon.jpg');
figure, imshow(jerry_image), title('Зображення Jerry.png');

%% Інформація про зображення
disp('Інформація про river_image:');
whos river_image
disp('Розмір river_image:');
size(river_image)

disp('Інформація про moon_image:');
whos moon_image
disp('Розмір moon_image:');
size(moon_image)

disp('Інформація про jerry_image:');
whos jerry_image
disp('Розмір jerry_image:');
size(jerry_image)

%% Перетворення у відтінки сірого для подальшої обробки
if size(river_image,3) == 3
    river_gray = rgb2gray(river_image);
else
    river_gray = river_image;
end

if size(moon_image,3) == 3
    moon_gray = rgb2gray(moon_image);
else
    moon_gray = moon_image;
end

if size(jerry_image,3) == 3
    jerry_gray = rgb2gray(jerry_image);
else
    jerry_gray = jerry_image;
end

%% Відображення зображень у відтінках сірого
figure, imshow(river_gray), title('River у відтінках сірого');
figure, imshow(moon_gray), title('Moon у відтінках сірого');
figure, imshow(jerry_gray), title('Jerry у відтінках сірого');

%% Гістограми
figure, imhist(river_gray), title('Гістограма River.jpg');
figure, imhist(moon_gray), title('Гістограма Moon.jpg');
figure, imhist(jerry_gray), title('Гістограма Jerry.png');

%% Контрастування
river_contrast = imadjust(river_gray);
moon_contrast = imadjust(moon_gray);
jerry_contrast = imadjust(jerry_gray);

figure, imshow(river_contrast), title('Контрастоване River.jpg');
figure, imshow(moon_contrast), title('Контрастоване Moon.jpg');
figure, imshow(jerry_contrast), title('Контрастоване Jerry.png');

%% Негатив
river_negative = imadjust(river_gray, [0 1], [1 0]);
moon_negative = imadjust(moon_gray, [0 1], [1 0]);
jerry_negative = imadjust(jerry_gray, [0 1], [1 0]);

figure, imshow(river_negative), title('Негатив River.jpg');
figure, imshow(moon_negative), title('Негатив Moon.jpg');
figure, imshow(jerry_negative), title('Негатив Jerry.png');

%% Створення папки output, якщо її нема
if ~exist('images/output', 'dir')
    mkdir('images/output');
end

%% Збереження результатів
imwrite(river_contrast, 'images/output/river_contrast.png');
imwrite(river_negative, 'images/output/river_negative.png');

imwrite(moon_contrast, 'images/output/moon_contrast.png');
imwrite(moon_negative, 'images/output/moon_negative.png');

imwrite(jerry_contrast, 'images/output/jerry_contrast.png');
imwrite(jerry_negative, 'images/output/jerry_negative.png');