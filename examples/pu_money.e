new;
cls;

data_test = loadd("money.dat");   

// Number of common factors
m = 6; 

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
