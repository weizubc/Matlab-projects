% 1 set parameters

n=90; % # of agents
T=1000; % times of simulation
computation_count(1:T)=0;  % number of times type 1 agent meet with any one carrying goods 3
computation_value(1:T)=0;  % number of times type 1 agent accept goods 3
pimt=0; % imitation probability
p=0.05; %experimental probability
n_choose=5*n/9; % used to control the proportion of Type 2 agents

% 3 types of agents producing different goods
for i=1:n/3
    production(1,i)=2;
end
for i=n/3+1:n_choose
    production(1,i)=3;
end
for i=n_choose+1:n
    production(1,i)=1;
end

% 3 types of agents with different favorites
for i=1:n/3
    favorite(1,i)=1;
end
for i=n/3+1:n_choose
    favorite(1,i)=2;
end
for i=n_choose+1:n
    favorite(1,i)=3;
end

s=[0.1 0.25 0.3]; % storage cost with goods 1, 2 and 3
u=[1.5 1.5 1]; % utility of consumption of goods 1,2 and 3
d=[0.1 0.1 0.1]; % disutility of production of goods 1,2 and 3     
beta=0.9 ; % discount factor

% 2 set initial state

a=[1 -1 -1;-1 1 -1;-1 -1 1];

% trade classifier

for i=1:n
    for j=1:3
        for c=1:3
            agent(i).Tclassifier(3*c-3+j).string(1:3)=a(j,:);
            agent(i).Tclassifier(3*c-3+j).string(4:6)=a(c,:);
            agent(i).Tclassifier(3*c-3+j).string(7)=1;
            r=normrnd(1,1);
            r=0;
            agent(i).Tclassifier(3*c-3+j).strength(1:T+1)=r;
            agent(i).Tclassifier(3*c-3+j).count(1:T+1)=1;

            agent(i).Tclassifier(22-3*c-j).string(1:3)=a(j,:);
            agent(i).Tclassifier(22-3*c-j).string(4:6)=a(c,:);
            agent(i).Tclassifier(22-3*c-j).string(7)=0;
            r=normrnd(1,1);
            r=0;
            agent(i).Tclassifier(22-3*c-j).strength(1:T+1)=r;
            agent(i).Tclassifier(22-3*c-j).count(1:T+1)=1;
        end
    end
end


% consumption classifier

for i=1:n
    for j=1:3
        agent(i).Cclassifier(j).string(1:3)=a(j,:);
        agent(i).Cclassifier(j).string(4)=1;
        r=normrnd(1,1);
        r=0;
        agent(i).Cclassifier(j).strength(1:T+1)=r;
        agent(i).Cclassifier(j).count(1:T+1)=1;

        agent(i).Cclassifier(7-j).string(1:3)=a(j,:);
        agent(i).Cclassifier(7-j).string(4)=0;
        r=normrnd(1,1);
        r=0;
        agent(i).Cclassifier(7-j).strength(1:T+1)=r;
        agent(i).Cclassifier(7-j).count(1:T+1)=1;
    end
end

% initial endowment

for i=1:n/3
    agent(i).goods(1:T)=2;
end
for i=n/3+1:n_choose
    agent(i).goods(1:T)=3;
end
for i=n_choose+1:n
    agent(i).goods(1:T)=1;
end

goods(1).type_1(1:T)=0;
goods(2).type_1(1:T)=0;
goods(3).type_1(1:T)=0;

goods(1).type_2(1:T)=0;
goods(2).type_2(1:T)=0;
goods(3).type_2(1:T)=0;

goods(1).type_3(1:T)=0;
goods(2).type_3(1:T)=0;
goods(3).type_3(1:T)=0;

for t=1:T   % outer loop

    % record goods held by each type in each time period
    for i=1:n
        if i<=n/3
            if agent(i).goods(t)==1
                goods(1).type_1(t)=goods(1).type_1(t)+1;
            end
            if agent(i).goods(t)==2
                goods(2).type_1(t)=goods(2).type_1(t)+1;
            end
            if agent(i).goods(t)==3
                goods(3).type_1(t)=goods(3).type_1(t)+1;
            end

        else
            if i<=n_choose
                if agent(i).goods(t)==1
                    goods(1).type_2(t)=goods(1).type_2(t)+1;
                end
                if agent(i).goods(t)==2
                    goods(2).type_2(t)=goods(2).type_2(t)+1;
                end
                if agent(i).goods(t)==3
                    goods(3).type_2(t)=goods(3).type_2(t)+1;
                end
            else

                if agent(i).goods(t)==1
                    goods(1).type_3(t)=goods(1).type_3(t)+1;
                end
                if agent(i).goods(t)==2
                    goods(2).type_3(t)=goods(2).type_3(t)+1;
                end
                if agent(i).goods(t)==3
                    goods(3).type_3(t)=goods(3).type_3(t)+1;
                end
            end
        end
    end


    % 3 matching agents randomly

    pairs=randperm(n);

    for i=1:2:(n-1)

        agent_1=pairs(i);
        agent_2=pairs(i+1);


        % 4 trade

        % for agent_1
        if agent(agent_1).goods(1,t)==1
            z(1:3)=[1 -1 -1];
        else
            if agent(agent_1).goods(1,t)==2
                z(1:3)=[-1 1 -1];
            else
                z(1:3)=[-1 -1 1];
            end
        end

        if agent(agent_2).goods(1,t)==1
            z(4:6)=[1 -1 -1];
        else
            if agent(agent_2).goods(1,t)==2
                z(4:6)=[-1 1 -1];
            else
                z(4:6)=[-1 -1 1];
            end
        end

        count=0;

        for j=1:18
            m=1;
            x=agent(agent_1).Tclassifier(j).string(1:6);
            while( x(1,m)*z(1,m)~=-1)
                m=m+1;
                if m==7
                    break
                end
            end

            if m==7
                count=count+1;
                agent(agent_1).M_Tclassifier(count,1:7)=agent(agent_1).Tclassifier(j).string;
                agent(agent_1).M_Tclassifier(count,8)=agent(agent_1).Tclassifier(j).strength(1,t);
                agent(agent_1).M_Tclassifier(count,9)=j;
            end
        end

        sum_count=0;
        sum_strength=0;

        if favorite(agent_1)==1
            v=[1 n/3];
        else
            if favorite(agent_1)==2
                v=[n/3+1 n_choose];
            else
                v=[n_choose+1 n];
            end
        end

        if rand<pimt

            if rand<0.5
                imitation=agent(agent_1).M_Tclassifier(count,9);
                for j=v(1):v(2)
                    sum_count=sum_count+agent(j).Tclassifier(imitation).count(t);
                    sum_strength=sum_strength+agent(j).Tclassifier(imitation).count(t)*agent(j).Tclassifier(imitation).strength(t);
                end

                agent(agent_1).Tclassifier(imitation).strength(t)=sum_strength/sum_count;
                agent(agent_1).M_Tclassifier(count,8)=sum_strength/sum_count;

            else
                imitation=agent(agent_1).M_Tclassifier(1,9);
                for j=v(1):v(2)
                    sum_count=sum_count+agent(j).Tclassifier(imitation).count(t);
                    sum_strength=sum_strength+agent(j).Tclassifier(imitation).count(t)*agent(j).Tclassifier(imitation).strength(t);
                end
                agent(agent_1).Tclassifier(imitation).strength(t)=sum_strength/sum_count;
                agent(agent_1).M_Tclassifier(1,8)=sum_strength/sum_count;
            end
        end

        if rand<p
            if rand<0.5
                lamda_1=agent(agent_1).M_Tclassifier(count,7);
                agent(agent_1).T_number(t)=agent(agent_1).M_Tclassifier(count,9);
            else
                lamda_1=agent(agent_1).M_Tclassifier(1,7);
                agent(agent_1).T_number(t)=agent(agent_1).M_Tclassifier(1,9);
            end

        else
            rank=sortrows(agent(agent_1).M_Tclassifier,8);
            lamda_1=rank(count,7);
            agent(agent_1).T_number(t)=rank(count,9);

        end


        % update C-classifier's strength
        if t~=1
            agent(agent_1).Cclassifier(agent(agent_1).C_number(t-1)).strength(t:T+1)=agent(agent_1).Cclassifier(agent(agent_1).C_number(t-1)).strength(t-1)+...
                [beta*agent(agent_1).Tclassifier(agent(agent_1).T_number(t)).strength(t)-agent(agent_1).Cclassifier(agent(agent_1).C_number(t-1)).strength(t-1)+...
                agent(agent_1).utility-s(agent(agent_1).goods(t))]/(1+agent(agent_1).Cclassifier(agent(agent_1).C_number(t-1)).count(t-1));
            agent(agent_1).Cclassifier(agent(agent_1).C_number(t-1)).count(t:T+1)=agent(agent_1).Cclassifier(agent(agent_1).C_number(t-1)).count(1,t-1)+1;
        end


        % for agent_2
        if agent(agent_2).goods(1,t)==1
            z(1:3)=[1 -1 -1];
        else
            if agent(agent_2).goods(1,t)==2
                z(1:3)=[-1 1 -1];
            else
                z(1:3)=[-1 -1 1];
            end
        end

        if agent(agent_1).goods(1,t)==1
            z(4:6)=[1 -1 -1];
        else
            if agent(agent_1).goods(1,t)==2
                z(4:6)=[-1 1 -1];
            else
                z(4:6)=[-1 -1 1];
            end
        end

        count=0;

        for j=1:18
            m=1;
            x=agent(agent_2).Tclassifier(j).string(1:6);
            while( x(m)*z(m)~=-1)
                m=m+1;
                if m==7
                    break
                end
            end

            if m==7
                count=count+1;
                agent(agent_2).M_Tclassifier(count,1:7)=agent(agent_2).Tclassifier(j).string;
                agent(agent_2).M_Tclassifier(count,8)=agent(agent_2).Tclassifier(j).strength(1,t);
                agent(agent_2).M_Tclassifier(count,9)=j;
            end
        end

        sum_count=0;
        sum_strength=0;

        if favorite(agent_2)==1
            v=[1 n/3];
        else
            if favorite(agent_2)==2
                v=[n/3+1 n_choose];
            else
                v=[n_choose+1 n];
            end
        end

        if rand<pimt

            if rand<0.5
                imitation=agent(agent_2).M_Tclassifier(count,9);
                for j=v(1):v(2)
                    sum_count=sum_count+agent(j).Tclassifier(imitation).count(t);
                    sum_strength=sum_strength+agent(j).Tclassifier(imitation).count(t)*agent(j).Tclassifier(imitation).strength(t);
                end;

                agent(agent_2).Tclassifier(imitation).strength(t)=sum_strength/sum_count;
                agent(agent_2).M_Tclassifier(count,8)=sum_strength/sum_count;

            else
                imitation=agent(agent_2).M_Tclassifier(1,9);
                for j=v(1):v(2)
                    sum_count=sum_count+agent(j).Tclassifier(imitation).count(t);
                    sum_strength=sum_strength+agent(j).Tclassifier(imitation).count(t)*agent(j).Tclassifier(imitation).strength(t);
                end
                agent(agent_2).Tclassifier(imitation).strength(t)=sum_strength/sum_count;
                agent(agent_2).M_Tclassifier(1,8)=sum_strength/sum_count;
            end
        end

        if rand<p
            if rand<0.5
                lamda_2=agent(agent_2).M_Tclassifier(count,7);
                agent(agent_2).T_number(t)=agent(agent_2).M_Tclassifier(count,9);
            else
                lamda_2=agent(agent_2).M_Tclassifier(1,7);
                agent(agent_2).T_number(t)=agent(agent_2).M_Tclassifier(1,9);
            end

        else
            rank=sortrows(agent(agent_2).M_Tclassifier,8);
            lamda_2=rank(count,7);
            agent(agent_2).T_number(t)=rank(count,9);

        end



        % update C-classifier's strength

        if t~=1
            agent(agent_2).Cclassifier(agent(agent_2).C_number(t-1)).strength(t:T+1)=agent(agent_2).Cclassifier(agent(agent_2).C_number(t-1)).strength(t-1)+...
                [beta*agent(agent_2).Tclassifier(agent(agent_2).T_number(t)).strength(t)-agent(agent_2).Cclassifier(agent(agent_2).C_number(t-1)).strength(t-1)+...
                agent(agent_2).utility-s(agent(agent_2).goods(t))]/(1+agent(agent_2).Cclassifier(agent(agent_2).C_number(t-1)).count(t-1));
            agent(agent_2).Cclassifier(agent(agent_2).C_number(t-1)).count(t:T+1)=agent(agent_2).Cclassifier(agent(agent_2).C_number(t-1)).count(1,t-1)+1;
        end


        agent(agent_1).goods_prec=(1-lamda_1*lamda_2)*agent(agent_1).goods(t)+lamda_1*lamda_2*agent(agent_2).goods(t);
        agent(agent_2).goods_prec=(1-lamda_1*lamda_2)*agent(agent_2).goods(1,t)+lamda_1*lamda_2*agent(agent_1).goods(1,t);


        % record decision

        match(agent_1).Tstring(t,:)=[agent(agent_1).goods(t),agent(agent_2).goods(t),lamda_1,lamda_2];
        match(agent_2).Tstring(t,:)=[agent(agent_2).goods(t),agent(agent_1).goods(t),lamda_2,lamda_1];
        if favorite(agent_1)==1 &&  agent(agent_2).goods(t)==3 && agent(agent_1).goods(t)==2
            computation_value(t)=computation_value(t)+lamda_1;
            computation_count(t)=computation_count(t)+1;
        end

        if favorite(agent_2)==1 &&  agent(agent_1).goods(t)==3 && agent(agent_2).goods(t)==2
            computation_value(t)=computation_value(t)+lamda_2;
            computation_count(t)=computation_count(t)+1;
        end
        



        % 5 Consumption

        % for agent_1

        if agent(agent_1).goods_prec==1
            y(1:3)=[1 -1 -1];
        else
            if agent(agent_1).goods_prec==2
                y(1:3)=[-1 1 -1];
            else
                y(1:3)=[-1 -1 1];
            end
        end

        count=0;

        for j=1:6
            m=1;
            x=agent(agent_1).Cclassifier(j).string(1:3);
            while( x(m)*y(m)~=-1)
                m=m+1;
                if m==4
                    break
                end
            end

            if m==4
                count=count+1;
                agent(agent_1).M_Cclassifier(count,1:4)=agent(agent_1).Cclassifier(j).string;
                agent(agent_1).M_Cclassifier(count,5)=agent(agent_1).Cclassifier(j).strength(1,t);
                agent(agent_1).M_Cclassifier(count,6)=j;
            end
        end


        sum_count=0;
        sum_strength=0;

        if favorite(agent_1)==1
            v=[1 n/3];
        else
            if favorite(agent_1)==2
                v=[n/3+1 n_choose];
            else
                v=[n_choose+1 n];
            end
        end

        if rand<pimt

            if rand<0.5
                imitation=agent(agent_1).M_Cclassifier(count,6);
                for j=v(1):v(2)
                    sum_count=sum_count+agent(j).Cclassifier(imitation).count(t);
                    sum_strength=sum_strength+agent(j).Cclassifier(imitation).count(t)*agent(j).Cclassifier(imitation).strength(t);
                end

                agent(agent_1).Cclassifier(imitation).strength(t)=sum_strength/sum_count;
                agent(agent_1).M_Cclassifier(count,5)=sum_strength/sum_count;
                
            else
                imitation=agent(agent_1).M_Cclassifier(1,6);

                for j=v(1):v(2)
                    sum_count=sum_count+agent(j).Cclassifier(imitation).count(t);
                    sum_strength=sum_strength+agent(j).Cclassifier(imitation).count(t)*agent(j).Cclassifier(imitation).strength(t);

                end
                agent(agent_1).Cclassifier(imitation).strength(t)=sum_strength/sum_count;
                agent(agent_1).M_Cclassifier(1,8)=sum_strength/sum_count;
            end

        end

        if rand<p
            if rand<0.5
                gamma_1=agent(agent_1).M_Cclassifier(count,4);
                agent(agent_1).C_number(t)=agent(agent_1).M_Cclassifier(count,6);
            else
                gamma_1=agent(agent_1).M_Cclassifier(1,4);
                agent(agent_1).C_number(t)=agent(agent_1).M_Cclassifier(1,6);
            end

        else
            rank=sortrows(agent(agent_1).M_Cclassifier,5);
            gamma_1=rank(count,4);
            agent(agent_1).C_number(t)=rank(count,6);

        end



        % for agent_2

        if agent(agent_2).goods_prec==1
            y(1:3)=[1 -1 -1];
        else
            if agent(agent_2).goods_prec==2
                y(1:3)=[-1 1 -1];
            else
                y(1:3)=[-1 -1 1];
            end
        end

        count=0;

        for j=1:6
            m=1;
            x=agent(agent_2).Cclassifier(j).string(1:3);

            while( x(m)*y(m)~=-1 )
                m=m+1;
                if m==4
                    break
                end
            end

            if m==4
                count=count+1;
                agent(agent_2).M_Cclassifier(count,1:4)=agent(agent_2).Cclassifier(j).string;
                agent(agent_2).M_Cclassifier(count,5)=agent(agent_2).Cclassifier(j).strength(1,t);
                agent(agent_2).M_Cclassifier(count,6)=j;
            end
        end

        sum_count=0;
        sum_strength=0;

        if favorite(agent_2)==1
            v=[1 n/3];
        else
            if favorite(agent_2)==2
                v=[n/3+1 n_choose];
            else
                v=[n_choose+1 n];
            end
        end

        if rand<pimt

            if rand<0.5
                imitation=agent(agent_2).M_Cclassifier(count,6);
                for j=v(1):v(2)
                    sum_count=sum_count+agent(j).Cclassifier(imitation).count(t);
                    sum_strength=sum_strength+agent(j).Cclassifier(imitation).count(t)*agent(j).Cclassifier(imitation).strength(t);
                end

                agent(agent_2).Cclassifier(imitation).strength(t)=sum_strength/sum_count;
                agent(agent_2).M_Cclassifier(count,8)=sum_strength/sum_count;

            else
                imitation=agent(agent_2).M_Cclassifier(1,6);

                for j=v(1):v(2)
                    sum_count=sum_count+agent(j).Cclassifier(imitation).count(t);
                    sum_strength=sum_strength+agent(j).Cclassifier(imitation).count(t)*agent(j).Cclassifier(imitation).strength(t);

                end
                agent(agent_2).Cclassifier(imitation).strength(t)=sum_strength/sum_count;
                agent(agent_2).M_Cclassifier(1,5)=sum_strength/sum_count;
            end

        end

        if rand<p
            if rand<0.5
                gamma_2=agent(agent_2).M_Cclassifier(count,4);
                agent(agent_2).C_number(t)=agent(agent_2).M_Cclassifier(count,6);
            else
                gamma_2=agent(agent_2).M_Cclassifier(1,4);
                agent(agent_2).C_number(t)=agent(agent_2).M_Cclassifier(1,6);
            end

        else
            rank=sortrows(agent(agent_2).M_Cclassifier,5);
            gamma_2=rank(count,4);
            agent(agent_2).C_number(t)=rank(count,6);

        end


        agent(agent_1).goods(t+1)=gamma_1*production(agent_1)+(1-gamma_1)*agent(agent_1).goods_prec;

        if gamma_1==1

            if favorite(agent_1)==agent(agent_1).goods_prec
                agent(agent_1).utility=u(favorite(agent_1))-d(production(agent_1));
            else
                agent(agent_1).utility=-d(production(agent_1));
            end
        else
            agent(agent_1).utility=0;
        end


        agent(agent_2).goods(t+1)=gamma_2*production(agent_2)+(1-gamma_2)*agent(agent_2).goods_prec;

        if gamma_2==1
            if favorite(agent_2)==agent(agent_2).goods_prec
                agent(agent_2).utility=u(favorite(agent_2))-d(production(agent_2));
            else
                agent(agent_2).utility=-d(production(agent_2));
            end
        else
            agent(agent_2).utility=0;
        end


        % update T-classifier's strength
        
        
        agent(agent_1).Tclassifier(agent(agent_1).T_number(t)).strength(t+1:T+1)=agent(agent_1).Tclassifier(agent(agent_1).T_number(t)).strength(t)+...
            [-agent(agent_1).Tclassifier(agent(agent_1).T_number(t)).strength(t)+agent(agent_1).Cclassifier(agent(agent_1).C_number(t)).strength(t)]/...
            (1+agent(agent_1).Tclassifier(agent(agent_1).T_number(t)).count(t));

        agent(agent_1).Tclassifier(agent(agent_1).T_number(t)).count(t+1:T+1)=agent(agent_1).Tclassifier(agent(agent_1).T_number(t)).count(1,t)+1;



        agent(agent_2).Tclassifier(agent(agent_2).T_number(t)).strength(t+1:T+1)=agent(agent_2).Tclassifier(agent(agent_2).T_number(t)).strength(t)+...
            [-agent(agent_2).Tclassifier(agent(agent_2).T_number(t)).strength(t)+agent(agent_2).Cclassifier(agent(agent_2).C_number(t)).strength(t)]/...
            (1+agent(agent_2).Tclassifier(agent(agent_2).T_number(t)).count(t));

        agent(agent_2).Tclassifier(agent(agent_2).T_number(t)).count(t+1:T+1)=agent(agent_2).Tclassifier(agent(agent_2).T_number(t)).count(1,t)+1;


        match(agent_1).Cstring(t,:)=[agent(agent_1).goods_prec,gamma_1];
        match(agent_2).Cstring(t,:)=[agent(agent_2).goods_prec,gamma_2];

    end
    
   
    if computation_count(t)==0
        ratio(t)=NaN;
    else
     ratio(t)=computation_value(t)/computation_count(t);
    end
    
end


figure;
subplot(3,1,1);
plot(goods(1).type_1,'b');
hold on;
plot(goods(2).type_1,'r');
hold on;
plot(goods(3).type_1,'g');
legend('Good_1','Good_2','Good_3',2)
title('Type 1 distribution over goods')
hold off;


subplot(3,1,2);
plot(goods(1).type_2,'b');
hold on;
plot(goods(2).type_2,'r');
hold on;
plot(goods(3).type_2,'g');
legend('Good_1','Good_2','Good_3',2)
title('Type 2 distribution over goods')
hold off;


subplot(3,1,3);
plot(goods(1).type_3,'b');
hold on;
plot(goods(2).type_3,'r');
hold on;
plot(goods(3).type_3,'g');
legend('Good_1','Good_2','Good_3',2)
title('Type 3 distribution over goods')
hold off;


figure;
plot(ratio);
title('proportion of Type 1 agents who accept Good 3 as a medium of exchange')
hold off;



