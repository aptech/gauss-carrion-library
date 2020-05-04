new;
cls;

data_test = loadd("gdp.dat");   @ gdp  @

// Number of common factors
m = 1; 

print "++++++++";
print "Constant";
print "++++++++";
case = 2;
testvec = pu_mp04(data_test, m, case);

print testvec[2:3]~cdfn(testvec[2:3]);
print;

print "++++++++++";
print "Time trend";
print "++++++++++";
case = 3;
testvec = pu_mp04(data_test, m, case);

print testvec[2:3]~cdfn(testvec[2:3]);
