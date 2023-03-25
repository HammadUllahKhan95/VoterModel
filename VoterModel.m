clc;
clear;

L = 20;    
T = 100000000;        
allignment = ["horizontal" "vertical"];
prob = [0.08:0.01:0.15];
d = [0 6 10 14];

% Time loop
row = 0;
tab = [];
for z = 1:4
    for k = 1:8
        for rep = 1:10
            row = row + 1;
            if z == 1
                S = zeros(L,L) - 1;
                figure(1)
                imshow(S,'InitialMagnification','fit')
                title(['Time step: 0 out of ' num2str(T)])
                pause(1)
            elseif z == 2
                S = zeros(L,L) - 1;
                S(8:13,8:13) = 1;
                figure(1)
                imshow(S,'InitialMagnification','fit')
                title(['Time step: 0 out of ' num2str(T)])
                pause(1)
            elseif z == 3
                S = zeros(L,L) - 1;
                S(6:15,6:15) = 1;
                figure(1)
                imshow(S,'InitialMagnification','fit')
                title(['Time step: 0 out of ' num2str(T)])
                pause(1)
            elseif z == 4
                S = zeros(L,L) - 1;
                S(4:17,4:17) = 1;
                figure(1)
                imshow(S,'InitialMagnification','fit')
                title(['Time step: 0 out of ' num2str(T)])
                pause(1)
            end
            for t= 1:T
                if (sum(S(:) == 1)) >= 300
                    success = 1;
                    fp = 600*(prob(k))^6;
                    gd = d(z)^2;
                    X = fp*t + gd;
                    tab(row,1:5) = [prob(k),d(z),t-1,success, X]
                    break
                end
                % Randomly select a cell (an agent), say S(i,j) with i,j in {1,…,N}
                i = floor(rand*L)+1;
                j = floor(rand*L)+1;
                p = rand();
                allign = randsample(allignment, 1);
                if p >= prob(k)
                    if allign == 'horizontal'
                        if S(i,j)*S(i,mod(j+1-1,L)+1)==1 
                            % Modify agents above the panel
                            S(mod(i-1-1,L)+1,j)=S(i,j); 		
                            S(mod(i-1-1,L)+1,mod(j+1-1,L)+1)=S(i,j);	
                            % Modify agent to the left of the panel
                            S(i,mod(j-1-1,L)+1)=S(i,j); 	
                            % Modify agent to the right of the panel	
                            S(i,mod(j+2-1,L)+1)=S(i,j);	 
                            % Modify agents below the panel
                            S(mod(i+1-1,L)+1,j)=S(i,j); 
                            S(mod(i+1-1,L)+1,mod(j+1-1,L)+1)=S(i,j);
                        end
                        figure(1)
                        % Plot selected panel in gray
                        S1_old = S(i,j); S2_old = S(i,mod(j+1-1,L)+1);
                        S(i,j) = 0; S(i,mod(j+1-1,L)+1) = 0;
                        % Plot system state: 0 - black, 1 - white, (0,1) - gray
                        imshow((S+1)/2,'InitialMagnification','fit')
                            title(['Time step: ' num2str(t) ' out of ' num2str(T) ...
                            ', selected agent: (' num2str(i) ',' num2str(j) ')'])
                        %pause(1)
                        % Set panel state to original values
                        S(i,j) = S1_old; S(i,mod(j+1-1,L)+1) = S2_old;
                    else
                        if S(i,j)*S(mod(i+1-1,L)+1,j)==1 
                            % Modify agents above the panel
                            S(mod(i-1-1,L)+1,j)=S(i,j); 		
                            %S(mod(i-1-1,L)+1,mod(j+1-1,L)+1)=S(i,j);	
                            % Modify agent to the left of the panel
                            S(i,mod(j-1-1,L)+1)=S(i,j);
                            S(mod(i+1-1,L)+1,mod(j-1-1,L)+1)=S(i,j);	
                            % Modify agent to the right of the panel	
                            S(i,mod(j+1-1,L)+1)=S(i,j);
                            S(mod(i+1-1,L)+1,mod(j+1-1,L)+1)=S(i,j);	
                            % Modify agents below the panel
                            S(mod(i+2-1,L)+1,j)=S(i,j); 
                        end
                        figure(1)
                        % Plot selected panel in gray
                        S1_old = S(i,j); S2_old = S(mod(i+1-1,L)+1,j);
                        S(i,j) = 0; S(mod(i+1-1,L)+1,j) = 0;
                        % Plot system state: 0 - black, 1 - white, (0,1) - gray
                        imshow((S+1)/2,'InitialMagnification','fit')
                            title(['Time step: ' num2str(t) ' out of ' num2str(T) ...
                            ', selected agent: (' num2str(i) ',' num2str(j) ')'])
                        %pause(1)
                        % Set panel state to original values
                        S(i,j) = S1_old; S(mod(i+1-1,L)+1,j) = S2_old;
                    end
                else
                    if S(i,j)==-1
                        S(i,j) = 1;
                        figure(1)
                        % Plot selected panel in gray
                        S1_old = S(i,j);
                        S(i,j) = 0;
                        % Plot system state: 0 - black, 1 - white, (0,1) - gray
                        imshow((S+1)/2,'InitialMagnification','fit')
                            title(['Time step: ' num2str(t) ' out of ' num2str(T) ...
                            ', selected agent: (' num2str(i) ',' num2str(j) ')'])
                        %pause(1)
                        % Set panel state to original values
                        S(i,j) = S1_old;
                    end
                end
                if t == T
                    success = 0;
                    fp = 600*(prob(k))^6;
                    gd = d(z)^2;
                    X = fp*t + gd;
                    tab(row,1:5) = [prob(k),d(z),t,success,X]
                    break
                end 
            end
        end
    end
end

column_names = {'p','d','t','success','X'}; 
TABLE = array2table(tab, 'VariableNames', column_names); 
writetable(TABLE,'results.csv');
