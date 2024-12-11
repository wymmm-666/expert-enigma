%% White Shark Optimizer (WSO)

% ��ʼ����һ����������
function pos=initialization(whiteSharks,dim,ub_,lb_)

% �߽���
BoundNo= size(ub_,1); 

% ������б����ı߽���Ȳ����û�Ϊ ub_ �� lb_ ����һ������

if BoundNo==1
    pos=rand(whiteSharks,dim).*(ub_-lb_)+lb_;
end

% ���ÿ�������в�ͬ�� ub_ �� lb_

if BoundNo>1
    for i=1:dim
        ubi=ub_(i);
        lbi=lb_(i);
        pos(:,i)=rand(whiteSharks,1).*(ubi-lbi)+lbi;
    end
end