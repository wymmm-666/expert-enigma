%% White Shark Optimizer (WSO) source codes  
%
%  MATLAB R2019b
%

% 白鲨优化算法：一种针对全局优化问题的新型仿生元启发式算法

%____________________________________________________________________________________
%%   
clear 
close all
clc
%% % Prepare the problem
dim = 2;
ub = 50 * ones(1, 2);
lb = -50 * ones(1, 2);
fobj = @Objfun;

%% % CSA 参数
searchAgents = 20;
maxIter = 500;
  
              [fitness,gbest,ccurve]=WSO(searchAgents,maxIter,lb,ub,dim,fobj);
                     
              disp(['===> The optimal fitness value found by Standard Chameleon is ', num2str(fitness, 12)]);

%% 绘制收敛行为曲线
         
figure;  set(gcf,'color','w');

plot(ccurve,'LineWidth',1,'Color','r'); grid;
title({'收敛特性曲线'},'interpreter','latex','FontName','仿宋','fontsize',12);
xlabel('迭代','interpreter','latex','FontName','仿宋','fontsize',12)
ylabel('迄今为止得出的最优值','interpreter','latex','FontName','仿宋','fontsize',12); 

axis tight; grid on; box on 
     
h1=legend('WSO','location','northeast');
set(h1,'interpreter','Latex','FontName','Times','FontSize',12) 
ah=axes('position',get(gca,'position'),...
            'visible','off');