
%% White Shark Optimizer (WSO) source codes  
%
%  MATLAB R2019b
%

% �����Ż��㷨��һ�����ȫ���Ż���������ͷ���Ԫ����ʽ�㷨


function [fmin0,gbest,ccurve]=WSO(whiteSharks,itemax,lb,ub,dim,fobj)
 
%% ��������
ccurve=zeros(1,itemax);

%%% ��ʾ��������
    figure (1);
    set(gcf,'color','w');
    hold on
    xlabel('Iteration','interpreter','latex','FontName','Times','fontsize',10)
    ylabel('fitness value','interpreter','latex','FontName','Times','fontsize',10); 
    grid;

%% ���� WSO �㷨
% ��ʼ�������������
WSO_Positions=initialization(whiteSharks,dim,ub,lb);% Initial population

%��ʼ�ٶ�
v=0.0*WSO_Positions; 

%% ������ʼ��Ⱥ����Ӧ��
fit=zeros(whiteSharks,1);

for i=1:whiteSharks
     fit(i,1)=fobj(WSO_Positions(i,:));
end

%% ��ʼ��WSO�Ĳ���
fitness=fit; % WSO ���λ�õĳ�ʼ��Ӧ��
 
[fmin0,index]=min(fit);

wbest = WSO_Positions;% ���λ�ó�ʼ��
gbest = WSO_Positions(index,:);% ��ʼȫ��λ��

%% WSO ����
    fmax=0.75; % �����˶������Ƶ��
    fmin=0.07; % �����˶�����СƵ��
    tau=4.11;  
       
    mu=2/abs(2-tau-sqrt(tau^2-4*tau));

    pmin=0.5;
    pmax=1.5;
    a0=6.250;  
    a1=100;
    a2=0.0005;
 %% ��ʼWSO�ĵ�������
for ite=1:itemax

    mv=1/(a0+exp((itemax/2.0-ite)/a1)); 
    s_s=abs((1-exp(-a2*ite/itemax))) ;
 
    p1=pmax+(pmax-pmin)*exp(-(4*ite/itemax)^2);
    p2=pmin+(pmax-pmin)*exp(-(4*ite/itemax)^2);
    
%% ���´������ˮ�е��ٶ�
nu=floor((whiteSharks).*rand(1,whiteSharks))+1;

     for i=1:size(WSO_Positions,1)
           rmin=1; rmax=3.0;
          rr=rmin+rand()*(rmax-rmin);
          wr=abs(((2*rand()) - (1*rand()+rand()))/rr);       
          v(i,:)=  mu*v(i,:) +  wr *(wbest(nu(i),:)-WSO_Positions(i,:));
           %% or                

%          v(i,:)=  mu*(v(i,:)+ p1*(gbest-WSO_Positions(i,:))*rand+.... 
%                    + p2*(wbest(nu(i),:)-WSO_Positions(i,:))*rand);          
     end
 
 %% ���°���λ��
     for i=1:size(WSO_Positions,1)
       
        f =fmin+(fmax-fmin)/(fmax+fmin);
         
        a=sign(WSO_Positions(i,:)-ub)>0;
        b=sign(WSO_Positions(i,:)-lb)<0;
         
        wo=xor(a,b);

       % ��������ĸ�֪��������������λ����
            if rand<mv
                WSO_Positions(i,:)=  WSO_Positions(i,:).*(~wo) + (ub.*a+lb.*b); % random allocation  
            else   
                WSO_Positions(i,:) = WSO_Positions(i,:)+ v(i,:)/f;  % based on the wavy motion
            end
    end 
    
    %% ���´����λ��consides_sng��У
for i=1:size(WSO_Positions,1)
        for j=1:size(WSO_Positions,2)
            if rand<s_s      
                
             Dist=abs(rand*(gbest(j)-1*WSO_Positions(i,j)));
             
                if(i==1)
                    WSO_Positions(i,j)=gbest(j)+rand*Dist*sign(rand-0.5);
                else    
                    WSO_Pos(i,j)= gbest(j)+rand*Dist*sign(rand-0.5);
                    WSO_Positions(i,j)=(WSO_Pos(i,j)+WSO_Positions(i-1,j))/2*rand;
                end   
            end
         
        end       
end
%     

%% ����ȫ����Ѻ���ְλ 
    for i=1:whiteSharks 
      % ����߽�Υ��
           if WSO_Positions(i,:)>=lb & WSO_Positions(i,:)<=ub%         
            % �ҵ��ʺ϶�
              fit(i)=fobj(WSO_Positions(i,:));    
              
           % ������Ӧ��
            if fit(i)<fitness(i)
                 wbest(i,:) = WSO_Positions(i,:);% �������λ��
                 fitness(i)=fit(i);  % ������Ӧ��
            end
            
           %% �ҳ����λ��
            if (fitness(i)<fmin0)
               fmin0=fitness(i);
               gbest = wbest(index,:);% ����ȫ�����λ��
            end 
            
        end
    end

%% ��ȡ���
outmsg = ['Iteration# ', num2str(ite) , '  Fitness= ' , num2str(fmin0)];
  disp(outmsg);

 ccurve(ite)=fmin0; % ֱ������ite ������ҵ�ֵ

 if ite>2
        line([ite-1 ite], [ccurve(ite-1) ccurve(ite)],'Color','r'); 
        title({'������������'},'interpreter','latex','FontName','����','fontsize',10);
        xlabel('����');
        ylabel('����Ϊֹ�ó�������ֵ');
        drawnow 
 end 
  
end 
end