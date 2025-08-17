


void j1();
void j2();
void j3();

int main()
{
  j1();   

  return 0;
}

void j2()
{
  char a = '1';
  j3();
}

void j1()
{
  int a = 8*3;
  j2();
  int c = a;
}

void j3()
{
  int a = 2;
  int b = a * 3;
}