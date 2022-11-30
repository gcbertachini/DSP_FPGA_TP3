hold off
clear all
close all

fs = 48000;
Ts=1/fs;

%etapa1
num1=[1  -1.73264454157951375279367312032263725996  1];
den1=[1  -1.686146935574074134933653112966567277908  0.973163806524028007771676129777915775776];
gain1=[0.986829045128113535589875482401112094522 ];
num1=(num1*gain1)/2;
den1=den1/2;
h1=tf(num1,den1);
h1d=c2d(h1,Ts)
h1d.Numerator{1,1}=h1d.Numerator{1,1}/2;
h1d.Denominator{1,1}=h1d.Denominator{1,1}/2;


costheta0alpha1=(h1d.Numerator{1,1}(2))
gamma1=(h1d.Denominator{1,1}(2))/-1
beta1=(h1d.Denominator{1,1}(3))/-1
alpha1=h1d.Numerator{1,1}(1)
h1d.Denominator;
h1d

%etapa2
num2=[1  -1.73264454157951375279367312032263725996  1];
den2=[1  -1.732644561808991179319150433002505451441  0.975168455411941859090063644543988630176];
gain2=[0.986829045128113535589875482401112094522];
num2=(num2*gain2)/2;
den2=den2/2;
h2=tf(num2,den2);
h2d=c2d(h2,Ts)
h2d.Numerator{1,1}=h2d.Numerator{1,1}/2;
h2d.Denominator{1,1}=h2d.Denominator{1,1}/2;


costheta0alpha2=(h2d.Numerator{1,1}(2))
gamma2=(h2d.Denominator{1,1}(2))/-1
beta2=(h2d.Denominator{1,1}(3))/-1
alpha2=h2d.Numerator{1,1}(1)
h2d.Denominator;
h2d


%etap3
num3=[1  -1.73264454157951375279367312032263725996  1];
den3=[1  -1.688431409125209281540946903987787663937  0.948964566714879720343844837771030142903];
gain3=[0.974482283357439915683073650143342092633];
num3=(num3*gain3)/2;
den3=den3/2;
h3=tf(num3,den3);
h3d=c2d(h3,Ts)
h3d.Numerator{1,1}=h3d.Numerator{1,1}/2;
h3d.Denominator{1,1}=h3d.Denominator{1,1}/2;


costheta0alpha3=(h3d.Numerator{1,1}(2))
gamma3=(h3d.Denominator{1,1}(2))/-1
beta3=(h3d.Denominator{1,1}(3))/-1
alpha3=h3d.Numerator{1,1}(1)
h3d.Denominator;
h3d


fid = fopen('coef_ej2.txt','w');

fprintf(fid,'alpha1\tequ\t%0.9f \r\n',alpha1);
fprintf(fid,'beta1\tequ\t%0.9f \r\n',beta1);
fprintf(fid,'gamma1\tequ\t%0.9f \r\n',gamma1);
fprintf(fid,'costheta0_1\tequ\t%0.9f \r\n',costheta0alpha1/alpha1);
fprintf(fid,'alpha2\tequ\t%0.9f \r\n',alpha2);
fprintf(fid,'beta2\tequ\t%0.9f \r\n',beta2);
fprintf(fid,'gamma2\tequ\t%0.9f \r\n',gamma2);
fprintf(fid,'costheta0_2\tequ\t%0.9f \r\n',costheta0alpha2/alpha2);
fprintf(fid,'alpha3\tequ\t%0.9f \r\n',alpha3);
fprintf(fid,'beta3\tequ\t%0.9f \r\n',beta3);
fprintf(fid,'gamma3\tequ\t%0.9f \r\n',gamma3);
fprintf(fid,'costheta0_3\tequ\t%0.9f \r\n',costheta0alpha3/alpha3);

fprintf(fid,'\r\n');

fclose(fid);




