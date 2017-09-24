clear all;
close all;
clc;

 %a=imread('tank.jpg');
  %  a=imread('atd1.bmp');
%  a=imread('cameraman.tif');
 a=imread('atd2.bmp');
a = a(:,:,1);
[x,y]=size(a);

figure;imshow(a);title('original image');
hsize=[15 15];
h=fspecial('gaussian',hsize);

b=imfilter(a,h);
a = double(a);
b = double(b);
i1=impyramid(b,'reduce');
i2=impyramid(i1,'reduce');
i3=impyramid(i2,'reduce');
i4=impyramid(i3,'reduce');
i5=impyramid(i4,'reduce');
i6=impyramid(i5,'reduce');
% figure;imshow(a);title('gaussian pyr1 image');
% figure;imshow(i1);title('gaussian pyr2 image');
% figure;imshow(i2);title('gaussian pyr3 image');
% figure;imshow(i3);title('gaussian pyr4 image');
% figure;imshow(i4);title('gaussian pyr5 image');
% figure;imshow(i5);title('gaussian pyr6 image');
% figure;imshow(i6);title('gaussian pyr7 image');

int1 = imresize(i1, 2);
int2 = imresize(i2, 4);
int3 = imresize(i3, 8);
int4 = imresize(i4, 16);
int5 = imresize(i5, 32);
% int6 = imresize(i6, 64);
figure;imshow(uint8(a));title('intensity1 image');
figure;imshow(uint8(int1));title('intensity2 image');
figure;imshow(uint8(int2));title('intensity3 image');
figure;imshow(uint8(int3));title('intensity4 image');
figure;imshow(uint8(int4));title('intensity5 image');
figure;imshow(uint8(int5));title('intensity6 image');
% figure;imshow(uint8(int6));title('intensity7 image');
 

% center-surround difference
cs0=abs(a-b);
cs1=abs(int1-int3);
cs2=abs(int1-int4);
cs3=abs(int2-int4);
cs4=abs(int2-int5);
cs5=abs(int3-int5);
% cs6=int3-int6;

figure;imshow(uint8(cs1));title('intensity2 image');
figure;imshow(uint8(cs2));title('intensity3 image');
figure;imshow(uint8(cs3));title('intensity4 image');
figure;imshow(uint8(cs4));title('intensity5 image');
figure;imshow(uint8(cs5));title('intensity6 image');

cs0max=max(max(cs0));
cs0min=min(min(cs0));
cs1max=max(max(cs1));
cs1min=min(min(cs1));
cs2max=max(max(cs2));
cs2min=min(min(cs2));
cs3max=max(max(cs3));
cs3min=min(min(cs3));
cs4max=max(max(cs4));
cs4min=min(min(cs4));
cs5max=max(max(cs5));
cs5min=min(min(cs5));

% normalize intensity feature maps
for i=1:x
    for j=1:y
        f0(i,j)=(cs0(i,j)-cs0min)/(cs0max-cs0min);
    end
end
for i=1:x
    for j=1:y
        f1(i,j)=(cs1(i,j)-cs1min)/(cs1max-cs1min);
    end
end
for i=1:x
    for j=1:y
        f2(i,j)=(cs2(i,j)-cs1min)/(cs2max-cs2min);
    end
end
for i=1:x
    for j=1:y
        f3(i,j)=(cs3(i,j)-cs3min)/(cs3max-cs3min);
    end
end
for i=1:x
    for j=1:y
        f4(i,j)=(cs4(i,j)-cs4min)/(cs4max-cs4min);
    end
end
for i=1:x
    for j=1:y
        f5(i,j)=(cs5(i,j)-cs5min)/(cs5max-cs5min);
    end
end
% %divide original image into 4 parts
% for i=1:(x/2)
%     
%     for j=1:(y/2)
%         
%        a1(i,j)=a(i,j);
%     
%     end
% end
% 
% for i=1:x/2
%     for j=(y/2)+1:y
%        a2(i,j)=a(i,j);
%     end
% end
% 
% for i=(x/2)+1:x
%     for j=1:y/2
%        a3(i,j)=a(i,j);
% 
%     end
% end
% 
% for i=(x/2)+1:x
%     for j=(y/2)+1:y
%        a4(i,j)=a(i,j);
% 
%     end
% end

%perform optimum thresholding on each intensity map using otsu's method
t0=graythresh(f0)
t1=graythresh(f1)
t2=graythresh(f2)
t3=graythresh(f3)
t4=graythresh(f4)
t5=graythresh(f5)
for i=1:x
    for j=1:y
        if( f0(i,j)>=t0)
            n0(i,j)=255;
        else
            n0(i,j)=0;
        end
            
    end
end
figure;imshow(uint8(n0));title('threshold0 image');
for i=1:x
    for j=1:y
        if( f1(i,j)>=t1)
            n1(i,j)=255;
        else
            n1(i,j)=0;
        end
            
    end
end
figure;imshow(uint8(n1));title('threshold1 image');

for i=1:x
    for j=1:y
        if( f2(i,j)>=t2)
            n2(i,j)=255;
        else
            n2(i,j)=0;
        end
            
    end
end
figure;imshow(uint8(n2));title('threshold2 image');

for i=1:x
    for j=1:y
        if( f3(i,j)>=t3)
            n3(i,j)=255;
        else
            n3(i,j)=0;
        end
            
    end
end
figure;imshow(uint8(n3));title('threshold3 image');
for i=1:x
    for j=1:y
        if( f4(i,j)>=t4)
            n4(i,j)=255;
        else
            n4(i,j)=0;
        end
            
    end
end
figure;imshow(uint8(n4));title('threshold4 image');
for i=1:x
    for j=1:y
        if( f5(i,j)>=t5)
            n5(i,j)=255;
        else
            n5(i,j)=0;
        end
            
    end
end
figure;imshow(uint8(n5));title('threshold5 image');

%binary OR operation on binary intensity feature maps

n=or(n1,n2);
n=or(n,n0);
n=or(n,n3);
n=or(n,n4);
n=or(n,n5);

figure;imshow(n);title('threshold image');

% apply median filter
l=medfilt2(n,[3 3]);
figure;imshow(l);title('FilteredImage image');

% label the image
[l num]=bwlabel(l,4);
figure;imshow((l));title('binary image');


%find properties of the image that is centroid & boundingbox
props2=regionprops(l,'all');
[M N]=size(props2)

for k=1:M
centroid1=props2(k).Centroid
q=props2(k).BoundingBox




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
 
 for i=topleft_x:bottomright_x
     for j=topleft_y:bottomright_y
         
         l1(i,j)=l(i,j);
     end
 end
i1=max(max(l1));
i2=min(min(l1));

% similarity function
for i=topleft_x:bottomright_x
     for j=topleft_y:bottomright_y
         
        s(i,j)=1-(abs(i1-l1(i,j))/(i1-i2));
    end
end

% adjacency function
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
figure;imshow(uint8(g));title('local threshold image');
% rectangle('Position',q,'EdgeColor','r','LineWidth',2)


%label the image
[g num1]=bwlabel(g,4);
 
measurements=regionprops(g,'all');

totalNumberOfBlobs=length(measurements);

for i=1:totalNumberOfBlobs
ad=measurements(i).Area; 
bb1 = measurements(i).BoundingBox;
   if ((ad < 50) || (ad>150)||(bb1(4)<5))  %for adt2
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
  rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
plot(bc(1),bc(2),'-m+')  
else

end 
end
hold off;

%target recognisation
no_of_man=0;
no_of_tank=0;
for blobNo = 1:totalNumberOfBlobs1
bb = measurements1(blobNo).BoundingBox;
if((bb(3)<bb(4))&&((bb(3)||bb(4))~=0))
    no_of_man=no_of_man+1;
else if((bb(3)>bb(4))&&((bb(3)||bb(4))~=0))
    no_of_tank=no_of_tank+1;
    else
    end
end
end
no_of_man
no_of_tank
    % %template matching
% 
% template=imread('target_image1.bmp');
% [p,q]=size(template);
% u,v=1
% for i=u:x
%     for j=v:y
%         
%  for m=u:p
%     for n=v:q
%         
%         
%    
%     end
%     u=u+1;
%     v=v+1;
%     q=+1;
%     p=p+1;
% end
%         
       
                
                