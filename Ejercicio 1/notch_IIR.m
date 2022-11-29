close all

%Notch

fs=48e3
T=1/fs
fc=4000;
wc=2*pi*fc;
%T=1/44100;

%Parte analogica
q=1;
a=1/(wc^2);
b=1/(q*wc);



sigma=1
mu=(2*T^2-8*a)/(4*a+T^2)
alpha=(1/2)*(4*a+T^2)/(4*a+2*b*T+T^2)

beta=(1/2)*(4*a-2*b*T+T^2)/(4*a+2*b*T+T^2)
gamma=-(1/2)*(-8*a+2*T^2)/(4*a+2*b*T+T^2)

cos_theta_0=(gamma)/(beta+0.5)

%n=[alpha mu*alpha sigma*alpha];
n=[alpha alpha*(-2)*cos_theta_0 alpha];

d=[0.5  -gamma  beta];


%=======================================================
f=linspace(100,8000,1000); %Desde,hasta,Nro de puntos 
s = exp(sqrt(-1)*2*pi*f*T);
h = polyval(n,s) ./ polyval(d,s);
%================================================================






mag=abs(h);
magdb=20*log10(mag);
plot(f,magdb,'g')
ylabel('DB')
xlabel('Hertz    IIR-Invariante al impulso')

figure

plot(f,mag,'g')



fid = fopen('coef.txt','w');

fprintf(fid,'alpha\tequ\t%0.9f \r\n',alpha);
fprintf(fid,'beta\tequ\t%0.9f \r\n',beta);
fprintf(fid,'gama\tequ\t%0.9f \r\n',gamma);
fprintf(fid,'cos_theta_0\tequ\t%0.9f \r\n',cos_theta_0);
fprintf(fid,'sigma\tequ\t%0.9f \r\n',sigma);

fprintf(fid,'\r\n');

fclose(fid);



