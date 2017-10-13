#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

int main (int argc, char *argv[])
/******************************************************************************
  Author: Xiaodong Chen 2012-Sep-19

  Description:
  This finds the wanted value in an ascii Arc file.
  Currently:  whole searching, searching within col, searching within row
  
  Note:
  The input file should have the standard arc format, i.e. 6 header lines,col
  number first.

  Modifications:
  Added the stats for row results                     XC    Sep 26, 2013

******************************************************************************/
{
  FILE *fdata;
  int b,c,i,j,k,m,p,r,s,u,v,w;
  int nrows_data,ncols_data;
  int col_n,*count_col,count_row, count_global;
  float nodata_data;
  float **data,value;
  float max_threshold, min_threshold, *sum_col, sum_row, sum_global;
  char choice[10],key[10];

  char tmpstr2[30];

  /* Define default value*/
  max_threshold = -9999;
  min_threshold = 9999;

  /* Usage */
  if(argc!=5) {
    fprintf(stdout,"Usage: Find the global/col/row max/min/sum/avg value in an Arc map file\n");
    fprintf(stdout,"  %s <ArcFile> <choice> <key> <col_number> \n",argv[0]);
    fprintf(stdout,"  <ArcFile>     ascii Arc map file\n");
    fprintf(stdout,"  <choice>      whole, col, row\n");
    fprintf(stdout,"  <key>         max, min, avg, sum\n");
    fprintf(stdout,"  <col_number>  if choice == col, then specify the col number\n");
    exit(0);
  }

  strcpy(choice,argv[2]);
  strcpy(key,argv[3]);
  col_n = atoi(argv[4]);

  if((fdata=fopen(argv[1],"r"))==NULL)   {
    fprintf(stderr,"%s: ERROR: Unable to open %s\n",argv[0],argv[1]);
    exit(1);
  }

  /* Read in the header info */
  fscanf(fdata,"%*s %d",&ncols_data);
  fscanf(fdata,"%*s %d",&nrows_data);
  fscanf(fdata,"%*s %s",tmpstr2);
  fscanf(fdata,"%*s %s",tmpstr2);
  fscanf(fdata,"%*s %s",tmpstr2);
  fscanf(fdata,"%*s %f",&nodata_data);

  /* Allocate wet_data array */
  if ( (data = (float**)calloc(nrows_data,sizeof(float*))) == NULL ) {
    fprintf(stderr,"argv[0]: ERROR: cannot allocate sufficient memory for data array\n",argv[0]);
    exit(1);
  }
  for (i=0; i<nrows_data; i++) {
    if ( (data[i] = (float*)calloc(ncols_data,sizeof(float))) == NULL ) {
      fprintf(stderr,"argv[0]: ERROR: cannot allocate sufficient memory for data array\n",argv[0]);
      exit(1);
    }
  }
  if ( (sum_col = (float*)calloc(ncols_data,sizeof(float))) == NULL ) {
    fprintf(stderr,"argv[0]: ERROR: cannot allocate sufficient memory for sum_col array\n",argv[0]);
    exit(1);
  }
  if ( (count_col = (int*)calloc(ncols_data,sizeof(int))) == NULL ) {
    fprintf(stderr,"argv[0]: ERROR: cannot allocate sufficient memory for count_col array\n",argv[0]);
    exit(1);
  }

  /* Read data into data array */
  for(i=0;i<nrows_data;i++) {
    for(j=0;j<ncols_data;j++) {
      fscanf(fdata,"%f",&(data[i][j]));
    }
  } 

  fclose(fdata);

//  printf("finished data loading\n");


  /* Find the wanted value */
  for(i=0; i<nrows_data; i++) {
    if(strcmp(choice,"row")==0) {
      max_threshold = -9999;
      min_threshold = 9999;
      count_row=0;
      sum_row=0;
      for(j=0; j<ncols_data; j++) {
//fprintf(stdout,"data[%d][%d]=%f\n",i,j,data[i][j]);
        if(data[i][j]!=nodata_data) {
          if(strcmp(key,"max")==0 && data[i][j]> max_threshold) {
            max_threshold = data[i][j]; 
          }
          if(strcmp(key,"min")==0 && data[i][j]< min_threshold) {
            min_threshold = data[i][j];
          }
          if(strcmp(key,"sum")==0 || strcmp(key,"avg")==0) {
            sum_row+=data[i][j];
            count_row++;;
          }
        }
      }
      if(strcmp(key,"max")==0) {
        fprintf(stdout,"row max is %f\n",max_threshold);
      }
      if(strcmp(key,"min")==0) {
        fprintf(stdout,"row min is %f\n",min_threshold);
      }
      if(strcmp(key,"sum")==0) {
        if(count_row==0) sum_row=nodata_data;
        fprintf(stdout,"row sum is %f\n",sum_row);
      }
      if(strcmp(key,"avg")==0) {
        if(count_row!=0) {
          fprintf(stdout,"row mean is %f\n",sum_row/(float)count_row);
        }
        else {
          fprintf(stdout,"row mean is %f\n",nodata_data);
        }
      }
    }
    if(strcmp(choice,"whole")==0 || strcmp(choice,"col")==0) {
      for(j=0; j<ncols_data; j++) {
        if(strcmp(choice,"col")==0) {
          value = data[i][col_n];
        }
        if(strcmp(choice,"whole")==0) {
          value = data[i][j];
        }
        if(value!=nodata_data) {
          if(strcmp(key,"max")==0) {
            if(value> max_threshold) {
              max_threshold = value;
            }
          }
          if(strcmp(key,"min")==0) {
            if(value< min_threshold) {
              min_threshold = value;
            }
          }
          if((strcmp(key,"sum")==0 || strcmp(key,"avg")==0)) {
            if(strcmp(choice,"whole")==0) {
               sum_global+= value;
               count_global++;
            }
            if(strcmp(choice,"col")==0) {
              if(value!= nodata_data) {
                sum_col[j]+= value;
                count_col[j]++; 
              }
            }
          }
        }
      }
    }
  }

 /* Print the result */
  if(strcmp(choice,"whole")==0 || strcmp(choice,"col")==0) {
    if(strcmp(key,"max")==0) {
      fprintf(stdout,"maximum is %f\n",max_threshold);
    }
    if(strcmp(key,"min")==0) {
      fprintf(stdout,"minimum is %f\n",min_threshold);
    }
    if(strcmp(choice,"whole")==0 && strcmp(key,"sum")==0) {
      if(count_global==0) sum_global=nodata_data;
      fprintf(stdout,"total sum is %f\n",sum_global);
    }
    if(strcmp(choice,"whole")==0 && strcmp(key,"avg")==0) {
      if(count_global!=0) {
        fprintf(stdout,"global avg is %f\n",sum_global/(float)count_global);
      }
      else {
        fprintf(stdout,"global avg is %f\n",nodata_data);
      }
    }
    if(strcmp(choice,"col")==0 && strcmp(key,"avg")==0) {
      fprintf(stdout,"the col averaged value is \n");
      for(i=0; i<ncols_data; i++) {
        if(count_col[i]!=0) {
          fprintf(stdout,"%f  ",sum_col[i]/(float)(count_col[i]));
        }
        else {
          fprintf(stdout,"%f  ",nodata_data);
        }
      }
      fprintf(stdout,"\n");
    }
    if(strcmp(choice,"col")==0 && strcmp(key,"sum")==0) {
      fprintf(stdout,"col sum is \n");
      for(i=0; i<ncols_data; i++) {
        if(count_col[i]==0) sum_col[i]=nodata_data; 
        fprintf(stdout,"%f  ",sum_col[i]);
      }
      fprintf(stdout,"\n");
    }
  }
}
