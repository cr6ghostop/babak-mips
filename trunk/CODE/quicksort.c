
#define maxsize 6

int A[maxsize];

void quicksort(int a, int b)
{


  int rtidx=0,ltidx=0,k=a,l=0,pivot;
  int leftarr[maxsize],rtarr[maxsize];

  pivot=A[a];

  if(a==b)return;

  while(k<b) {
   ++k;

   if(A[k]<A[a]){
     leftarr[ltidx]=A[k];
     ltidx++;
   }
   else {
    rtarr[rtidx]=A[k];
    rtidx++;
   }
  }

  k=a;

  for(l=0;l<ltidx;++l)
     A[k++]=leftarr[l];

  A[k++]=pivot;

  for(l=0;l<rtidx;++l)
     A[k++]=rtarr[l];

  if(ltidx>0)
    quicksort(a,a+ltidx-1);

  if(rtidx>0)
    quicksort(b-rtidx+1,b);

}

 


void __attribute__((noreturn)) mc_main(void)
{

  int i;
  int addr = 0x4545;

  A[0] = 34;
  A[1] = 45;
  A[2] = 3;
  A[3] = 23;
  A[4] = 77;
  A[5] = 12;

  quicksort(0,5);

  for(i = 0; i<6; i++)
     *(volatile unsigned int*)addr = A[i];

  /* Wait forever */
  while(1);

}
