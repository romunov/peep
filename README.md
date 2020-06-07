peep
========================

R's default `head` or `tail` functions print 6 or so rows and all columns. When you have a dataset that has a rather large number of columns, printing can be very poor, spilling over several rows.

The default output would look like

```
> dim(xy)
[1]  43 205

> head(xy)
    Sample   SLC25A5      MEOX1       CD4       HFE     GABRA3     RNH1        VIM       MYOC
1 sample 1 169.28930 0.08670971 18.975543 14.149516 0.10174355 5.021980 1674.99418  0.2268739
2 sample 2 122.55490 0.11898911 16.644021  5.116629 0.06980979 4.246349  610.15708  0.9339964
3 sample 3  13.49505 0.39190042  7.006248  8.686389 0.61902692 1.242957   88.91675 11.1807812
4 sample 4 111.84583 0.07831660  8.329725  2.129984 0.34920184 8.478207  194.47382  0.0000000
       CAPG      ZIC2       EPHA3      ELN      NTN1     ABCC9    CYBRD1      NTN4    NUAK1  SLC25A3
1 48.951242 0.9216751  5.97980198 3.591096 4.5935819 12.916405 45.980617 10.402553 6.992939 81.73932
2 10.396297 1.0434491 19.52954610 4.078562 5.2744688 40.005469 17.813941 15.819005 9.638139 60.31633
3  2.468217 3.6529801  2.96681949 5.578765 0.5051865  6.682470  1.563846  1.976812 2.269706 11.34410
4 24.162310 3.4463885  0.07879854 3.225239 2.1506768  1.343375 20.593887  4.886979 3.763131 56.44569
...
```

spilling columns over several lines with no end in sight for data with large number of colums (think expressions in bioinformatics).

It came down to typing `xy[1:5, 1:5]` for the rest of my life or develop a function that would make this easier. Enter `peep`. It prints a few first and last rows and columns. If any columns or rows have been omitted, it adds a horizontal or vertical delimiter of dots to indicate that there's something there.

```
> peep(xy)
       Sample SLC25A5   MEOX1    CD4    HFE  GABRA3    MMP12 SPON1   MSMB  CCL4  CCL3
01:  sample 1   169.3 0.08671  18.98  14.15  0.1017  ·  5.77 45.49  8.803 77.19 76.08
02:  sample 2   122.6   0.119  16.64  5.117 0.06981  · 114.9 274.7 0.2449 44.92 41.04
03:  sample 3    13.5  0.3919  7.006  8.686   0.619  · 4.861 2.803    278 9.299 5.599
04:  sample 4   111.8 0.07832   8.33   2.13  0.3492  · 146.8 560.5      0 25.22 16.66
05:  sample 5   92.04       0 0.9135 0.8531  0.8672  · 91.63 8.617  4.848 8.899  6.03
06:  sample 6   63.44  0.3779  4.487  11.16   4.573  · 273.6  7.65  20.03 15.84 9.727
            ·       ·       ·      ·      ·       ·  ·     ·     ·      ·     ·     ·
38: sample 38   119.9 0.06032  2.194  8.856       0  · 1.158 4.308      0 8.464 19.14
39: sample 39   83.36       0  5.265  1.505       0  · 7.512 225.4      0 17.25 16.83
40: sample 40   100.1       0  4.783  1.692       0  · 88.81 18.54      0 55.66 5.438
41: sample 41   77.02 0.01632  14.92  3.389 0.01915  ·     0 68.71      0 18.79  11.5
42: sample 42   39.37  0.1706  4.553  4.284  0.2891  · 6.476 20.21  8.893 21.19 9.978
43: sample 43   36.44       0  1.064  4.322  0.4157  · 0.544 5.627      0 5.444 2.933
```

This works has been inspired by [`data.table`](https://github.com/Rdatatable/data.table) and [pandas](https://github.com/pandas-dev/pandas), a package for working with DataFrames in Python.

# Installation

To install from GitHub, try using package `remotes`

```
remotes::install_github("romunov/peep")
```
