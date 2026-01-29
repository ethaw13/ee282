# Problem 1

You are currently in a directory /home/user/projects/, what is the proper method to return to the home directory, and make a directory named homework?

A. `cd /home/user/projects && mkdir homework`  
B. `mkdir homework && cd ~`  
C. `cd ../ && mkdir homework`  
D. `cd ~/ && mkdir homework`  

**Answer: D**

cd ~/ && mkdir homework


# Problem 2

You are trying to access some values in an example matrix data set by:
```
mymatrix <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 3, ncol = 2)
data_frame <- as.data.frame(mymatrix)
print(mymatrix)
      [,1] [,2]
 [1,]    1    4
 [2,]    2    5
 [3,]    3    6

mymatrix <- matrix(c(5, 4, 3, 2, 5, 4), nrow = 3, ncol = 2)



**Question:** Which command will show the output with headers?

  V1
1  5
2  4
3  3
```

A. `mymatrix[,1]`  
B. `data_frame[,1]`  
C. `data_frame[1]`  
D. `data_frame[[1]]`

---

**Answer: C** `survey_df[1]` keeps the data structure with column names, while the others just return the numbers `[1] 5 4 3`





 

