#include <iostream>
#include <random>
#include <string>

using namespace std;

struct Pair {
public:
	int val;
	int prev;
	Pair(int val, int prev) {
		this->val = val;
		this->prev = prev;
	}
	Pair() {}
};

class Queue {
private:
	class QueueNode {
	public:
		Pair val;
		QueueNode* next;
		QueueNode(int val, int prev) {
			this->val = Pair(val, prev);
			this->next = nullptr;
		}
	};
	QueueNode* head;
	QueueNode* tail;
public:
	Queue() {
		head = nullptr;
		tail = nullptr;
	}
	Pair peek()
	{
		if (!isEmpty()) {
			return tail->val;
		}
		throw runtime_error("Попытка чтения из пустой очереди");
	}
	Pair pop()
	{
		if (!isEmpty()) {
			QueueNode* tempNode = tail;
			tail = tail->next;
			Pair tempVal = tempNode->val;
			delete tempNode;
			if (tail == nullptr)
				head = nullptr;
			return tempVal;
		}
		throw runtime_error("Попытка чтения из пустой очереди");
	}
	void push(int val, int prev)
	{
		if (isEmpty()) {
			head = new QueueNode(val, prev);
			tail = head;
		}
		else {
			head->next = new QueueNode(val, prev);
			head = head->next;
		}
	}
	void clear()
	{
		while (!isEmpty()) {
			pop();
		}
	}
	bool isEmpty()
	{
		return tail == nullptr;
	}
};

int intInput(string msg);
void autoFillGraph(int** graph, int size);
void fillGraph(int** graph, int size);
void testCase();
void showGraph(int** graph, int size);
void chainPassage(int** graph, int size, int parent, bool* checked);
void showChain(int** graph, int size);
int** shrinkGraph(int** graph, int* size);

int** graphCopy(int** graph, int size);
bool graphsEquals(int** graph1, int** graph2, int size);

bool arrContains(int* arr, int size, int val);
int* addAsLast(int* arr, int size, int val);

int lengthOfPath(int* path, int size);
int* DFS_longestPath(int** graph, int size, int* path, int last);
int** BFS_deletingCycles(int** graph, int size, int first);

void excludeRing(int** graph, int size, int ring);
int** deleteRing(int** graph, int size, int ring);
int** removeRings(int** graph, int size);

int main()
{
	setlocale(LC_ALL, "RUS");
	int g_size = 0;
	int** graph = nullptr;
	bool graph_is_created = false;
	bool flag1 = true;
	bool flag2;
	while (flag1) {
		cout << "\n~~~~~~~~~~~~ Граф и кольца ~~~~~~~~~~~~\n";
		cout << "1 - Создать граф\n";
		cout << "2 - Показать граф\n";
		cout << "3 - Удалить ненужные кольца\n";
		cout << "4 - Показать цепочку\n";
		cout << "5 - Очистить граф от несцепленных колец\n";
		cout << "-------------------\n";
		cout << "6 - Тестовый набор\n";
		cout << "-------------------\n";
		cout << "10 - Очистка экрана\n";
		cout << "100 - Завершение работы\n";
		switch (intInput("Выбор: ")) {
		case 1:
			g_size = intInput("Введите размер графа: ");
			graph = new int* [g_size];
			for (int i = 0; i < g_size; i++)
				graph[i] = new int[g_size];
			flag2 = true;
			while (flag2) {
				cout << "-----Создание графа-----\n";
				cout << "1 - Вручную\n";
				cout << "2 - Автоматически\n";
				switch (intInput("Выбор: ")) {
				case 1:
					fillGraph(graph, g_size);
					flag2 = false;
					break;
				case 2:
					autoFillGraph(graph, g_size);
					flag2 = false;
					break;
				default:
					cout << "\x1B[31mНеверный выбор пункта меню\033[0m\nПовторите попытку\n";
					break;
				}
			}
			showGraph(graph, g_size);
			graph_is_created = true;
			break;
		case 2:
			if (graph_is_created) {
				showGraph(graph, g_size);
			}
			else
				cout << "\x1B[33mДля начала создайте граф\033[0m\n";
			break;
		case 3:
			if (graph_is_created) {
				graph = removeRings(graph, g_size);
				showGraph(graph, g_size);
			}
			else
				cout << "\x1B[33mДля начала создайте граф\033[0m\n";
			break;
		case 4:
			if (graph_is_created) {
				showChain(graph, g_size);
			}
			else
				cout << "\x1B[33mДля начала создайте граф\033[0m\n";
			break;
		case 5:
			if (graph_is_created) {
				graph = shrinkGraph(graph, &g_size);
				showGraph(graph, g_size);
			}
			else
				cout << "\x1B[33mДля начала создайте граф\033[0m\n";
			break;
		case 6:
			testCase();
			break;
		case 10:
			system("cls");
			break;
		case 100:
			flag1 = false;
			break;
		default:
			cout << "\x1B[31mНеверный выбор пункта меню\033[0m\nПовторите попытку\n";
			break;
		}
	}
}

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

void autoFillGraph(int** graph, int size)
{
	random_device rd;
	mt19937 rng(rd());
	uniform_int_distribution<int> rings(0, 1);
	for (int i = 0; i < size; i++) {
		graph[i][i] = 0;
		bool rowCorrect = i == size - 1;
		while (!rowCorrect) {
			for (int j = i + 1; j < size; j++) {
				graph[i][j] = rings(rng);
				graph[j][i] = graph[i][j];
				if (graph[i][j] == 1)
					rowCorrect = true;
			}
		}
	}
}

void fillGraph(int** graph, int size)
{
	for (int i = 0; i < size; i++) {
		graph[i][i] = 0;
		bool rowCorrect = i == size - 1;
		while (!rowCorrect) {
			for (int j = i + 1; j < size; j++) {
				graph[i][j] = intInput("(1 - если кольцо #" + to_string(i) + " связано с кольцом #" + to_string(j) + ") Ввод: ");
				graph[j][i] = graph[i][j];
				if (graph[i][j] == 1)
					rowCorrect = true;
			}
			if (!rowCorrect)
				cout << "\x1B[31mГраф не может иметь несцепленные кольца!\033[0m\n";
		}
	}
}

void testCase()
{
	cout << "__Граф #1__\n";
	int g_size = 5;
	int** graph = new int* [g_size];
	for (int i = 0; i < g_size; i++)
		graph[i] = new int[g_size];
	for (int i = 0; i < g_size; i++) {
		graph[i][i] = 0;
		for (int j = i + 1; j < g_size; j++) {
			if (i == 0 && j == 2 ||
				i == 1 && j == 3 ||
				i == 2 && j == 4 ||
				i == 3 && j == 1 ||
				i == 3 && j == 4)
				graph[i][j] = 1;
			else
				graph[i][j] = 0;
			graph[j][i] = graph[i][j];
		}
	}
	showGraph(graph, g_size);
	showChain(graph, g_size);
	//////////////////////////////////////////////
	cout << "__Граф #2__\n";
	for (int i = 0; i < g_size; i++) {
		graph[i][i] = 0;
		for (int j = i + 1; j < g_size; j++) {
			if (i == 0 && j == 1 ||
				i == 0 && j == 3 ||
				i == 1 && j == 2 ||
				i == 2 && j == 3 ||
				i == 2 && j == 4 ||
				i == 3 && j == 4)
				graph[i][j] = 1;
			else
				graph[i][j] = 0;
			graph[j][i] = graph[i][j];
		}
	}
	showGraph(graph, g_size);
	showChain(graph, g_size);
	cout << "Удаление колец\n";
	graph = removeRings(graph, g_size);
	graph = shrinkGraph(graph, &g_size);
	showGraph(graph, g_size);
	showChain(graph, g_size);
	//////////////////////////////////////////////
	cout << "__Граф #3__\n";
	for (int i = 0; i < g_size; i++)
		delete[] graph[i];
	delete[] graph;
	g_size = 7;
	graph = new int* [g_size];
	for (int i = 0; i < g_size; i++)
		graph[i] = new int[g_size];
	for (int i = 0; i < g_size; i++) {
		graph[i][i] = 0;
		for (int j = i + 1; j < g_size; j++) {
			if (i == 0 && j == 1 ||
				i == 1 && j == 2 ||
				i == 2 && j == 3 ||
				i == 3 && j == 4 ||
				i == 3 && j == 5 ||
				i == 4 && j == 6 ||
				i == 5 && j == 6 ||
				i == 0 && j == 6)
				graph[i][j] = 1;
			else
				graph[i][j] = 0;
			graph[j][i] = graph[i][j];
		}
	}
	showGraph(graph, g_size);
	showChain(graph, g_size);
	cout << "Удаление колец\n";
	graph = removeRings(graph, g_size);
	showGraph(graph, g_size);
	showChain(graph, g_size);
	//////////////////////////////////////////////
	cout << "__Граф #4__\n";
	for (int i = 0; i < g_size; i++)
		delete[] graph[i];
	delete[] graph;
	g_size = 11;
	graph = new int* [g_size];
	for (int i = 0; i < g_size; i++)
		graph[i] = new int[g_size];
	for (int i = 0; i < g_size; i++) {
		graph[i][i] = 0;
		for (int j = i + 1; j < g_size; j++) {
			if (i == 0 && j == 8 ||
				i == 1 && j == 2 ||
				i == 1 && j == 8 ||
				i == 3 && j == 4 ||
				i == 3 && j == 8 ||
				i == 3 && j == 9 ||
				i == 3 && j == 10 ||
				i == 4 && j == 5 ||
				i == 5 && j == 6 ||
				i == 5 && j == 7 ||
				i == 6 && j == 7 ||
				i == 6 && j == 10 ||
				i == 9 && j == 10)
				graph[i][j] = 1;
			else
				graph[i][j] = 0;
			graph[j][i] = graph[i][j];
		}
	}
	showGraph(graph, g_size);
	showChain(graph, g_size);
	removeRings(graph, g_size);
	showGraph(graph, g_size);
	showChain(graph, g_size);
	graph = shrinkGraph(graph, &g_size);
	showGraph(graph, g_size);
}

void showGraph(int** graph, int size)
{
	cout << "Граф:\n   ";
	cout << "\x1B[4m\x1B[94m";
	for (int i = 0; i < size; i++) {
		cout << i << " ";
	}
	cout << "\033[24m\033[0m";
	cout << endl;
	for (int i = 0; i < size; i++) {
		cout << "\x1B[94m" << i << "|\033[0m ";
		for (int j = 0; j < size; j++) {
			if (i == j)
				cout << "\x1B[31m";
			cout << graph[i][j] << " ";
			if (i == j)
				cout << "\033[0m";
		}
		cout << endl;
	}
	cout << endl;
}

void chainPassage(int** graph, int size, int parent, bool* checked) {
	for (int i = 0; i < size; i++) {
		if (i == parent || (checked[i] == true))
			continue;
		if (graph[parent][i] != 0) {
			cout << i << " ";
			checked[i] = true;
			chainPassage(graph, size, i, checked);
			break;
		}
	}
}

void showChain(int** graph, int size)
{
	int start = -1;
	for (int i = 0; i < size; i++) {
		int countLinked = 0;
		for (int j = 0; j < size; j++) {
			if (graph[i][j] != 0)
				countLinked++;
		}
		if (countLinked == 1) {
			start = i;
		} else if (countLinked > 2) {
			cout << "Граф не представляет собой цепочку\n";
			return;
		}
	}
	if (start == -1) {
		cout << "Граф не представляет собой цепочку\n";
		return;
	}
	cout << "Цепочка: ";
	cout << start << " ";
	bool* checked = new bool[size];
	checked[start] = true;
	chainPassage(graph, size, start, checked);
	cout << endl;
}

int** shrinkGraph(int** graph, int* size)
{
	for (int i = 0; i < *size; i++) {
		bool allNull = true;
		for (int j = 0; j < *size; j++) {
			if (graph[i][j] != 0) {
				allNull = false;
				break;
			}
		}
		if (allNull) {
			graph = deleteRing(graph, *size, i);
			(*size)--;
			i = -1;
		}
	}
	return graph;
}

int** graphCopy(int** graph, int size)
{
	int** temp = new int* [size];
	for (int i = 0; i < size; i++)
		temp[i] = new int[size];
	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++)
			temp[i][j] = graph[i][j];
	}
	return temp;
}

bool graphsEquals(int** graph1, int** graph2, int size)
{
	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++)
			if (graph1[i][j] != graph2[i][j])
				return false;
	}
	return true;
}

void excludeRing(int** graph, int size, int ring)
{
	for (int i = 0; i < size; i++) {
		graph[ring][i] = 0;
		graph[i][ring] = 0;
	}
}

int** deleteRing(int** graph, int size, int ring) {
	int** newGraph = new int* [size - 1];
	for (int i = 0; i < size - 1; i++)
		newGraph[i] = new int[size - 1];
	for (int i = 0, ii = 0; i < size; i++, ii++) {
		if (i == ring) {
			ii--;
			continue;
		}
		for (int j = 0, jj = 0; j < size; j++, jj++) {
			if (j == ring) {
				jj--;
				continue;
			}
			newGraph[ii][jj] = graph[i][j];
		}
	}
	for (int i = 0; i < size; i++)
		delete[] graph[i];
	delete[] graph;
	return newGraph;
}

bool arrContains(int* arr, int size, int val) {
	for (int i = 0; i < size; i++)
		if (arr[i] == val)
			return true;
	return false;
}

int* addAsLast(int* arr, int size, int val) {
	int* newArr = new int[size];
	bool inserted = false;
	for (int i = 0; i < size; i++) {
		newArr[i] = arr[i];
		if (!inserted) {
			if (newArr[i] == -1) {
				newArr[i] = val;
				inserted = true;
			}
		}
	}
	return newArr;
}

int lengthOfPath(int* path, int size) {
	int count = 0;
	for (int i = 0; i < size; i++)
		if (path[i] != -1)
			count++;
	return count;
}

int* DFS_longestPath(int** graph, int size, int* path, int last) {
	int* newPath;
	int* actualNextPath = new int[size];
	for (int i = 0; i < size; i++)
		actualNextPath[i] = path[i];
	for (int i = 0; i < size; i++) {
		if (graph[last][i] != 0 && !arrContains(path, size, i)) {
			newPath = addAsLast(path, size, i);
			newPath = DFS_longestPath(graph, size, newPath, i);
			if (lengthOfPath(actualNextPath, size) < lengthOfPath(newPath, size))
				actualNextPath = newPath;
		}
	}
	return actualNextPath;
}

int** BFS_deletingCycles(int** graph, int size, int first)
{
	Queue queue;
	queue.push(first, -1);
	int* visited = new int[size];
	for (int i = 0; i < size; i++)
		visited[i] = -1;
	visited[0] = first;
	while (!queue.isEmpty()) {
		for (int i = 0; i < size; i++) {
			if (graph[queue.peek().val][i] != 0 && i != queue.peek().prev) {
				if (arrContains(visited, size, i)) {
					cout << "В текущем пути есть перекрестный элемент: " << i << endl;
					excludeRing(graph, size, i);
					return graph;
				}
				queue.push(i, queue.peek().val);
				visited = addAsLast(visited, size, i);
			}
		}
		queue.pop().val;
	}
	return graph;
}

int** removeRings(int** graph, int size)
{
	int* longestPath = new int[size];
	int* currPath = new int[size];

	int** startGraph = graphCopy(graph, size);

	bool firstCycle = true;
	//cout << "DFS startGraph:\n";
	//showGraph(startGraph, size);
	//cout << "DFS currGraph:\n";
	//showGraph(graph, size);
	while (!graphsEquals(startGraph, graph, size) || firstCycle) {
		for (int i = 0; i < size; i++) {
			longestPath[i] = -1;
			currPath[i] = -1;
		}
		startGraph = graphCopy(graph, size);
		for (int i = 0; i < size; i++) {
			currPath[0] = i;
			int* longestPathFrom_i = DFS_longestPath(graph, size, currPath, i);
			if (lengthOfPath(longestPath, size) < lengthOfPath(longestPathFrom_i, size)) 
				longestPath = longestPathFrom_i;
		}
		cout << "Самый длинный путь: ";
		for (int i = 0; i < size; i++) {
			if (longestPath[i] != -1)
				cout << longestPath[i] << " ";
		}
		cout << "\n";
		for (int i = 0; i < size; i++) {
			if (!arrContains(longestPath, size, i))
				excludeRing(graph, size, i);
		}
		int** graphWithCycles = graphCopy(graph, size);
		graph = BFS_deletingCycles(graph, size, longestPath[0]);
		//cout << "BFS graphWithCycles:\n";
		//showGraph(graphWithCycles, size);
		//cout << "BFS currGraph:\n";
		//showGraph(graph, size);
		while (!graphsEquals(graphWithCycles, graph, size)) {
			graphWithCycles = graphCopy(graph, size);
			graph = BFS_deletingCycles(graph, size, longestPath[0]);
			//cout << "____________\nBFS startGraph:\n";
			//showGraph(graphWithCycles, size);
			//cout << "BFS currGraph:\n";
			//showGraph(graph, size);
		}
		firstCycle = false;
		//cout << "-------------\nDFS startGraph:\n";
		//showGraph(startGraph, size);
		//cout << "DFS currGraph:\n";
		//showGraph(graph, size);
	}
	return graph;
}