
close all
clear all
clc

% M = load('mapaXand.bmp');
M2 = imread ('mapa01.bmp');
ba = size(M2,1);
aa = length(M2);
M = uint8(128*ones(ba,aa, 3));
% M2 = (M(:,:,1)*128) + (M(:,:,2)*128) + (M(:,:,3)*128);
L = 10;
x=28;
y=28;

x1 = round(x/L)*L;
y1 = round(y/L)*L;
if(x1==0), x1=1;end
if(y1==0), y1=1;end    
for c = x1:1:x1+L-1
   for l= y1:1:y1+L-1

           M(c+1,l+1,1)=255;
           M(c+1,l+1,2)=0;
           M(c+1,l+1,3)=0;
   end
end

x=50;
y=50;

x1 = round(x/L)*L;
y1 = round(y/L)*L;
if(x1==0), x1=1;end
if(y1==0), y1=1;end    
for c = x1:1:x1+L-1
   for l= y1:1:y1+L-1

           M(c+1,l+1,1)=0;
           M(c+1,l+1,2)=255;
           M(c+1,l+1,3)=0;

   end
end

x=10;
y=10;

x1 = round(x/L)*L;
y1 = round(y/L)*L;
if(x1==0), x1=1;end
if(y1==0), y1=1;end    
for c = x1:1:x1+L-1
   for l= y1:1:y1+L-1

           M(c+1,l+1,1)=0;
           M(c+1,l+1,2)=0;
           M(c+1,l+1,3)=255;

   end
end


for c = 1:L:size(M,1)-1
   for l= 1:L:size(M,2)-1

           M(c,l:1:l+L,1)=255;
           M(c,l:1:l+L,2)=0;
           M(c,l:1:l+L,3)=0;
   end
end

for c = 1:L:size(M,1)-1
   for l= 1:L:size(M,2)-1
           M(c:1:c+L,l,1)=255;
           M(c:1:c+L,l,2)=0;
           M(c:1:c+L,l,3)=0;
   end
end


figure
imshow(M);
% figure
% imshow(M2);