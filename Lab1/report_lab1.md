# Лабораторна робота №1
## Аналіз і обробка зображень із MATLAB Image Processing Toolbox

---

## Мета роботи

Метою лабораторної роботи є набуття основних навичок роботи із зображеннями в середовищі **MATLAB** з використанням пакета **Image Processing Toolbox**, а саме:
- зчитування зображень із файлів;
- отримання інформації про зображення;
- відображення зображень на екрані;
- побудова гістограм розподілу яскравостей;
- підвищення контрастності зображень;
- отримання негативних зображень;
- збереження результатів обробки.

---

## Теоретичні відомості

Цифрове зображення в MATLAB подається у вигляді масиву даних.  
Основні типи зображень:
- **півтонові зображення** — двовимірна матриця яскравостей;
- **кольорові зображення RGB** — тривимірний масив розміру `M × N × 3`;
- **двійкові зображення** — матриця логічних значень `0` і `1`.

Для роботи із зображеннями в MATLAB використовуються такі функції:
- `imread()` — зчитування зображення з файлу;
- `imshow()` — відображення зображення;
- `size()` — визначення розміру зображення;
- `whos` — перегляд параметрів змінної;
- `rgb2gray()` — перетворення кольорового зображення у відтінки сірого;
- `imhist()` — побудова гістограми;
- `imadjust()` — зміна яскравості та контрастності;
- `imwrite()` — збереження результатів на диск.

---

## Хід роботи

### 1. Підготовка середовища

На початку роботи було очищено робочий простір, закрито всі відкриті вікна та очищено командне вікно MATLAB:

```matlab
clear;
close all;
clc;
```

---

### 2. Завантаження зображень

Для виконання лабораторної роботи було використано три зображення:
- `River.jpg`
- `Moon.jpg`
- `Jerry.png`

Зчитування зображень виконано за допомогою функції `imread()`:

```matlab
river_image = imread('images/input/River.jpg');
moon_image = imread('images/input/Moon.jpg');
jerry_image = imread('images/input/Jerry.png');
```

---

### 3. Відображення початкових зображень

Початкові зображення були виведені на екран за допомогою функції `imshow()`:

```matlab
figure, imshow(river_image), title('Зображення River.jpg');
figure, imshow(moon_image), title('Зображення Moon.jpg');
figure, imshow(jerry_image), title('Зображення Jerry.png');
```

---

### 4. Отримання інформації про зображення

Для аналізу характеристик зображень було використано команди `whos` та `size()`:

```matlab
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
```

Було отримано інформацію про:
- розмір зображень;
- кількість байтів у пам’яті;
- тип даних.

---

### 5. Перетворення кольорових зображень у відтінки сірого

Оскільки побудова гістограм і контрастування зручніше виконується для півтонових зображень, кольорові зображення були переведені у відтінки сірого:

```matlab
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
```

Після цього були отримані зображення:
- `river_gray`
- `moon_gray`
- `jerry_gray`

---

### 6. Відображення зображень у відтінках сірого

Перетворені зображення були виведені на екран:

```matlab
figure, imshow(river_gray), title('River у відтінках сірого');
figure, imshow(moon_gray), title('Moon у відтінках сірого');
figure, imshow(jerry_gray), title('Jerry у відтінках сірого');
```

---

### 7. Побудова гістограм розподілу яскравостей

Для кожного зображення у відтінках сірого було побудовано гістограму яскравостей:

```matlab
figure, imhist(river_gray), title('Гістограма River.jpg');
figure, imhist(moon_gray), title('Гістограма Moon.jpg');
figure, imhist(jerry_gray), title('Гістограма Jerry.png');
```

Гістограма показує розподіл пікселів за рівнями яскравості.

---

### 8. Контрастування зображень

Для підвищення контрастності використано функцію `imadjust()`:

```matlab
river_contrast = imadjust(river_gray);
moon_contrast = imadjust(moon_gray);
jerry_contrast = imadjust(jerry_gray);
```

Після цього результати було відображено:

```matlab
figure, imshow(river_contrast), title('Контрастоване River.jpg');
figure, imshow(moon_contrast), title('Контрастоване Moon.jpg');
figure, imshow(jerry_contrast), title('Контрастоване Jerry.png');
```

У результаті динамічний діапазон яскравостей було розширено, що покращило візуальне сприйняття зображень.

---

### 9. Отримання негативних зображень

Негативи зображень були отримані шляхом інверсії яскравостей:

```matlab
river_negative = imadjust(river_gray, [0 1], [1 0]);
moon_negative = imadjust(moon_gray, [0 1], [1 0]);
jerry_negative = imadjust(jerry_gray, [0 1], [1 0]);
```

Результати були виведені на екран:

```matlab
figure, imshow(river_negative), title('Негатив River.jpg');
figure, imshow(moon_negative), title('Негатив Moon.jpg');
figure, imshow(jerry_negative), title('Негатив Jerry.png');
```

---

### 10. Збереження результатів

Для збереження результатів було створено папку `images/output`, якщо вона відсутня:

```matlab
if ~exist('images/output', 'dir')
    mkdir('images/output');
end
```

Після цього контрастовані та негативні зображення були записані у файли:

```matlab
imwrite(river_contrast, 'images/output/river_contrast.png');
imwrite(river_negative, 'images/output/river_negative.png');

imwrite(moon_contrast, 'images/output/moon_contrast.png');
imwrite(moon_negative, 'images/output/moon_negative.png');

imwrite(jerry_contrast, 'images/output/jerry_contrast.png');
imwrite(jerry_negative, 'images/output/jerry_negative.png');
```

---

## Повний текст програми

```matlab
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

%% Перетворення у відтінки сірого
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

%% Відображення у відтінках сірого
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
```

---

## Результати роботи

У ході лабораторної роботи було:
1. Завантажено три зображення різних форматів.
2. Відображено початкові зображення.
3. Отримано інформацію про їх розміри та тип даних.
4. Виконано перетворення кольорових зображень у відтінки сірого.
5. Побудовано гістограми розподілу яскравостей.
6. Виконано підвищення контрастності.
7. Отримано негативні зображення.
8. Збережено результати у вихідні файли.

---

## Відповіді на контрольні питання

### 1. Що таке гістограма розподілу яскравостей?

Гістограма розподілу яскравостей — це графічне подання кількості пікселів зображення для кожного рівня яскравості. Вона дозволяє оцінити, чи є зображення темним, світлим або контрастним.

### 2. Що таке контрастність зображення?

Контрастність зображення — це різниця між найтемнішими та найсвітлішими ділянками зображення. Чим більший діапазон яскравостей, тим вища контрастність.

### 3. Як при контрастуванні змінюється гістограма розподілу яскравостей зображення?

При контрастуванні гістограма розтягується на ширший діапазон значень. Це дає змогу краще використовувати весь діапазон яскравостей і зробити зображення виразнішим.

### 4. Як за необхідності зменшити контрастність зображення?

Контрастність можна зменшити, якщо стиснути діапазон яскравостей. Для цього можна використати відповідні параметри функції `imadjust()` або застосувати логарифмічне перетворення.

### 5. Як одержати негативне зображення?

Негативне зображення отримують інверсією яскравостей, коли світлі ділянки стають темними, а темні — світлими. У MATLAB це можна зробити так:

```matlab
I_negative = imadjust(I, [0 1], [1 0]);
```

---

## Висновок

У результаті виконання лабораторної роботи було засвоєно базові принципи роботи із зображеннями в середовищі MATLAB та пакеті Image Processing Toolbox. У процесі роботи було виконано зчитування, відображення, аналіз характеристик, побудову гістограм, контрастування та отримання негативних зображень. Також було отримано практичні навички збереження результатів обробки у файли. Отримані знання є основою для подальшого вивчення цифрової обробки зображень.
