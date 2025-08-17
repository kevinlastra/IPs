



int* sort(int a[], int size)
{
  int tmp;
  for(int i = 0; i < size-1; i++)
  {
    for(int j = 0; j < size-i-1; j++)
    {
      if(a[j] > a[j+1])
      {
        tmp = a[j];
        a[j] = a[j+1];
        a[j+1] = tmp;
      }
    }
  }
  return a;
}

int main()
{
  static int a[10] = {8,6,3,4,5,2,1,9,0,7};
  static int good[10] = {0,1,2,3,4,5,6,7,8,9};

  int* res = sort(&a, 10);

  for(int i = 0; i < 10; i++)
    if(res[i] != good[i])
      return 1;
  return 0;
}

// check with gcc -> ./bubble_sort; echo $?