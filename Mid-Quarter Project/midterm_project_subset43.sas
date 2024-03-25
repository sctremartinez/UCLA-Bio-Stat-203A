libname mq "~/my_files/data/";

data MYFAMIDS;
set mq.FAMIDSUBSET;
if SUBSETNUMBER = 43;
run;

proc sort data=MYFAMIDS; BY FAMID; RUN;
proc sort data=mq.W2007; BY FAMID; RUN;

data mq.my_w2007;
merge MYFAMIDS ( IN = IND1)
	  mq.W2007( IN =IND2);
by FAMID;
if IND1 and IND2;
run;
	

proc sort data=MYFAMIDS; BY FAMID; RUN;
proc sort data=mq.W2011; BY FAMID; RUN;

data mq.my_w2011;
merge MYFAMIDS ( IN = IND1)
	  mq.W2011( IN =IND2);
by FAMID;
if IND1 and IND2;
run;

/* both 2007 and 2011 */
data mq.both_07_11;
merge mq.my_W2007 (in=ind1) mq.W2011 (in=ind2);
by FAMID;
if ind1 and ind2;
run;

/* only in 2007 */
data mq.only_07;
merge mq.my_W2007 (in=ind1) mq.W2011 (in=ind2);
by FAMID;
if ind1 and not ind2;
run;
	
proc format;
  value genderfmt
    0='Female'
    1='Male'
    .='Missing';
run;

/* Calculate frequencies and percentages for Gender among both files */
proc freq data=mq.both_07_11;
tables W1C542C / missing nocum ;
format W1C542C genderfmt.;
label W1C542C = 'GENDER (CORRECTED 7/25/94)';
run;

/* Calculate frequencies and percentages for Gender among only 2007 file */
proc freq data=mq.only_07;
tables W1C542C / missing nocum;
format W1C542C genderfmt.;
label W1C542C = 'GENDER (CORRECTED 7/25/94)';
run;

proc sort data=mq.W2007; by FAMID; run;
proc sort data=mq.W2011; by FAMID; run;

proc format;
  value edufmt
    1-2='High School or Less'
    3='Technical or Vocational'
    4-5='Some College'
    6='Bachelor’s Degree'
    7-8='Graduate Degree'
    -8, -9='Missing';
run;

/* Calculate frequencies and percentages for Education levels among both files */
proc freq data=mq.both_07_11;
tables C1ED17  / missing nocum norow nocol;
format C1ED17 edufmt. ;
title 'W17 C1 Highest level of education';
run;

/* Calculate frequencies and percentages for Education levels among only 2007 file */
proc freq data=mq.only_07;
tables C1ED17 / missing nocum;
format C1ED17 edufmt.;
label C1ED17 = 'W17 C1 Highest level of education';
run;


proc format;
  value empfmt
    1='No'
    2='Yes'
    -8, -9='Missing';
run;

proc freq data=mq.both_07_11;
tables D617 / missing nocum;
format D617 empfmt.;
label D617 = 'W17 D6 Currently employed (either part-time or full-time)';
run;


proc freq data=mq.only_07;
tables D617 / missing nocum;
format D617 empfmt.;
label D617 = 'W17 D6 Currently employed (either part-time or full-time)';
run;


proc format;
  value relafmt
    1='No'
    2='Yes'
    -8, -9='Missing';
run;

proc freq data=mq.both_07_11;
tables F1017 / missing nocum;
format F1017 relafmt.;
label F1017 = 'Currently Married or Cohabitating in an Intimate Relationship?';
run;


proc freq data=mq.only_07;
tables F1017 / missing nocum;
format F1017 relafmt.;
label F1017 = 'Currently Married or Cohabitating in an Intimate Relationship?';
run;

proc format;
  value chilfmt
    1='No'
    2='Yes'
    -8, -9='Missing';
run;

proc freq data=mq.both_07_11;
tables F517 / missing nocum;
format F517 chilfmt.;
label F517 = 'W17 F5 Do you have any children?';
run;


proc freq data=mq.only_07;
tables F517 / missing nocum;
format F517 chilfmt.;
label F517 = 'W17 F5 Do you have any children?';
run;



/* Format for D1417 (How secure is your primary job?) */
proc format;
  value jobsecurity
    -9, -8='Missing'
    1='Not secure at all'
    2='Somewhat secure'
    3='Secure'
    4='Very secure';
run;

/* Format for D1817 (How satisfied with your job as a whole?) */
proc format;
  value jobsatisfaction
    1-2='Extremely or very dissatisfied'
    3='Somewhat dissatisfied'
    4='Somewhat satisfied'
    5-6='Extremely or very satisfied';
run;

/* Calculate frequencies and percentages for job security among employed individuals in both files */
proc freq data=mq.both_07_11;
tables D1617 / missing nocum;
where D617 = 2; /* Filter for employed individuals */
format D1617 jobsecurity.;
label D1617 = 'How secure is your primary job?';
title 'Job Security among Employed Individuals (Both Files)';
run;

/* Calculate frequencies and percentages for job security among employed individuals in only the 2007 file */
proc freq data=mq.only_07;
tables D1617 / missing nocum;
where D617 = 2; /* Filter for employed individuals */
format D1617 jobsecurity.;
label D1617 = 'How secure is your primary job?';
title 'Job Security among Employed Individuals (2007 Only)';
run;

/* Calculate frequencies and percentages for job satisfaction among employed individuals in both files */
proc freq data=mq.both_07_11;
tables D1817 / nocum;
where D617 = 2; /* Filter for employed individuals */
format D1817 jobsatisfaction.;
label D1817 = 'How satisfied with your job as a whole?';
title 'Job Satisfaction among Employed Individuals (Both Files)';
run;

/* Calculate frequencies and percentages for job satisfaction among employed individuals in only the 2007 file */
proc freq data=mq.only_07;
tables D1817 /  nocum;
where D617 = 2; /* Filter for employed individuals */
format D1817 jobsatisfaction.;
label D1817 = 'How satisfied with your job as a whole?';
title 'Job Satisfaction among Employed Individuals (2007 Only)';
run;








*table 2;

/* both 2007 and 2011 */
proc print data= mq.only_07;
var BIRTMO17 BIRTYR17;
run;

proc print data= mq.both_07_11;
var BIRTMO17 BIRTYR17;
run;

data mq.both_07_11 (keep = age);
set mq.both_07_11;
age = (((10-BIRTMO17) + ((2007-BIRTYR17)*12))/12);
run;

data mq.only_07 (keep = age);
set mq.only_07;
age = (((10-BIRTMO17) + ((2007-BIRTYR17)*12))/12);
run;


proc means data = mq.both_07_11 n mean std;
var age;
run;

proc means data = mq.only_07 n mean std;
var age;
run;

****************** income;

proc print data= mq.both_07_11;
var E5HI17;
run;


proc means data = mq.both_07_11 n mean std;
var E5HI17;
run;

proc means data = mq.only_07 n mean std;
var E5HI17;
run;

proc print data= mq.both_07_11;
var H13A17;
run;


**********mental h;

data adjusted2007; 
 set mq.only_07; 
 array varsreverse(*) H13A17 H13D17 H13F17 H13I17 H13N17 H13O17; 
 do i = 1 to dim(varsreverse); 
  varsreverse{i} = 6 - varsreverse{i}; 
 end; 
 drop i; 
run; 
 
data adjusted2007sum; 
 set adjusted2007; 
 total_score = sum(of H13A17 H13B17 H13C17 H13D17 H13E17 H13F17 H13G17 H13H17 H13I17 H13J17 H13K17 H13L17 H13M17 H13N17 H13O17)
 ;
run; 

proc means data=adjusted2007sum; 
 var total_Score; 
run; 
 
data adjusted20072011; 
 set mq.both_07_11; 
 array varsreverse(*) H13A17 H13D17 H13F17 H13I17 H13N17 H13O17; 
 do i = 1 to dim(varsreverse); 
  varsreverse{i} = 6 - varsreverse{i}; 
 end; 
 drop i; 
run; 
 
data adjusted20072011sum; 
 set adjusted20072011; 
 total_score = sum(of H13A17 H13B17 H13C17 H13D17 H13E17 H13F17 H13G17 H13H17 H13I17 H13J17 H13K17 H13L17 H13M17 H13N17 H13O17)
 ;
run; 
 
proc means data = adjusted20072011sum; 
 var total_score; 
run;







*table 3;

proc freq data = mq.both_07_11;
tables E2STRE19;
run;

proc tabulate data = mq.both_07_11;
var E117 E2STRE19;
table (E117 E2STRE19 )* (N mean STD);
run;


proc freq data= mq.both_07_11;
tables E3BILL19;
run;

proc tabulate data = mq.both_07_11;
   var E217 E3BILL19;
   where E217 ne .; /* This condition filters out missing values in E217 */
   table (E217 E3BILL19)* (N mean STD);
run;

*table 4;

proc freq data=mq.both_07_11;
tables D3CNRA17/missing;
run;

proc tabulate data = mq.both_07_11 format=4. missing;
class D3CNRA17 D4CNRA19;
table (D3CNRA17 D4CNRA19)* (n*f=5. pctn*f=pctfmt.) ;
run;


proc tabulate data = mq.both_07_11 format=4. missing;
class D3CNRB17 D4CNRB19;
table (D3CNRB17 D4CNRB19)* (n*f=5. pctn*f=pctfmt.) ;
run;


proc tabulate data = mq.both_07_11 format=4. missing;
class D3CNRC17 D4CNRD19;
table (D3CNRC17 D4CNRD19)* (n*f=5. pctn*f=pctfmt.) ;
run;


proc tabulate data = mq.both_07_11 format=4. missing;
class D3CNRE17 D4CNRE19;
table (D3CNRE17 D4CNRE19)* (n*f=5. pctn*f=pctfmt.) ;
run;

proc tabulate data = mq.both_07_11 format=4. missing;
class D3CNRF17 D4CNRF19;
table (D3CNRF17 D4CNRF19)* (n*f=5. pctn*f=pctfmt.) ;
run;

proc tabulate data = mq.both_07_11 format=4. missing;
class D3CNRD17 D4CNRI19;
table (D3CNRD17 D4CNRI19)* (n*f=5. pctn*f=pctfmt.) ;
run;


proc tabulate data = mq.both_07_11 format=4. missing;
class D3CNRI17 D4CNRJ19;
table (D3CNRI17 D4CNRJ19)* (n*f=5. pctn*f=pctfmt.) ;
run;

proc tabulate data = mq.both_07_11 format=4. missing;
class D3CNRJ17 D4CNRK19;
table (D3CNRJ17 D4CNRK19)* (n*f=5. pctn*f=pctfmt.) ;
run;





