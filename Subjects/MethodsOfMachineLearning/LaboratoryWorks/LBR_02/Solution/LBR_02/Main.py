import pandas as pd;
import numpy as np;
import matplotlib;
import matplotlib.pyplot as plt;
matplotlib.use('TkAgg');
import seaborn as sns;
from sklearn.preprocessing import MinMaxScaler, StandardScaler, OneHotEncoder, LabelEncoder;

csvFilePath = 'D:/User/Documents/GitHub/Semester_6/Subjects/MethodsOfMachineLearning/LaboratoryWorks/LBR_02/Solution/autoscout24-germany-dataset.csv';
csvData = pd.read_csv(csvFilePath);

# Выявление пропусков в данных
print('\nПропуски данных (расчетный способ): ');
print('\nПроверка, есть ли нулевые значения: ');
print(csvData.isnull().any());
print();

# Подсчет нулевых значений и процентов по столбцам
print('\nПодсчет нулевых значений и их процентов в столбцах:')
for col in csvData.columns:
    total_missing = csvData[col].isnull().sum();
    pct_missing = total_missing / len(csvData) * 100;
    print(f'{col} - {total_missing} ({round(pct_missing, 4)}%)');
print("");

# Построение тепловой карты с помощью pyplot
cols = csvData.columns[:];
colours = ['#eeeeee', '#ff0000'];

plt.figure(figsize=(10, 6));
sns.heatmap(csvData.isnull(), cmap=sns.color_palette(colours), cbar=False);
plt.title('Пропуски данных');
plt.show();

# Исключение строки и столбцов с наибольшим количеством пропусков
threshold = 0.5;
csvData = csvData.dropna(axis=0, thresh=threshold * len(csvData.columns));
print(f"После удаления строк, где больше всего пропусков:\n {csvData}");

csvData = csvData.dropna(axis=1, thresh=threshold * len(csvData));
print(f"После удаления столбцов, где больше всего пропусков:\n {csvData}");

# Произведение замену оставшихся пропусков на логически обоснованные значения
numeric_cols = csvData.select_dtypes(include=[np.number]).columns;
csvData[numeric_cols] = csvData[numeric_cols].fillna(csvData[numeric_cols].mean());

# Построение тепловой карты с помощью pyplot
cols = csvData.columns[:];
colours = ['#eeeeee', '#ff0000'];

plt.figure(figsize=(10, 6));
sns.heatmap(csvData.isnull(), cmap=sns.color_palette(colours), cbar=False);
plt.title('Пропуски данных');
plt.show();

# Проверка датасета на наличие выбросов
sns.boxplot(x=csvData['mileage']);
Q1 = csvData['mileage'].quantile(0.25);
Q2 = csvData['mileage'].quantile(0.50);
Q3 = csvData['mileage'].quantile(0.75);
IQR = Q3 - Q1;
lower_bound = Q1 - 1.5 * IQR;
upper_bound = Q3 + 1.5 * IQR;

# Удаление найденных аномальных записей
csvData = csvData[(csvData['mileage'] >= lower_bound) & (csvData['mileage'] <= upper_bound)];

# Проверка, остались ли выбросы
remaining_outliers = csvData[(csvData['mileage'] < lower_bound) | (csvData['mileage'] > upper_bound)];
print(f"Кол-во выбросов: {remaining_outliers.shape[0]}\n");

# Проведение категориальных параметров к числовому виду
categorical_cols = ['make', 'model', 'fuel', 'gear', 'offerType'];
for col in categorical_cols:
    if col in csvData.columns:
        csvData[col] = csvData[col].astype('category').cat.codes;
print(f"Данные после приведения категориальных параметров к числовому виду: \n{csvData}");

# LabelEncoder:
csvDataLE = csvData;
categorical_cols = ['make', 'model', 'gear', 'offerType'];
label_encoders = {};
for col in categorical_cols:
    le = LabelEncoder();
    csvDataLE[col] = le.fit_transform(csvData[col]);
    label_encoders[col] = le;
print(f"После применения LabelEncoder:\n{csvDataLE}");

# OneHotEncoder:
categorical_cols = ['make', 'model', 'fuel', 'gear', 'offerType'];
csvData = pd.get_dummies(csvData, columns=categorical_cols, drop_first=True);
columns_to_normalize = ['mileage', 'price', 'hp', 'year'];
min_max_scaler = MinMaxScaler();
csvData[columns_to_normalize] = min_max_scaler.fit_transform(csvData[columns_to_normalize]);
print(f"После применения OneHotEncoder:\n{csvData}");

# Сохранение обработанного датасета
csvDataLE.to_csv('autoscout24-germany-dataset-changed-LE-new.csv', index=False);
csvData.to_csv('autoscout24-germany-dataset-changed-OHE-new.csv', index=False);
