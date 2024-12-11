%% White Shark Optimizer (WSO)

% 初始化第一批搜索代理
function pos=initialization(whiteSharks,dim,ub_,lb_)

% 边界数
BoundNo= size(ub_,1); 

% 如果所有变量的边界相等并且用户为 ub_ 和 lb_ 输入一个数字

if BoundNo==1
    pos=rand(whiteSharks,dim).*(ub_-lb_)+lb_;
end

% 如果每个变量有不同的 ub_ 和 lb_

if BoundNo>1
    for i=1:dim
        ubi=ub_(i);
        lbi=lb_(i);
        pos(:,i)=rand(whiteSharks,1).*(ubi-lbi)+lbi;
    end
end