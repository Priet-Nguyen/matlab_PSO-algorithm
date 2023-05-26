tic
clc
clear all
rng default

LB=[0 0 0];
UB= [10 10 10];

## pso parameters
m=3; # number of variables
n=100;  # population size
wmax=0.9;
wmin=0.4;
c1=2;
c2=2;


# pso main program
maxite=1000;   # max number of iterations
maxrun=10;   #number of runs

for run=1:maxrun
  #run
  for i=1:n
    for j=1:m
      x0(i,j)=round((LB(j)+rand()*(UB(j)-LB(j)))*100)/100;
      #x0(i,j)=LB(j)+rand()*(UB(j)-LB(j)); this does not work well
    endfor
  endfor
  x=x0;  #initial population
  v=0.1*x0; #initial velocity
  for i=1:n
    f0(i,1)=ofun(x0(i,:));
  endfor
  [fmin0,index0]=min(f0);
  pbest=x0;  #initial pbest
  gbest=x0(index0,:);  #initial gbest

  #pso initialization
  #pso algorithm
  ite=1;
  tolerance=1;
  while (ite < maxite) && (tolerance > 10^-12)
    w=wmax-(wmax-wmin)*ite/maxite;

    for i=1:n
      for j=1:m
        v(i,j)=w*v(i,j)+c1*rand()*(pbest(i,j)-x(i,j))...
        +c2*rand()*(gbest(1,j)-x(i,j));
      endfor
    endfor
    #pso position update
    for i=1:n
      for j=1:m
        x(i,j)=x(i,j)+v(i,j);
      endfor
    endfor
    #handing boundary violations
    for i=1:n
      for j=1:m
        if x(i,j)<LB(j)
          x(1,j)=LB(j);
        elseif x(i,j)>UB(j)
          x(i,j)=UB(j);
        endif
      endfor
    endfor

    #evaluating fitness
    for i=1:n
      f(i,1)=ofun(x(i,:));
    endfor
    #updating pbest and fitness
    for i=1:n
      if f(i,1)<f0(i,1)
        pbest(1,:)=x(1,:);
        f0(i,1)=f(i,1);
      endif
    endfor
    [fmin,index]=min(f0); #finding out the best particle
    ffmin(ite,run)=fmin;#storing best fitness
    ffite(run)=ite; #storing iteration count
    #updating gbest and best fitness
    if fmin < fmin0
      gbest=pbest(index,:);
      fmin0=fmin;
    endif
    #calculating tolerance
    if ite>100
      tolerance=abs(ffmin(ite-100,run)-fmin0);
    endif
    #displaying iterative results
    if ite==1
      disp(sprintf('Iteration   Best particle   Objective fun'));
    endif
    disp(sprintf('%8g  %8g      %8.4f',ite,index, fmin0));
    ite=ite+1;
  endwhile
  #pso algorithm
  gbest;
  fvalue=10*(gbest(1)-1)^2+20*(gbest(2)-2)^2+30*(gbest(3)-3)^2;
  fff(run)=fvalue;
  rgbest(run,:)=gbest;
  disp(sprintf('--------------------------------'));
  run=run+1;
endfor
#pso main program
disp(sprintf('\n'));
disp(sprintf('*****************************************'));
disp(sprintf('Final Results----------------------'));
[bestfun, bestrun]=min(fff);
best_variables=rgbest(bestrun,:);
disp(sprintf('**************************************'));

toc

#pso convergence characteristics
#plot(ffmin(1:ffite(bestrun),bestrun),'-k');
#xlabel('Iteration');
#ylable('Fitness function value');
#title('PSO convergence characteristic');
