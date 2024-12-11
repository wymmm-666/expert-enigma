%% White Shark Optimizer (WSO) source codes  
%
%  MATLAB R2019b
%

% �����Ż��㷨��һ�����ȫ���Ż���������ͷ���Ԫ����ʽ�㷨

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

%% % CSA ����
searchAgents = 20;
maxIter = 500;
  
              [fitness,gbest,ccurve]=WSO(searchAgents,maxIter,lb,ub,dim,fobj);
                     
              disp(['===> The optimal fitness value found by Standard Chameleon is ', num2str(fitness, 12)]);

%% ����������Ϊ����
         
figure;  set(gcf,'color','w');

plot(ccurve,'LineWidth',1,'Color','r'); grid;
title({'������������'},'interpreter','latex','FontName','����','fontsize',12);
xlabel('����','interpreter','latex','FontName','����','fontsize',12)
ylabel('����Ϊֹ�ó�������ֵ','interpreter','latex','FontName','����','fontsize',12); 

axis tight; grid on; box on 
     
h1=legend('WSO','location','northeast');
set(h1,'interpreter','Latex','FontName','Times','FontSize',12) 
ah=axes('position',get(gca,'position'),...
            'visible','off');