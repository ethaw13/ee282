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

**Question:** Which command will show the output with headers?

  V1
1  1
2  2
3  3
```

A. `mymatrix[,1]`  
B. `data_frame[,1]`  
C. `data_frame[1]`  
D. `data_frame[[1]]`

---

**Answer: C** `data_frame[1]` keeps the data structure with column names, while the others just return the numbers `[1] 1 2 3`

# Problem 3

You have a script.sh and want it to be usable by everyone, but only writable by the creator. What form of chmod `XXX` octal permissions would you use?
A. `chmod 777 script.sh`  
B. `chmod 755 script.sh`  
C. `chmod 644 script.sh`  
D. `chmod 700 script.sh`

---

**Answer: B** - `chmod 755 script.sh`

**Explanation:**
- 7 (owner): read + write + execute
- 5 (group): read + execute
- 5 (others): read + execute 

