void swap(int *v[], int k)
{
     int temp;
     temp = v[k];
     v[k] = v[k+1];
     v[k+1] = temp;
}

void sort (int *v[], int n)
{
    int i, j;

    for (i=0; i<n; i++)
         for (j=i-1; j>=0 && v[j] > v[j+1]; j--)
	      swap(v,j);

}


void __attribute__((noreturn)) mc_main(void)
{
  int i;
  int addr = 0x4545;
  int b = 23;
  //         33    27    53    24   31  23
  int v[] = {b+10, b+4, b+30, b+1, b+8, b};

  sort (&v, 6);

  for(i = 0; i<6; i++)
     *(volatile unsigned int*)addr = v[i];

  /* Wait forever */
  while(1);
}

