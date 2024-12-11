
%% White Shark Optimizer (WSO) source codes  
%
%  MATLAB R2019b
%

% 白鲨优化算法：一种针对全局优化问题的新型仿生元启发式算法


function [fmin0,gbest,ccurve]=WSO(whiteSharks,itemax,lb,ub,dim,fobj)
 
%% 收敛曲线
ccurve=zeros(1,itemax);

%%% 显示收敛曲线
    figure (1);
    set(gcf,'color','w');
    hold on
    xlabel('Iteration','interpreter','latex','FontName','Times','fontsize',10)
    ylabel('fitness value','interpreter','latex','FontName','Times','fontsize',10); 
    grid;

%% 启动 WSO 算法
% 初始解决方案的生成
WSO_Positions=initialization(whiteSharks,dim,ub,lb);% Initial population

%初始速度
v=0.0*WSO_Positions; 

%% 评估初始种群的适应度
fit=zeros(whiteSharks,1);

for i=1:whiteSharks
     fit(i,1)=fobj(WSO_Positions(i,:));
end

%% 初始化WSO的参数
fitness=fit; % WSO 随机位置的初始适应度
 
[fmin0,index]=min(fit);

wbest = WSO_Positions;% 最佳位置初始化
gbest = WSO_Positions(index,:);% 初始全局位置

%% WSO 参数
    fmax=0.75; % 波浪运动的最大频率
    fmin=0.07; % 波浪运动的最小频率
    tau=4.11;  
       
    mu=2/abs(2-tau-sqrt(tau^2-4*tau));

    pmin=0.5;
    pmax=1.5;
    a0=6.250;  
    a1=100;
    a2=0.0005;
 %% 开始WSO的迭代过程
for ite=1:itemax

    mv=1/(a0+exp((itemax/2.0-ite)/a1)); 
    s_s=abs((1-exp(-a2*ite/itemax))) ;
 
    p1=pmax+(pmax-pmin)*exp(-(4*ite/itemax)^2);
    p2=pmin+(pmax-pmin)*exp(-(4*ite/itemax)^2);
    
%% 更新大白鲨在水中的速度
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
 
 %% 更新白鲨位置
     for i=1:size(WSO_Positions,1)
       
        f =fmin+(fmax-fmin)/(fmax+fmin);
         
        a=sign(WSO_Positions(i,:)-ub)>0;
        b=sign(WSO_Positions(i,:)-lb)<0;
         
        wo=xor(a,b);

       % 根据猎物的感知（声音、波）定位猎物
            if rand<mv
                WSO_Positions(i,:)=  WSO_Positions(i,:).*(~wo) + (ub.*a+lb.*b); % random allocation  
            else   
                WSO_Positions(i,:) = WSO_Positions(i,:)+ v(i,:)/f;  % based on the wavy motion
            end
    end 
    
    %% 更新大白鲨位置consides_sng渔校
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

%% 更新全球、最佳和新职位 
    for i=1:whiteSharks 
      % 处理边界违规
           if WSO_Positions(i,:)>=lb & WSO_Positions(i,:)<=ub%         
            % 找到适合度
              fit(i)=fobj(WSO_Positions(i,:));    
              
           % 评估适应度
            if fit(i)<fitness(i)
                 wbest(i,:) = WSO_Positions(i,:);% 更新最佳位置
                 fitness(i)=fit(i);  % 更新适应度
            end
            
           %% 找出最佳位置
            if (fitness(i)<fmin0)
               fmin0=fitness(i);
               gbest = wbest(index,:);% 更新全球最佳位置
            end 
            
        end
    end

%% 获取结果
outmsg = ['Iteration# ', num2str(ite) , '  Fitness= ' , num2str(fmin0)];
  disp(outmsg);

 ccurve(ite)=fmin0; % 直到迭代ite 的最佳找到值

 if ite>2
        line([ite-1 ite], [ccurve(ite-1) ccurve(ite)],'Color','r'); 
        title({'收敛特性曲线'},'interpreter','latex','FontName','仿宋','fontsize',10);
        xlabel('迭代');
        ylabel('迄今为止得出的最优值');
        drawnow 
 end 
  
end 
end