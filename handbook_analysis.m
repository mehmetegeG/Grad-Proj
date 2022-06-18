clear all
clc
ID=fopen("Handbook_txt\Handbook.txt","r+");
IDW=fopen("Handbook_txt\Headers&Occurences.txt","a+");
IDW2=fopen("Handbook_txt\Headers&Occurences2.txt","r+");
IDW3=fopen("Handbook_txt\Occurences2.txt","r+");
IDW4=fopen("Handbook_txt\FinalForm.txt","a+");
C = textscan(ID,'%s','Delimiter',{char(10),char(10)},'TreatAsEmpty',newline);
%fclose(ID)
D=cell2table( C{1,1});
D2=D;
K=D(2,1);
X=ismember(D,K);
ns=find(X==0);
D=D(ns,1);
q=0;
%find(hist(a,unique(a))>1)
for i=1:size(D,1)
    chr=char( table2array(D(i,1)));
    s=size(chr,2);
    if s< 4
        continue;
    end
    cout=0;
    for j=1:s
        if uint8(chr(j))>64 && uint8(chr(j))<91
            cout=cout+1;
        end
    end
    if cout/s > 0.5
        q=[q,i];
    end
end
  
D_HEADERS=D(q,1);
%[X Y Z] =unique(D_HEADERS,'stable')
%q(Y);
nat_occ_indexes=0;
for i=1:size(D,1)
    
    
if contains(char(table2cell(D(i,1))),"Natural occurrence:");
    nat_occ_indexes=[nat_occ_indexes;i];
end

end
nat_occ_indexes=nat_occ_indexes(2:size(nat_occ_indexes,1),1);
%nat contains nat occurences
D3=D2(nat_occ_indexes,1);

for i=1:size(nat_occ_indexes,1)
    % qi,nat(j), qi+1 if nat(j) non unique, drop out of error array, and
    % take the first segment
    %i q1, q2 n1----> . or / till . 
    %->seperate it according to ,
    qHeader=q(max(find(q<nat_occ_indexes(i))));
    charqHeader=char(table2array(D(qHeader,1)));
    %fwrite(IDW,char(10)+"***"+char(table2array(D(qHeader,1)))+";");
    %nat_occur_char=char(table2array(D(nat_occ_indexes(i),1)));
    
    j=nat_occ_indexes(i);
    ce=0;
    nat_sum_char="";
    while ce==0 
        nat_occur_char=char(table2array(D(j,1)));
        if  nat_occur_char(size(nat_occur_char,2))=='.' || contains(nat_occur_char,"n/a")
            ce=1;
              findindex=sort(find(nat_occur_char=='a'),"descend");
              findindex=findindex(find(findindex<size(nat_occur_char,2)-2))
            for m=findindex
                if nat_occur_char(m+1)=='n'&& nat_occur_char(m+2)=='d'
                    nat_occur_char(m:m+2)=',  ';
                    break;
                end
            end
            nat_sum_char=nat_sum_char+nat_occur_char;
          
        elseif nat_occur_char(size(nat_occur_char,2))=='-'
            nat_sum_char=nat_sum_char+nat_occur_char(1:(size(nat_occur_char,2)-1));
        else
            nat_sum_char=nat_sum_char+nat_occur_char;
        end
         j=j+1;
    end
        nat_sum_char=char(nat_sum_char);
         %nat_occur_char=char(table2array(D(j,1)));
         %nat_occur_char=replace(nat_occur_char,"and ",',');
         prt1=find(nat_sum_char == '(');
         prt2=find(nat_sum_char == ')');
         if(~isempty(prt1) && ~isempty(prt2))
             for ix=1:min(size(prt1,2),size(prt2,2))
                 nat_sum_char(prt1(ix):prt2(ix))=replace(nat_sum_char(prt1(ix):prt2(ix)),',','&');
             end
         end
         noc_bycomma=textscan(nat_sum_char,"%s","Delimiter",",");
         noc_bycomma=noc_bycomma{1,1};
         for l=1:size(noc_bycomma,1)
         fwrite(IDW4,char(10)+""+charqHeader + ';'+ noc_bycomma(l));
         end
         
    
end
%    SQ=readtable("Handbook_txt\Headers&Occurences2.txt");
%    SQ=SQ(:,4);
%    Xx=textscan(IDW2,"%s");
%    Yy=textscan(IDW3,"%s");
%    theString=Yy{1,1};
%    strq1=find(theString~="Reported" & theString~="found" & theString~="nature")
% wordcloud(wordCloudCounts(theString(strq1)),'Word','Count')
% KX=readtable("Handbook_txt\Occurences2.txt","Delimiter",',',"LineEnding",';');
%%FFHB=readtable("Handbook_txt\FinalForm_Semi1.txt","Delimiter",';');
FFHB=readtable("Handbook_txt\FinalForm.txt","Delimiter",';','ReadVariableNames',false);
FFHB2=FFHB;
%renamevars( FFHB,["1","2","3", "4",],[  "ACETAL" ,"liquors" ,  "Var3" , "Var4"] );
for jcol=6:-1:3
    i=1;
while i<=size(FFHB,1) 
       if ~isequal( table2cell(FFHB(i,jcol)),cell({''}))
        UPtable=FFHB(1:i,:);
        DOWNtable=FFHB(i+1:size(FFHB,1),:);
        neo=table( table2cell(   FFHB(i,1)),table2cell(FFHB(i,jcol)),"","","","" );
        %neo=renamevars( neo,["Var1","Var2","Var3", "Var4","Var5","Var6"],[  "ACETAL" ,"liquors" ,  "Var3" , "Var4"] );
        FFHB=[UPtable;neo;DOWNtable];
        FFHB(i,jcol)=cell2table(cell({''}));
       end
    i=i+1;
end
fprintf("%d\n",jcol);
% for i=1:size(FFHB,1)
%  if ~isequal( table2cell(FFHB(i,3)),cell({''}))
%         UPtable=FFHB(1:i,:);
%         DOWNtable=FFHB(i+1:size(FFHB,1),:);
%          neo=table( table2cell(   FFHB(i,1)),table2cell(FFHB(i,3)),"","" );
%         neo=renamevars( neo,["Var1","Var2","Var3", "Var4"],[  "ACETAL" ,"liquors" ,  "Var3" , "Var4"] );
%         FFHB=[UPtable;neo;DOWNtable];
%         FFHB(i,3)=table("");
%  end
% end   
% 
end
writetable(FFHB(:,1:2),"Handbook_txt\FinalForm_Semi2.txt","Delimiter",";");
%cellFFHB= table2array(  FFHB(:,2));
IDv5=fopen("Handbook_txt\FinalForm_Semi2.txt","r+");
%cellFFHB=table2cell(FFHB(:,2));
textV5=textscan(IDv5,"%s%s","Delimiter",";"  );
textV5=textV5{1,2};
wccText=wordCloudCounts(textV5);
fclose('all');
find(isequal(wccText(:,1),'occurence'))
subwcctext=wccText(1:4,1)
TABLENEO=readtable("Handbook_txt\FinalForm_Semi2.txt","Delimiter",";");
ku=0

[CHEMS CHEMFLAGS Z]=unique(TABLENEO(:,1),'stable');
[FOOD FOODFLAGS Z2]=unique(TABLENEO(:,2),'stable');
find(table2array(TABLENEO(:,2))==char(table2array(CHEMnames(1,1))));
F=size(FOOD,1);
C=size(CHEMS,1);
G=zeros(F+C);

for i=1:(size(CHEMFLAGS,1)-1)
    c1=CHEMFLAGS(i,1);
    c2=CHEMFLAGS(i+1,1);
    for j=1:(c2-c1)
            G(i,C+Z2(j+c1-1))=1;
            G(C+Z2(j+c1-1),i)=1;
    end
    
end
c1=CHEMFLAGS(end,1);c2=size(TABLENEO,1)
for j=1:(c2-c1)
     G(C,C+Z2(j+c1-1))=1;
     G(C+Z2(j+c1-1),C)=1;
end
 %G=G(1:size(zeros(size(FOOD,1))),1:size(zeros(size(FOOD,1))));
 for i=1:size(FOOD,1)
     G(i,i)=0;
 end
 G(1:2:end,:)=0;
 G(1:3:end,:)=0;
 G(1:5:end,:)=0;
 G(1:7:end,:)=0;
 G(:,1:7:end)=0;
 G(:,1:5:end)=0;
 G(:,1:3:end)=0;
 G(:,1:2:end)=0;
Gr=graph(G);
xc=zeros(1,C);
xf=zeros(1,F);xf=xf+9000;
yc=((1:C)*F)/C;
yf=1:F;

sG=sum(G);
sgc=sG(1:C);
sgf=sG(C+1:end);
Sortbyc=sortrows([(1:C)',sgc'],2,'descend');
Sortbyc2=sortrows([Sortbyc(:,1),yc'],1,'ascend')
Sortbyf=sortrows([(1:F)',sgf'],2,'descend');
Sortbyf2=sortrows([Sortbyf(:,1),yf'],1,'ascend')
x=[xc,xf];
y=[Sortbyc2(:,2)',Sortbyf2(:,2)'];

das=randperm(C);
ddasF=randperm(F);ddasF=ddasF+C;
y2=y([das,ddasF]);
iterS=F+1
for i=1:F+C
    if(sG(1,i)==1)
        
        k=find(G(:,i)==1);
        if sG(1,k)==1
            y2(i)=iterS;
            y2(k)=iterS;
            iterS=iterS+3;
        end
    end
end
    plot(Gr,'XData',x,'YData',y2)

for i=1:size(TABLENEO,1)
    S=strsplit( char(table2array(TABLENEO(i,2))));
    if size(S,2)==1
    S{1,1};
    %mkmk=input("");
    ku=[ku;i];
    end
end
for i=1:size(TABLENEO,1)
    if contains(char(table2array(TABLENEO(i,2))),"ssential")
    char(table2array(  TABLENEO(i,2)))
    %mkmk=input("");
    ku=ku+1;
    end
end
for i=1:size(TABLENEO,1)
    if contains(char(table2array(TABLENEO(i,2)))," and ")
    char(table2array(  TABLENEO(i,2))));
    mkmk=input("");
    end
end