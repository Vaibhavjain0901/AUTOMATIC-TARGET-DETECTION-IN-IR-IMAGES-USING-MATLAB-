clear all;
close all;
clc;

%read the thermal image and store it in a variable
 %a=imread('tank.jpg');
   % a=imread('atd1.bmp');
%  a=imread('cameraman.tif');
 a=imread('atd2.bmp');
 
 %if image is 3D convert it into 2D
a = a(:,:,1);

[x,y]=size(a);

figure;imshow(a);title('original image');

%select a low pass filter i.e guassian filter
hsize=[15 15];
h=fspecial('gaussian',hsize);

%filter the original by guassian filter
b=imfilter(a,h);

%for double precision use 'double'
a = double(a);
b = double(b);
%Difference image
d=abs(a-b);
d1=max(max(d));
d2=min(min(d));
 figure;imshow(uint8(d));title('difference image');
%normalize the difference image
for i=1:x
    for j=1:y
        n(i,j)=(d(i,j)-d2)/(d1-d2);
    end
end
%optimum thresholding using otsu function
t=graythresh(a)/20
%thresholding
for i=1:x
    for j=1:y
        if( n(i,j)>=t)
            n(i,j)=255;
        else
            n(i,j)=0;
        end
            
    end
end
figure;imshow(uint8(n));title('threshold image');

%pass the image through median filter
l=medfilt2(n,[3 3]);
figure;imshow(uint8(l));title('FilteredImage image');

%find properties of the binary image
props2=regionprops(l,'all');
[M N]=size(props2)
% M is the no. of blobs 
for k=1:M
    
centroid1=props2(k).Centroid
q=props2(k).BoundingBox



%find the coordinates of region of interest
topleft_y=floor(q(1))
topleft_x=floor(q(2))
bottomright_y=floor(q(1)+q(3))
bottomright_x=floor(q(2)+q(4))

 if (topleft_x > x)
     topleft_x=x
 else if(topleft_x <1)
topleft_x =1
     end
 end
     
 if (topleft_y > y)
     topleft_y=y
 else if(topleft_y < 1)
     topleft_y=1
     end
 end
 if (bottomright_x <1)
    bottomright_x=1
 else if(bottomright_x >x)
    bottomright_x=x
     end
 end
 if (bottomright_y <1)
    bottomright_y=1
 else if (bottomright_y >y)
    bottomright_y=y
     end    
 end
 
 %store ROI in other matrix
 for i=topleft_x:bottomright_x
     for j=topleft_y:bottomright_y
         
         l1(i,j)=l(i,j);
     end
 end
 
 %find maximum and minimum pixels of ROI
i1=max(max(l1));
i2=min(min(l1));

% similarity function
%Compute similarity of each pixel by in the ROI.
%similarity is from 0 to 1. 1 means that the intensity 
%of current pixel is same with the
%maximum intensity of reference region. 
for i=topleft_x:bottomright_x
     for j=topleft_y:bottomright_y
         
        s(i,j)=1-(abs(i1-l1(i,j))/(i1-i2));
    end
end


%adjacency function
% Compute adjacency of a pixel based on the seed position.
%seed position that is centroid of the reference region.
% Adjacency ranges from 0 to 1. 
for i=topleft_x:bottomright_x
     for j=topleft_y:bottomright_y
          dist(i,j)=sqrt((((i-centroid1(1))^2)+(j-centroid1(2))^2));
  if (dist(i,j)==0)
    
      adj(i,j)=1;
else
    adj(i,j)=2/(1+sqrt(dist(i,j)));
end
end
end

%membership function
%membership value ranges from 0 to 1.

for i=topleft_x:bottomright_x
     for j=topleft_y:bottomright_y

        u(i,j)=0.6*s(i,j)+0.4*adj(i,j);
        
    end
end

%final threshold image

for i=topleft_x:bottomright_x
     for j=topleft_y:bottomright_y
        if( u(i,j)>=0.22)
            g(i,j)=255;
        else
            g(i,j)=0;
        end
            
    end
end
end
figure;imshow(uint8(g));title('local thresholding image');




[g num1]=bwlabel(g,4);
 
measurements=regionprops(g,'all');

totalNumberOfBlobs=length(measurements);
for i=1:totalNumberOfBlobs
ad=measurements(i).Area; 
bbox=measurements(i).BoundingBox;
   if ((ad < 350) || (ad>450)||(bbox(4)<5))  %for adt2
%   if ((ad < 50) || (ad>150)) %for adt1
% % if ((ad < 40) || (ad>100)) %for tank
g(g==i)=0;
  else 
  end

end

 figure;imshow((g));title('final target image');
 
 figure;imshow(uint8(a));title('target image');
%  %creating bounding box around the target
 measurements1 = regionprops(g,'BoundingBox','Centroid');
 totalNumberOfBlobs1 = length(measurements1);
hold on;

for blobNo = 1:totalNumberOfBlobs1
bb = measurements1(blobNo).BoundingBox;
bc = measurements1(blobNo).Centroid;
if((bb(3)||bb(4))~=0)
%  rectangle   Create rectangle, rounded-rectangle, or ellipse.
% rectangle adds a default rectangle to the current axes.
%  rectangle('Position', [x y w h]) adds a rectangle at the 
% specified position.
  rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
plot(bc(1),bc(2),'-m+')  
else

end 
end
hold off;
man=0;
tank=0;
for blobNo = 1:totalNumberOfBlobs1
bb = measurements1(blobNo).BoundingBox;
if((bb(3)<bb(4))&&((bb(3)||bb(4))~=0))
    man=man+1;
else if((bb(3)>bb(4))&&((bb(3)||bb(4))~=0))
    tank=tank+1;
    else
    end
end
end
no_of_tank=tank
army_personal=man

