# analysis.R

This repo contains the script "analysis.R" for the course project of "Getting and Cleaning Data".

The script performs the analysis in several steps.

1. First it loads the needed packages and download the data files from the internet
2. Secondly, it defines a function called `create_full_set()` that can be used to combine together the different data assets of one study group. The function is called with references to the all the needed files for one group: `X set`, `y set`, `subject set`, `activity label set` and `feature` (column label set). It performs the following steps:
	- Load the `X set` in a data frame
	- Name its columns using the column names stored in the column label set
	- Filter the columns to only keep the one related to "std" and "mean"
	- Load the `y set` and the `activity` in data frames
	- Combine these two to create a data frame having both the activity id and label (same length as `X set`)
	- Load the `subject set` in a data frame (same length as `X set` and `y set`)
	- Bind (by columns) `X set`, `y set` and `subject set` into one data frame, returned by the function
3. Thirdly, use the `create_full_set` function to create a full set for the `training` and `test` sets
4. Bind (by rows) these two full sets into one so that we have all subjects in one data frame
5. Using `reshape2`, summarize the dataframe to see the mean of each variable per subject and activity
6. Write a file with this summary table
