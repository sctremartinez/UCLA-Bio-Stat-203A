data rankings;

  length name $ 50
         location $ 50;
  infile "~/my_shared_file_links/u5338439/US_University_Rankings.csv" dsd firstobs=2;
  informat tuition_and_fees comma10.;
  informat undergrad_enrollment comma10.;
    informat in_state comma10.;
  input name $ 
        location $ 
        rank 
        tuition_and_fees $
        in_state $
        undergrad_enrollment $;

label in_state = "Annual In-State Tuition"; 
label tuition_and_fees = "Tuition and Fees";
label undergrad_enrollment = "Undergraduate Enrollment";
      
run;

proc means data=rankings median;
 var tuition_and_fees;
 var undergrad_enrollment;
 var in_state;
run;



proc format;
 value feefmt low-<20000 = "< $20,000"
              20000-<30000 = "$20,000 to $29,999"
              30000-<40000 = "$30,000 to $39,999"
              40000-<50000 = "$40,000 to $49,999"
              50000-high = "$50,000 or more";
run;

proc freq data=rankings;
 format tuition_and_fees feefmt.;
 tables tuition_and_fees;
run;


proc format;
 value underfmt low-<5000 = "< 5000"
              5000-<10000 = "5,000 to 9,999"
              10000-<15000 = "10,000 to 14,999"
              15000-<25000 = "15,000 to 24,999"
              25000-<35000 = "25,000 to 34,999"
              35000-high = "35,000 or more";
run;

proc freq data=rankings;
 format undergrad_enrollment underfmt.;
 tables undergrad_enrollment;
run;

proc freq data=rankings;
 format tuition_and_fees feefmt.;
 tables location*tuition_and_fees/nopercent;
run;


*ex 3;
proc format;
 value rankfmt low-50 = "Rank 1-50"
              51-100 = "Rank 51-100"
              101-high = "Rank > 100";
 run;


proc freq data=rankings;
 format undergrad_enrollment underfmt.;
  format rank rankfmt.;
  tables undergrad_enrollment * rank / nopercent norow;
run;

*ex4;

proc means data=rankings;
class undergrad_enrollment;
format undergrad_enrollment underfmt.;
run;

**ex5;
proc format;
 value feefmt low-<20000 = "< $20,000"
              20000-<30000 = "$20,000 to $29,999"
              30000-<40000 = "$30,000 to $39,999"
              40000-<50000 = "$40,000 to $49,999"
              50000-high = "$50,000 or more";
run;

data rankings;
  length name $ 50
         location $ 50;
  infile "~/my_shared_file_links/u5338439/US_University_Rankings.csv" dsd firstobs=2;
  informat tuition_and_fees comma10.;
  informat undergrad_enrollment comma10.;
  informat in_state comma10.;
  
  input name $ 
        location $ 
        rank 
        tuition_and_fees 
        in_state 
        undergrad_enrollment;
format in_state feefmt.;
format tuition_and_fees feefmt.;
label name = "Name";
label location = "Location";
label rank = "Rank";
label in_state = "Annual In-State Tuition"; 
label tuition_and_fees = "Tuition and Fees";
label undergrad_enrollment = "Undergraduate Enrollment";
	
run;

proc freq data=rankings;
 format in_state underfmt.;
 tables in_state;
run;

proc contents data=rankings;

run;


**** exercise 6;

libname myfmts "~/my_files/format";
libname mydat "~/my_files/data";
options fmtsearch=(myfmts);

proc format library=myfmts;
value $gendftm "M" = "male"
"F" = "female";
value yesnofmt 1 = "No"
2 = "Yes";

data lung_cancer;
infile "~/my_shared_file_links/u5338439/survey_lung_cancer.csv" dsd firstobs =2;
input gender$
age
smoking
yellow_fingers
anxiety
peer_pressure
chronic_disease
fatigue
allergy
wheezing
alcohol
coughing
shortness_of_breath
swallowing_difficulty
chest_pain
lung_cancer $;

format gender $gendfmt.
age
smoking
yellow_fingers
anxiety
peer_pressure
chronic_disease
fatigue
allergy
wheezing
alcohol
coughing
shortness_of_breath
swallowing_difficulty
chest_pain yesnofmt.;

run;

***exercise 7;
*multiplcation; 
proc freq data=lung_cancer;
 tables gender*anxiety*lung_cancer/list;
run;

*spaces b/t tables it can also be like (a b) * c = ac bc;
proc freq data=lung_cancer;
 tables gender anxiety lung_cancer/list;
run;

proc freq data=lung_cancer;
tables (smoking anxiety peer_pressure alcohol)* lung_cancer/ norow nopercent;
run;



