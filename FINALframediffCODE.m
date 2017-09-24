clc;
close all;
clear all;
%Reading video
video = VideoReader('atdt_person_running.avi'); 
%  nframes = length(video);
 nframes=video.NumberOfFrames;

%  nframes = get(video, 'NumberOfFrames');
 nframes=100;
%Storing frames of the video in an array

for i=1:nframes
mov(i).cdata=read(video,i);
% Creating '.cdata' field to avoid much changes to previous code
end

%Running loop for processing every frame of the video
for g=20:4:nframes
%Read Current Frame
CurrentFrame=mov(g).cdata;
adjframe=mov(g-1).cdata;

%Read Rows and Columns of the Image
[rows columns]=size(CurrentFrame);
%Create Binary Image with the help of Frame difference method
for i=1:rows
for j=1:columns
if((CurrentFrame(i,j)-adjframe(i,j))<5)
    BinaryImage(i,j)=0; 
else
BinaryImage(i,j)=1;
end
end
end
%Apply Median filter to remove Noise
FilteredImage=medfilt2(BinaryImage,[5 5]);
%Boundary Label the Filtered Image
[L num]=bwlabel(FilteredImage);
STATS=regionprops(L,'all');

%Remove the noisy regions by filling up the holes in binary image
for i=1:num
ad=STATS(i).Area; 
if (ad < 100)
L(L==i)=0;
else 
end
end
[L2 num2]=bwlabel(L);
%Display the current frame along with the bounding box
figure(1)
imshow(CurrentFrame);
hold on;
 %creating bounding box around the bolbs
measurements = regionprops(L2,'BoundingBox','Centroid');
totalNumberOfBlobs = length(measurements);
for blobNo = 1:totalNumberOfBlobs
bb = measurements(blobNo).BoundingBox;
bc = measurements(blobNo).Centroid;
rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
plot(bc(1),bc(2),'-m+')
end 
end

