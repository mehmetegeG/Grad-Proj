%str = extractFileText("C:\Users\Ege\Downloads\Handbook.pdf",'ExtractionMethod','article');
clear all
clc
%ID=fopen("Handbook_txt\Handbook.txt","a+");
for i=24:2162
s2=extractFileText("C:\Users\Ege\Downloads\Handbook.pdf",'ExtractionMethod','article','Pages',i);
C = textscan(s2,'%s','Delimiter',{char(10),char(10)},'TreatAsEmpty',newline);
D=C{1,1};
if size(D,1)~=0 && size(D,2)~=0
writetable(cell2table(D(6:size(D,1),1)),"Handbook_txt\Handbook.txt",'WriteVariableNames',false,'WriteMode','append');
end
end
Q=K
K=table(["axe"] ,["bax"])
zet=rows2vars([D([1 4],1)])
Q=[K;zet]
s2
c2=char(s2)
table(c2(1,cq))
chr= char(str);
fwrite(ID,chr); 
q=find(chr~=char(10));
cq=find(c2~=char(10));
c2=c2(1,cq);
chr2=chr(1,q);
chr(1,1:400)
k=blanks(size(chr,2));
j=0;

for i=1:size(chr,2)/10
    if chr ~=char(11)
       j=j+1;
    end
end
% x=char(str)
% x(12)
% k=find(x==x(12));
% strreal= 
% for i=1:sizeof(x)
%     if UTF16_to_unicode(x)
%     
% 
% end