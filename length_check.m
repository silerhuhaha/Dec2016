%Detective of wheat length
clc;
clear all;
close all;

%Set the path to 'read' file
SearchFolder = '.\image\'; %No character allowed in the path
%Set the postfix of the file
SearFlag = '*.JPG';  

%Auto operation
Buffer = dir([SearchFolder SearFlag]); 
%Find number of files
Number = length(Buffer);
%Create output file
fOut = fopen([SearchFolder 'check_result.txt'], 'w+');
for n = 1:Number
    PathName = [SearchFolder Buffer(n).name];
    %Read file
    imgSrc = imread(PathName);
    %length detective
    [maxLength target] = DetectTargetLength(imgSrc);
    %Spikelet calculate
    total = calcuNumber(target);
    %Save result
  fwrite(fOut, PathName);
  fprintf(fOut, '   length = %fcm  total = %f\r\n', maxLength , total);
end
fclose(fOut);
str = sprintf( 'Function finished, total files processed:%.0f',Number);
helpdlg(str);






  
  
  
  
  