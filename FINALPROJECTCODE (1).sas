*\ Final project STAT448 Fall 2024 *\;
*\ Markelle Kelly, Rachel Longjohn, Kolby Nottingham,
The UCI Machine Learning Repository, https://archive.ics.uci.edu:
https://archive.ics.uci.edu/dataset/2/adult;
data Salary_S1;
	infile 'C:\Stat 448’' dlm="," missover firstobs=2;
	length WC $16 Education $12 MS $21 Occupation $17 Relationship $13 Race $18 NCountry $18;
	input Age WC $ fnlwgt Education $ Ednum MS $ Occupation $ Relationship $ Race $ Sex $ Capgain Caploss hpw NCountry $ Salary $;
	keep Age WC Education Ednum MS Occupation Relationship Race Sex hpw NCountry Salary;
run;

proc freq data=Salary_S1;
   tables Age WC Education MS Occupation Relationship Race NCountry Salary;
run;

/*Part 1: General descriptive overview of the socio-economic salary related features*/
/*Making Categories*/
proc format;
value agefmt
17 - 34 = 'Teens and Young Adults (17-34)'
35 - 44 = 'Early Middle Age (35-44)'
45 - 64 = 'Late Middle Age (45-64)'
65 - 100 = 'Elderly (65+)';
run;
proc format;
value hpwfmt
1 - 29 = 'Part-time (<30 hours/week)'
30 - 100 = 'Full-time (>=30 hours/week)';
run;
proc format;
value $ncountryfmt
'Canada', 'Cuba','Mexico', 'El-Salvador', 'Guatemala', 'Haiti', 'Jamaica', 'Puerto-Rico', 'United-States' = 'North America'
other = 'Other';
run;
proc format;
value $wcfmt
'Federal-gov', 'Local-gov', 'State-gov' = 'Governmemt'
'Self-emp-inc', 'Self-emp-not-inc', 'Without-pay' = 'Other';
run;
proc format;
value $edfmt
'Preschool', '1st-4th', '5th-6th', '7th-8th' = 'Primary and Secondary School'
'9th', '10th', '11th', '12th', 'HS-grad' = 'High School'
'Some-college', 'Assoc-acdm', 'Bachelors', 'Masters', 'Doctorate' = 'College'
'Prof-school', 'Assoc-voc' = 'Professional Schooling';
run;
proc format;
value ednumfmt
1 - 4 = '1-4'
5 - 8 = '5-8'
9 - 12 = '9-12'
13 - 16 = '13-16';
run;
proc format;
value $msfmt
'Married-AF-spouse', 'Married-civ-spouse', 'Married-spouse-absent' = 'Married'
'Divorced', 'Separated', 'Widowed' = 'No Longer Married'
other = 'Never Married';
run;
proc format;
value $occfmt
'Adm-clerical', 'Exec-managerial', 'Tech-support' = 'White Collar'
'Farming-fishing', 'Handlers-cleaners', 'Machine-op-inspct', 'Craft-repair', 'Transport-moving' = 'Blue Collar'
'Other-service', 'Priv-house-serv', 'Protective-serv' = 'Service'
'Prof-specialty', 'Sales' = 'Other';
run;
proc format;
value $relfmt
'Husband', 'Wife' = 'Spouse'
'Own-child', 'Other-relativ' = 'Family'
'Unmarried', 'Not-in-family' = 'Other';
run;
proc format;
value $racefmt
'Amer-Indian-Eskimo', 'Asian-Pac-Islander', 'Other' = 'Other';
run;
/*Descriptive Statistics + Graphs*/
proc freq data=Salary_S1;
   tables Age WC Education Ednum MS Occupation Relationship Race Sex hpw NCountry Salary;
   format Age agefmt. hpw hpwfmt. NCountry $ncountryfmt. WC $wcfmt. Education $edfmt. Ednum ednumfmt.
   MS $msfmt. Occupation $occfmt. Relationship $relfmt. Race $racefmt.;
run;
proc univariate data=Salary_S1;
	var Age Ednum hpw;
	format Age agefmt. hpw hpwfmt. NCountry $ncountryfmt. WC $wcfmt. Education $edfmt. Ednum ednumfmt.
   MS $msfmt. Occupation $occfmt. Relationship $relfmt. Race $racefmt.;
run;
proc univariate data=Salary_S1;
  var Age Ednum hpw;
  histogram Age Ednum hpw;
  probplot Age Ednum hpw;
  ods select Histogram ProbPlot;
run;

/*Part 2: Provide an appropriate potential association between the salary categories and each
categorical (nominal/ordinal) or continuous predictors. What are your main conclusions from these preliminary
analysis?*/
/*Test for potential association between each categorical variable and Salary*/
proc freq data=Salary_S1;
	tables Salary*MS /nopercent norow nocol expected chisq;
	format MS $msfmt.;
run;
proc freq data=Salary_S1;
	tables Salary*WC /nopercent norow nocol expected chisq;
	format WC $wcfmt.;
run;
proc freq data=Salary_S1;
	tables Salary*Education /nopercent norow nocol expected chisq;
	format Education $edfmt.;
run;
proc freq data=Salary_S1;
	tables Salary*Occupation /nopercent norow nocol expected chisq;
	format Occupation $occfmt.;
run;
proc freq data=Salary_S1;
	tables Salary*Relationship /nopercent norow nocol expected chisq;
	format Relationship $relfmt.;
run;
proc freq data=Salary_S1;
	tables Salary*Race /nopercent norow nocol expected chisq;
	format Race $racefmt.;
run;
proc freq data=Salary_S1;
	tables Salary*Sex /nopercent norow nocol expected chisq;
run;
proc freq data=Salary_S1;
	tables Salary*NCountry /nopercent norow nocol expected fisher;
	format NCountry $ncountryfmt.;
run;
/*quant vars*/
proc freq data=Salary_S1;
	tables Salary*Age /nopercent norow nocol expected chisq;
	format Age agefmt.;
run;
proc freq data=Salary_S1;
	tables Salary*Ednum /nopercent norow nocol expected chisq;
	format Ednum ednumfmt.;
run;
proc freq data=Salary_S1;
	tables Salary*Hpw /nopercent norow nocol expected chisq;
	format Hpw hpwfmt.;
run;
/*correlation matrix for cont. variables*/
proc corr data=Salary_S1 spearman;
	var Age Ednum Hpw;
	format Age agefmt. Ednum ednumfmt. Hpw hpwfmt.;
run;

/*Potential modeling*/
proc logistic data=Salary_S1;
	class MS Education Occupation Relationship Race Sex NCountry Age Ednum Hpw/ param=ref;
	model Salary(event = '>50k') = MS Education Occupation Relationship Race Sex NCountry Age Ednum Hpw/lackfit;
	format Age agefmt. Ednum ednumfmt. Hpw hpwfmt. MS $msfmt. Education $edfmt. Occupation $occfmt. Relationship $relfmt.
		   Race $racefmt. NCountry $ncountryfmt.;
run;
/*residual plot*/
proc genmod data=Salary_S1 plots=(stdreschi stdresdev);
	class MS Education Occupation Relationship Race Sex NCountry Age Ednum Hpw/ param=ref;
	model Salary = MS Education Occupation Relationship Race Sex NCountry Age Ednum Hpw/dist=binomial
	link = logit type1 type3;
	output out=res pred=Salary2 stdreschi = presids
	stdresdev=dresids;
	ods select ModelInfo DiagnosticPlot;
	format Age agefmt. Ednum ednumfmt. Hpw hpwfmt. MS $msfmt. Education $edfmt. Occupation $occfmt. Relationship $relfmt.
		   Race $racefmt. NCountry $ncountryfmt.;
run;
	
/*feature selection + final model chosen*/
proc logistic data=Salary_S1;
	class Age Ednum Occupation NCountry Sex/param=ref;
	model Salary(event = '>50k') = Age Ednum Occupation NCountry Sex/selection = stepwise sls=0.05 sle=0.05;
	format Age agefmt. Ednum ednumfmt. Occupation $occfmt. NCountry $ncountryfmt.;
run;

/*model evaluation: ROC/AUC curve, cross−validation, information criteria, and sensitivity analysis*/
/*resid plot */
proc genmod data=Salary_S1 plots=(stdreschi stdresdev);
	class Age Ednum Occupation NCountry Sex/ param=ref;
	model Salary = Age Ednum Occupation NCountry Sex/dist=binomial
	link = logit type1 type3;
	output out=res pred=Salary2 stdreschi = presids
	stdresdev=dresids;
	ods select ModelInfo DiagnosticPlot;
	format Age agefmt. Ednum ednumfmt. Occupation $occfmt. NCountry $ncountryfmt.;
run;

proc logistic data=Salary_S1 desc plots(only)=roc;
	class Age Ednum Occupation NCountry Sex/param=ref;
	model Salary(event = '>50k') = Age Ednum Occupation NCountry Sex;
    output predprobs=individual out=salary_out;
    format Age agefmt. Ednum ednumfmt. Occupation $occfmt. NCountry $ncountryfmt.;
run;
* compare levels observed with levels predicted;
proc freq data=salary_out;
    tables Salary*_into_/nopercent norow nocol out=CellCounts;
run;

data CellCounts;
	set CellCounts;
	Match=0;
	if Salary=_into_ then Match=1;
run;

proc means data=CellCounts mean;
	freq count;
	var Match;
run;

/*adding an interaction term*/
proc logistic data=Salary_S1;
	class Age Ednum Occupation NCountry Sex/param=ref;
	model Salary(event = '>50k') = Age | Ednum | Occupation | NCountry | Sex @2 / ss1 ss3;
	format Age agefmt. Ednum ednumfmt. Occupation $occfmt. NCountry $ncountryfmt.;
run;
proc freq data=Salary_S1;
    tables Age*Ednum*Occupation*NCountry*Sex / nocol nopercent;
run;
/*none of the predictors are significant... perform stepwise*/
proc logistic data=Salary_S1;
	class Age Ednum Occupation NCountry Sex/param=ref;
	model Salary(event = '>50k') = Age|Ednum|Occupation|NCountry|Sex @2/selection=stepwise sls=0.05 sle=0.05;
	format Age agefmt. Ednum ednumfmt. Occupation $occfmt. NCountry $ncountryfmt.;
run;



