function [T] = HFC11(X,S)
%T最后聚类的最佳结果,原始数据X, S: a triad -- (i,j,s) the i-th and j-th samples with -1<=s<=1 for fuzzy
[n,~]=size(X);
pairS=S(:,[1 2]);
[m,~]=size(pairS);
%对原始数据进行层次聚类
Z = linkage(X,'average','euclidean');
%% 将Z的第三列表示距离的元素提取出来，进行归一化，得到a
Z11=Z(:,3);
Z1=unique(Z11,'rows');
[k,~]=size(Z1);
% k=k1-1;
HA=zeros(k,1);
HA(1,1)=0;
vec = max(Z1);
B = repmat(vec,k,1);
Z2= Z1./B;
%% 将层次聚类得到的结果按照距离分割,得到不同的聚类，求出对应的Ca，ha；
for i=2:k
        a=1-Z2(i,1);
        a1=Z1(i,1);
        T1=cluster(Z,'cutoff',a1,'Criterion','distance');
        %对每个不为零的a,确定一个矩阵Ca
        Ca=zeros(n,n);
        for p=1:n
            for q=1:n
                if T1(p,1)==T1(q,1)
                    Ca(p,q)=1;
                else
                    Ca(p,q)=0;
                end
            end
        end
  %将pairS中的每一对对应的Ca找出来
        Ca1=zeros(m,1);
         for i2=1:m
            p1=pairS(i2,1);
            p2=pairS(i2,2);
            Ca1(i2)=Ca(p1,p2);
         end
  
   
   %求ha
   vm=1;vc=1;wm=-0.5;wc=-0.5;   
   for i1=1:m
         ha=0;
        if S(i1,3)>=a && Ca1(i1)==1
            ha=ha+vm;
        elseif S(i1,3)>=a && Ca1(i1)==0
            ha=ha+wm;
        elseif S(i1,3)<=(-a) && Ca1(i1)==0
            ha=ha+vc;
        elseif S(i1,3)<=(-a) && Ca1(i1)==1
            ha=ha+wc;
        end
   end
   HA(i,1)=ha;
end
%找出最大值对应的地址
HH=HA(2:k);
[~,i2]=max(HH);
a11=Z1(i2+1,:);
T=cluster(Z,'cutoff',a11,'Criterion','distance');

end