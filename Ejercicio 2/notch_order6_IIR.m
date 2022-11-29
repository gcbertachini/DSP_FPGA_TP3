hold off
clear all
close all

% Especificaciones: Low Pass con:
fs = 48000;
fp1 = 3400;
fs1 = 3800;
fs2 = 4200;
fp2 = 4600;
fhp1=3600;
fhp2=4400;


Ap = 4
Aa = 40


% Diseño del filtro Pasa bajos usando ventana de kaiser 

'Calculo de alfa y N'

%deltaa=10^(-.05*Aa);
%deltap=(10^(.05*Ap)-1)/(10^(.05*Ap)+1);
%delta=min([deltaa,deltap]);
%Aa=-20*log10(delta);			           %nuevo

%==========================================================================

%Normalizamos respecto de fs

fp1=fp1/fs;
fs1=fs1/fs;
fp2=fp2/fs;
fs2=fs2/fs;
fhp1=fhp1/fs;
fhp2=fhp2/fs;

%fc1=(fp1+fs1)/2;	 %frecuencia de corte 1 normalizada respecto de fs
%fc2=(fp2+fs2)/2;	 %frecuencia de corte 2 normalizada respecto de fs

%==========================================================================

bpFilt = designfilt('bandstopiir','FilterOrder',20, 'HalfPowerFrequency1',fhp1,'HalfPowerFrequency2',fhp2, ...
        'SampleRate',1);

fvtool(bpFilt)

h = bpFilt.Coefficients

%==========================================================================

W=linspace(0,pi,3000);		%genera un vector de 3000 puntos e
a=1;																																									
																						%																						jw
[H,W]=freqz(h,a,W);   		%calculo el vector H(ejwt)
																						%h es el denominador, a el numerador (a=1 en un FIR)
F=(W/(2*pi))*fs;			%cambio de escala en el eje x de manera que Ws=1
  		  			
modulo=abs(H);
fase=angle(H);

%==========================================================================

%Banda pasante
figure(1)
plot(F,20*log10(modulo));
title('Banda Pasante')
v=[fp1*fs,fp2*fs,-1,1];
axis(v);
grid

%Banda atenuada
figure(2)
plot(F,20*log10(modulo));
title('Banda Atenuada')
v=[0,.125*fs,-80,10];
axis(v);
grid

%Salvo coeficientes (h(n))
h=h';
ntaps=length(h)

fid = fopen('bp_coef.txt','w');

    fprintf(fid,'coef\tequ\t*\r\n');
    fprintf(fid,'\r\n');
    fprintf(fid,'\t\t\tdc\t%0.9f \r\n',h);
    fprintf(fid,'\r\n');
    fprintf(fid,'\r\n');
    fprintf(fid,'ntaps\tequ\t%u \r\n',ntaps);

fprintf(fid,'\r\n');

fclose(fid);

!asm filtro  % compile and link 
!lnk filtro  % executable code is filtro.cld




