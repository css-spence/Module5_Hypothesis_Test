/* Import data from the the sub-industry level sheet in EMSI_JobChange_UK.xlsx. */
FILENAME REFFILE '/folders/myfolders/EMSI_JobChange_UK.xlsx';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT REPLACE;
	GETNAMES=YES;
	SHEET="2 Digit";
/* 
   Select 2011 and 2014 job numbers for the manufacturing industry and 
   aggregate the yearly job numbers to the city level. 
*/
PROC SQL;    
   CREATE TABLE UK_manufacturing AS    
   SELECT city, sum(Jobs_2011) AS Total_Jobs_2011, sum(Jobs_2014) as Total_Jobs_2014 
   FROM WORK.IMPORT 
   WHERE SIC_1_name = "MANUFACTURING" 
   GROUP BY city; 
QUIT;
/* 
   Print the aggregated set of observations and calculated Pearson correlation coefficient to
   measure the strength of the relationship between 2011 and 2014 job numbers.
*/
PROC PRINT DATA=UK_manufacturing;
   TITLE "Manufacturing Jobs by City";
run;

PROC CORR DATA=UK_manufacturing pearson;
   TITLE "Correlation between 2011 and 2014 Job Numbers";
run;
/* Invoke the TTEST procedure to produce the results of the paired sample t-Test and visualizations. */
ods graphics on;
PROC TTEST DATA=UK_manufacturing;
   paired Total_Jobs_2011*Total_Jobs_2014;
   TITLE "Paired T-Test Results";
run;
ods graphics off;
