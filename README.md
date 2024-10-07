# DS4002-Group9

## Section 1: Software and Platform

### Two main types of software were used to complete our Analysis

###   1) R Studio
####   Packages used: dplyr, ggplot2, tm, stringr
###   2) Python
####   Packages used: pandas, matplotlib.pyplot

### Both Mac and Windows platforms were used to conduct our analysis

## Section 2: Map of Documentation
### In this repository, we have 3 main folders:
#### 1) SCRIPTS - This folder includes our source code for the project with detailed comments outlining the actions being taken to clean and analyze the dataset.

#### CleaningSentimentAnalysis: code to clean the data, calculate sentiment scores, and form datasets for analysis. Additionally includes code that generates graphs located in output.
#### InitialEDA: code to perform Exploratory Data Analysis using python. 

#### 2) DATA - This folder holds our raw data, as well as our finalized data that was used to drive analysis.

#### Data Appendix: description of sentimentdf variables and descriptive graphs. 
#### drugsComTest_raw: raw text data of drug reviews.
#### lessbc: top 10 least reviewed birth control drug brands (over threshold of 20) separated from original dataset.
#### sentimentdf: sentiment score added to initial dataset filtered by birth control. 
#### toptenbc: top 10 most reviewed birth control drug brands separated from original dataset. 

#### 3) OUTPUT - This folder includes the output of our analysis, including charts and graphs to support or oppose our hypothesis. 

#### Project 1 Output: file holding graphs produced from CleaningSentimentAnalysis file.

## Section 3: Instructions for Reproducing Results
#### To reproduce the results of our analysis, the first step is to install the packages necessary in R. Next, we read in our dataset, included in the DATA folder of this repository.

#### To clean the dataset, we created a new dataset from the original only including rows where "birth control" is listed under the "condition" column. 

#### The exploratory analysis began with creating a bar graph showing the number of patients on each birth control type using the ggplot function. In order to understand the reviews of the drugs, we calculated sentiment scores based on an imported Lexicon including both positive and negative words and phrases. This allowed us to generate scores, the positive and negative representing the overall sentiment, for each drug brand name based on their reviews.

#### In our text mining process, we used three functions to remove URL and other characters from the text data. This processed text was then added as an additional column to the dataset to complete further sentiment analysis in the same method described before. This column was then renamed to allow the abilty to merge on a shared column.

#### Following this analysis, the birth control brands were then organized by frequency of reviews, or total number of rows per brand name. A new dataset was then created from the top 10 most reviewed drugs. Additionally, a new dataset was created of the least reviewed drugs, with a cutoff at 20 reviews (20 reviews minimum).

#### With these new datasets, a rating vs. sentiment score scatterplot was created for both the top 10 most reviewed and 10 least reviewed drugs. Finally, boxplots were used to show the range of the sentiment score per each drug for the most and least reviewed brand names. 

