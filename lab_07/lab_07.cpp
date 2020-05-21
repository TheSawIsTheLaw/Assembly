#include <iostream>

extern "C" {
	void cpy(char *to, char *from, size_t len);
}

int main() {
	char testString[] = "Wow, such a programm";
	std::cout << testString << std::endl;
	size_t result = 0;

	__asm {
		push ECX
		mov ECX, -1
		mov AL, 0
		lea EDI, [testString]
		repne scasb
		not ECX
		dec ECX
		mov result, ECX
		pop ECX
	}
	std::cout<< result<< "\n";

	char copied[666] = { '\0' };

	cpy(copied, testString, result);

	std::cout << copied << "\n";

	cpy(copied + 4, copied, 6);

	std::cout << copied;

	return 0;
}