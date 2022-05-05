// using asm() to force symbol naming to "_riscy_start"
void _riscy_start() asm ("_riscy_start");

extern int main();

void _riscy_start(){
	//init sp
	__asm__("li sp, 0x000493d0");

	//init gp
	__asm__("li gp, 0x00020000");

	main();
}

