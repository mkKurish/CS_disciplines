#include <iostream>
#include <random>
#include <vector>
#include <string>
#include <fstream>

using namespace std;

int NumOfSegments = 2000;

int intInput(string welcome) {
	int a;
	cout << welcome;
	cin >> a;
	while (!cin) {
		cout << "\x1B[31mНеверный ввод. (Ожидается число)\033[0m\n";
		cin.clear();
		cin.ignore(999, '\n');
		cout << "Введите заново: ";
		cin >> a;
	}
	return a;
}

int intInputInBounds(string welcome, int left, int right) {
	int a = intInput(welcome);
	while (a < left || a > right) {
		cout << "\x1B[31mНеверный ввод.\033[0m Значение должно быть на отрезке [" << left << ", " << right << "]\n";
		cout << "Повторите попытку: ";
		a = intInput(welcome);
	}
	return a;
}

bool checkKey(string key) {
	if (key.size() != 6)
		return false;
	if (key[0] < 48 || key[0] > 57)
		return false;
	if (key[1] < 65 || key[1] > 90)
		return false;
	if (key[2] < 65 || key[2] > 90)
		return false;
	if (key[3] < 65 || key[3] > 90)
		return false;
	if (key[4] < 65 || key[4] > 90)
		return false;
	if (key[5] < 48 || key[5] > 57)
		return false;
	return true;
}

string enterKey() {
	string inp;
	cout << "Введите ключ: ";
	cin >> inp;
	while (!checkKey(inp)) {
		cout << "\x1B[31mНеверно введен ключ.\033[0m Формат цББББц.\nПовторите попытку ввода: ";
		cin >> inp;
	}
	return inp;
}

string enterString(string welcome) {
	string inp = "";
	char letter;
	cout << welcome;
	cin.ignore(999, '\n');
	cin.clear();
	getline(cin, inp);
	while (inp.size() == 0) {
		cout << "\x1B[31mНеверный ввод\033[0m\nПовторите попытку: ";
		getline(cin, inp);
	}
	return inp;
}

class HashTable {
private:
	class Node {
	public:
		string value;
		bool state;
		Node() {
			value = "";
			state = false;
		}
		Node(string value) {
			this->value = value;
			state = true;
		}
	};
	Node* nodeArr = new Node[NumOfSegments];
	~HashTable() {
		delete nodeArr;
	}
	int hashCode(string& key) {
		int hashNum = 0;
		for (int j = 0; j < 6; j++)
			hashNum += key[j] * ((j + 1) * 3) + key[j] * j * j * j;
		hashNum = hashNum % NumOfSegments;
		return hashNum;
	}
public:
	void put(string key, string value) {
		int hash = hashCode(key);
		int firstVal = hash;
		bool firstTime = true;
		while (nodeArr[hash].state) {
			if (hash == firstVal && !firstTime) {
				cout << "Значение по ключу '" << key << "' не удалось вставить: таблица заполнена\n";
				return;
			}
			hash = (hash + 1) % NumOfSegments;
			firstTime = false;
		}
		nodeArr[hash].value = value;
		nodeArr[hash].state = true;
	}
	void show() {
		for (int i = 0; i < NumOfSegments; i++)
			if (nodeArr[i].state)
				cout << nodeArr[i].value << endl;
			else
				if (nodeArr[i].value == "")
					cout << "Empty\n";
				else
					cout << "Deleted\n";
	}
	string get(int index) {
		if (nodeArr[index].state)
			return nodeArr[index].value + " at " + to_string(index);
		if (nodeArr[index].value == "")
			return "Empty at " + to_string(index);
		return "Deleted at " + to_string(index);
	}
	string get(string key) {
		int hash = hashCode(key);
		if (nodeArr[hash].state)
			return nodeArr[hash].value + " at " + to_string(hash);
		if (nodeArr[hash].value == "")
			return "Empty at " + to_string(hash);
		return "Deleted at " + to_string(hash);
	}
	void writeToFile(string fileName) {
		ofstream ofs;
		fileName += ".txt";
		ofs.open(fileName);
		for (int i = 0; i < NumOfSegments; i++) {
			if (nodeArr[i].state)
				ofs << nodeArr[i].value << " ";
			else
				if (nodeArr[i].value == "")
					ofs << "Empty ";
				else
					ofs << "Deleted ";
		}
		ofs.close();
	}
	void remove(string key) {
		int hash = hashCode(key);
		if (!nodeArr[hash].state) {
			cout << "По ключу '" << key << "' в таблице не было.\n";
			return;
		}
		nodeArr[hash].state = false;
	}
	void remove(int index) {
		if (!nodeArr[index].state) {
			cout << "По индексу '" << index << "' в таблице не было значения.\n";
			return;
		}
		nodeArr[index].state = false;
	}
};

void generateKeys(vector<string>& keysArray, int count) {
	random_device rd;
	mt19937 mt(rd());
	uniform_int_distribution<int> uniLetters(65, 90);
	uniform_int_distribution<int> uniNumbers(0, 9);
	while (count != 0) {
		keysArray.push_back(to_string(uniNumbers(mt)) +
			(char)uniLetters(mt) +
			(char)uniLetters(mt) +
			(char)uniLetters(mt) +
			(char)uniLetters(mt) +
			to_string(uniNumbers(mt)));
		count--;
	}
}

int main()
{
	setlocale(LC_ALL, "RUS");
	HashTable* ht = nullptr;
	bool flag1 = true;
	while (flag1) {
		cout << "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";
		cout << "1 - Создание хеш-таблицы\n";
		cout << "2 - Добавление элемента\n";
		cout << "3 - Автоматическая генерация элементов\n";
		cout << "4 - Просмотр хеш-таблицы\n";
		cout << "5 - Поиск элемента\n";
		cout << "6 - Выгрузка таблицы в файл\n";
		cout << "7 - Удаление элемента\n";
		cout << "10 - Завершение работы\n";
		switch (intInput("Выбор: ")) {
		case 1:
			if (ht != nullptr)
				cout << "\x1B[33mХеш-таблица уже создана\033[0m\n";
			else {
				ht = new HashTable();
				cout << "\x1B[32mХеш-таблица успешно создана\033[0m\n";
			}
			break;
		case 2:
			if (ht == nullptr)
				cout << "\x1B[31mСначала создайте таблицу\033[0m\n";
			else {
				ht->put(enterKey(), enterString("Введите данные: "));
			}
			break;
		case 3:
			if (ht == nullptr)
				cout << "\x1B[31mСначала создайте таблицу\033[0m\n";
			else {
				vector<string> generatedKeys;
				generateKeys(generatedKeys, intInput("Введите количество генерируемых элементов: "));
				for (int i = 0; i < generatedKeys.size(); i++) {
					ht->put(generatedKeys[i], generatedKeys[i] + " was added");
				}
			}
			break;
		case 4:
			if (ht == nullptr)
				cout << "\x1B[31mСначала создайте таблицу\033[0m\n";
			else {
				ht->show();
			}
			break;
		case 5:
			if (ht == nullptr)
				cout << "\x1B[31mСначала создайте таблицу\033[0m\n";
			else {
				bool flag2 = true;
				while (flag2) {
					cout << "---Поиск элемента---\n";
					cout << "1 - По индексу\n";
					cout << "2 - По ключу\n";
					string foundElement;
					switch (intInput("Выбор: ")) {
					case 1:
						foundElement = ht->get(intInputInBounds("Введите индекс: ", 0, NumOfSegments - 1));
						cout << "\x1B[32m" << foundElement << "\033[0m\n";
						flag2 = false;
						break;
					case 2:
						foundElement = ht->get(enterKey());
						cout << "\x1B[32m" << foundElement << "\033[0m\n";
						flag2 = false;
						break;
					default:
						cout << "\x1B[31mНеверный выбор пункта меню\033[0m\nПовторите попытку\n";
						break;
					}
				}
			}
			break;
		case 6:
			if (ht == nullptr)
				cout << "\x1B[31mСначала создайте таблицу\033[0m\n";
			else {
				ht->writeToFile(enterString("Введите название файла для записи: "));
			}
			break;
		case 7:
			if (ht == nullptr)
				cout << "\x1B[31mСначала создайте таблицу\033[0m\n";
			else {
				bool flag3 = true;
				while (flag3) {
					cout << "---Удаление элемента---\n";
					cout << "1 - По индексу\n";
					cout << "2 - По ключу\n";
					switch (intInput("Выбор: ")) {
					case 1:
						ht->remove(intInputInBounds("Введите индекс: ", 0, NumOfSegments - 1));
						flag3 = false;
						break;
					case 2:
						ht->remove(enterKey());
						flag3 = false;
						break;
					default:
						cout << "\x1B[31mНеверный выбор пункта меню\033[0m\nПовторите попытку\n";
						break;
					}
				}
			}
			break;
		case 10:
			flag1 = false;
			break;
		default:
			cout << "\x1B[31mНеверный выбор пункта меню\033[0m\nПовторите попытку\n";
			break;
		}
	}
}