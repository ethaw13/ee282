# Problem 1

You are currently in a directory /home/user/projects/, what is the proper method to return to the home directory, and make a directory named homework?

A. `cd /home/user/projects && mkdir homework`  
B. `mkdir homework && cd ~`  
C. `cd ../ && mkdir homework`  
D. `cd ~/ && mkdir homework`  

##### Correct Answer

cd ~/ && mkdir homework


# Problem 2

You are trying to access a specific value in an example matrix data set by:

mymatrix <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 3, ncol = 2)
print(mymatrix)
#      [,1] [,2]
# [1,]    1    4
# [2,]    2    5
# [3,]    3    6

Match what each input would input what value?

- print(mymatrix[,1]) = [1] 1 2 3
- mydf <- as.data.frame(mymatrix) then print(mydf[,1]) = [1] 1 2 3
- print(mydf[1]) = data frame with one column (V1 with values 1, 2, 3)
- print(mydf[[1]]) = [1] 1 2 3
 
 
print(mymatrix[,1])
# [1] 1 2 3

mydf <- as.data.frame(mymatrix)
print(mydf[,1])
# [1] 1 2 3

print(mydf[1])
#   V1
# 1  1
# 2  2
# 3  3

print(mydf[[1]])
# [1] 1 2 3

