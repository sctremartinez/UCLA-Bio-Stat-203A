libname dt "/home/u63612986/my_files";

data casesubset;
	infile "/home/u63612986/my_files/CaseSubset.csv" dsd firstobs=1;
	input caseid_new subsetnumber;
run;

proc sort data=casesubset;
	by caseid_new;
run;

proc sort data=dt.hcmst;
	by caseid_new;
run;

data dt.my_hcmst;
	merge casesubset (where=(subsetnumber=43) in=ind1) dt.hcmst (in=ind2);
	by caseid_new;
	if ind1 and ind2;
run;

proc format;
	value yesorno (default=20)
	0='No' 1='Yes';
run;

proc format;
	value approval (default=20) 
	0='No' 1='Yes';
run;

proc format;
	value married (default=20) 
	0='No' 1='Yes';
run;

%MACRO MYCHI(varname, varlabel, varformat, dat);
	data indicator;
		set dt.my_hcmst;
		Q9_1=abs(PPAGE-Q9)<=5;
		if PPAGE ne . & Q9 ne .;
	run;
	%MACRO pregunta(prefix_q, ques_var, varname, datname);
		ods output CrossTabFreqs=CTF&prefix_q&ques_var 
			(where=(&prefix_q&ques_var=1 & RowPercent ne .)) 
			ChiSq=CS&prefix_q&ques_var (where=(statistic="Chi-Square"));
		ods trace on;
		ods select summary (nowarn);
		proc freq data=&datname;
			tables &prefix_q&ques_var*&varname/nopercent nocol chisq;
		run;
		ods trace off;
		proc sort data=CTF&prefix_q&ques_var;
			by table;
		run;
		proc sort data=CS&prefix_q&ques_var;
			by table;
		run;

		data CSCTF&prefix_q&ques_var;
			merge CTF&prefix_q&ques_var CS&prefix_q&ques_var;
			by table;
			length label_group $30. pregunta $30.;
			label_group="&prefix_q";
			pregunta="&prefix_q&ques_var";
			keep label_group pregunta &varname frequency rowpercent prob;
		run;

	%MEND;

	%do i=1 %to 9;
		%if &i=1 %then
			%pregunta(Q9_, &i, &varname, indicator);
		%if &i<=7 %then
			%pregunta(Q33_, &i, &varname, &dat);
		%pregunta(Q31_, &i, &varname, &dat);
	%end;
	run;

	data overall_table;
		set CSCTFQ31_1-CSCTFQ31_9 CSCTFQ33_1-CSCTFQ33_7 CSCTFQ9_1;

		select (pregunta);
			when ("Q31_1") pregunta=("1. Work");
			when ("Q31_2") pregunta=("1. School");
			when ("Q31_3") pregunta=("1. Church");
			when ("Q31_4") pregunta=("1. Dating Service");
			when ("Q31_5") pregunta=("1. Vacation");
			when ("Q31_6") pregunta=("1. Bar");
			when ("Q31_7") pregunta=("1. Social Organization");
			when ("Q31_8") pregunta=("1. Private Party");
			when ("Q31_9") pregunta=("1. Other");
			when ("Q33_1") pregunta=("2. Family");
			when ("Q33_2") pregunta=("2. Mutual Friends");
			when ("Q33_3") pregunta=("2. Co-Workers");
			when ("Q33_4") pregunta=("2. Classmates");
			when ("Q33_5") pregunta=("2. Neighbors ");
			when ("Q33_6") pregunta=("2. Self or Partner");
			when ("Q33_7") pregunta=("2. Other");
			when ("Q9_1") pregunta=("3. Age");
			otherwise;
		end;
		select (label_group);
			when ("Q31_") label_group=("1. Where Met Partner:");
			when ("Q33_") label_group=("2. Who Introduced Partner:");
			when ("Q9_") label_group=("3. Similar Age:");
			otherwise;
		end;
	run;

	proc tabulate data=overall_table;
		class &varname label_group pregunta;
		var frequency rowpercent prob;
		table label_group=""*pregunta="", &varname="&varlabel"*(frequency="N"*f=6. 
			rowpercent="%"*f=6.2)*sum="" ALL*prob*mean*f=10.4;
		format &varname &varformat..;
	run;

%MEND;

%MYCHI(PARENTAL_APPROVAL, Parental Approval, yesorno, dt.my_hcmst);

DATA dt.my_hcmst;
	set dt.my_hcmst;
	if RELATIONSHIP_QUALITY="5" then
		Excellent_Indicator=1;
	else if not missing(RELATIONSHIP_QUALITY) then
		Excellent_Indicator=0;
	else
		Excellent_Indicator=.;
RUN;

%MYCHI(Excellent_Indicator, Excellent Indicator,yesorno, dt.my_hcmst);
