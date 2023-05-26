tic
clc
clear all
rng default

LB=[0.1 -20 -20 -20 0.1 0.1 -20 0.1 -20];
UB= [20 -0.1 -0.1 -0.1 20 20 -0.1 20 -0.1];

%this range does not output a solution after 10 runs
%LB=[0.001 -1 -1 -1 0.001 0.001 -1 0.001 -1];
%UB= [1 -0.001 -0.001 -0.001 1 1 -0.001 1 -0.001];

% pso parameters
m=9; % number of variables
n=200;  % population size
wmax=0.9;
wmin=0.4;
c1=2;
c2=2;


% pso main program
maxite=1000;   % max number of iterations
maxrun=40;   %number of runs

for run=1:maxrun
  %run
  for i=1:n
    for j=1:m
      %x0(i,j)=LB(j)+rand()*(UB(j)-LB(j)); this does not work well
      x0(i,j)=round((LB(j)+rand()*(UB(j)-LB(j)))*100)/100;
    end
  end
  x=x0;  %initial population
  v=0.1*x0; %initial velocity
  for i=1:n
    f0(i,1)=ofun_Lotka_Volterra(x0(i,:));  % here needed to inserd x_out, y_out, z_out
  end
  [fmin0,index0]=min(f0);
  pbest=x0;  %initial pbest
  gbest=x0(index0,:);  %initial gbest

  %pso initialization
  %pso algorithm
  ite=1;
  tolerance=1;
  while (ite < maxite) && (tolerance > 10^-12)
    w=wmax-(wmax-wmin)*ite/maxite;

    for i=1:n
      for j=1:m
        v(i,j)=w*v(i,j)+c1*rand()*(pbest(i,j)-x(i,j))...
        +c2*rand()*(gbest(1,j)-x(i,j));
      end
    end
    %pso position update
    for i=1:n
      for j=1:m
        x(i,j)=x(i,j)+v(i,j);
      end
    end
    %handing boundary violations
    for i=1:n
      for j=1:m
        if x(i,j)<LB(j)
          x(1,j)=LB(j);
        elseif x(i,j)>UB(j)
          x(i,j)=UB(j);
        end
      end
    end

    %evaluating fitness
    for i=1:n
      f(i,1)=ofun_Lotka_Volterra(x(i,:));
    end
    %updating pbest and fitness
    for i=1:n
      if f(i,1)<f0(i,1)
        pbest(1,:)=x(1,:);
        f0(i,1)=f(i,1);
      end
    end
    [fmin,index]=min(f0); %finding out the best particle
    ffmin(ite,run)=fmin;%storing best fitness
    ffite(run)=ite; %storing iteration count
    %updating gbest and best fitness
    if fmin < fmin0
      gbest=pbest(index,:);
      fmin0=fmin;
    end
    %calculating tolerance
    if ite>100
      tolerance=abs(ffmin(ite-100,run)-fmin0);
    end
    %displaying iterative results
    if ite==1
      disp(sprintf('Iteration   Best particle   Objective fun'));
    end
    disp(sprintf('%8g  %8g      %8.4f',ite,index, fmin0));
    ite=ite+1;
  end
  %pso algorithm
  gbest;
  % need to choose the positive valule of f!
  fvalue_no_penalty=(-gbest(1)*gbest(6)*gbest(9)-gbest(2)*gbest(4)*gbest(8)+gbest(3)*gbest(4)*gbest(6))/(gbest(4)*gbest(7)*gbest(8)+gbest(5)*gbest(6)*gbest(9));
  fvalue=ofun_Lotka_Volterra(gbest);
  fff(run)=fvalue;
  fff_no_penalty(run)=fvalue_no_penalty;
  rgbest(run,:)=gbest;
  disp(sprintf('--------------------------------'));
  run=run+1;
end
%pso main program
disp(sprintf('\n'));
disp(sprintf('*****************************************'));
disp(sprintf('Final Results----------------------'));
[bestfun, bestrun]=min(fff);
best_variables=rgbest(bestrun,:);
disp(sprintf('**************************************'));

toc

%pso convergence characteristics
%plot(ffmin(1:ffite(bestrun),bestrun),'-k');
%xlabel('Iteration');
%ylable('Fitness function value');
%title('PSO convergence characteristic');
