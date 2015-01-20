%% figure out how to align things
clear;clc; close all;

a = [1 2 3 2 1];
t_a = 3;
b = [2 2 2];
t_b = 8;

shift = 3;
t_as = 0;
t_b = 5;

a_s = conv(1,a);
b_s = conv([zeros(t_b-1,1);1],b);

figure; plot(a,'k-o'); title('a');
figure; plot(b, 'k-o'); title('b');


figure; plot(a_s,'k-o'); title('a_s');
figure; plot(b_s, 'k-o'); title('b_s');