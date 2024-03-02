#include <iostream>

using namespace std;

int* generateArray(int);

void decreaseTens(int *, int);

void countPositive(int);

int main()
{
    setlocale(LC_ALL, "RUS");
    int Asize;
    cout << "Введите количество элементов массива: ";
    cin >> Asize;
    int* A = generateArray(Asize);

    int funNum = 0;
    while (true) {
        cout << "Функции\nФункция #1: 1\nФункция #2: 2\nЗавершение: 3\n";
        cout << "Выберите номер функции: ";
        cin >> funNum;
        if (funNum == 1) {
            decreaseTens(A, Asize);
        }
        else if (funNum == 2) {
            int posCount = 0;
            for (int i = 0; i < Asize; i++) {
                if (A[i] > 0)
                    posCount++;
            }
            countPositive(posCount);
        }
        else if (funNum == 3) {
            break;
        }
        else
            cout << "Введено неверное значение";
    }
}

int* generateArray(int arrSize) {
    int* A = new int[arrSize];
    int min = -((arrSize / 2) - 1);
    int max = arrSize / 2;
    cout << "Значения массива принадлежат [" << min << "; " << max << "]\n";
    cout << "Создан массив: [";
    for (int i = 0; i < arrSize; i++) {
        A[i] = min + (rand()%(max - min + 1));
        cout << A[i];
        if (i != arrSize - 1)
            cout << ", ";
    }
    cout << "]\n";
    return A;
}

void decreaseTens(int* arr, int sz) {
    cout << "Обработанный массив: [";
    for (int i = 0; i < sz; i++) {
        if (arr[i] % 10 == 0)
            arr[i] /= 10;
        cout << arr[i];
        if (i != sz - 1)
            cout << ", ";
    }
    cout << "]\n";
}

void countPositive(int val) {
    cout << "\nКоличество положительных чисел: " << val << endl;
}