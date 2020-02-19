close all
clear all

c=3*10^8
minwavelength=1534.22;
maxwavelength=1564.59; 
minfreq=c/(minwavelength*10^(-9));
maxfreq=c/(maxwavelength*10^(-9));



testa=csvread('secondtcorrectdataremoved.dat');
testa=testa(99,:);
idx=find(testa==10000);
testa=testa(1,1:idx-1);
    normalize=max(testa);
        normalize=normalize(1,1);
 testing=testa'./normalize;

            Vs = smooth (testing, 3);
            sizeofdata=size(Vs');
            fnew=linspace(minfreq,maxfreq,sizeofdata(1,2));
lambda=c./(fnew);
 figure(100)
 plot(lambda,testing');
%     csvwrite('tester.dat',testing);
%     csvwrite('lambda.dat',wavelength);

dlmwrite('tester.dat', Vs, 'delimiter', ',', 'precision', 9); 
%dlmwrite('lambda.dat', wavelength, 'delimiter', ',', 'precision', 9); 
%startingplace= 2.36;
 Vs=testa;
cont=1;


%% find where to start for normal spectrum opt

idx=find(Vs==max(Vs));
        
        idxdecrement = idx(1,1);
        decrementVs=Vs(idx);
        
        noisethreshold = 5 %this is 5 percent
        
     
        while decrementVs>=(normalize/(noisethreshold))
            decrementVs=Vs(idxdecrement)
            idxdecrement = idxdecrement-1;
        end
        
        idxincrement = idx(1,1);
        
        incrementVs=Vs(idx);
        
        while incrementVs>=(normalize/(noisethreshold))
            incrementVs=Vs(idxincrement);
            idxincrement = idxincrement+1;
        end
        
        % check to see if we should flip the points that we have zoomed in
        % on

        idxcurrent = idxdecrement;
        tempmatrix = zeros(1,1);
        counter = 1;
        Vs=Vs';
        while ( sum(tempmatrix)< sum(Vs(idxdecrement:idxincrement,1)/2))
           tempmatrix(1,counter)=Vs(idxcurrent,1);
            idxcurrent = idxcurrent+1;
            counter = counter+1;
        end
        
        flipboolean=0;
        curvatureflip=0;
        if (idxcurrent-idxdecrement)>((idxincrement-idxdecrement)/2)
            flipboolean=0;
            curvatureflip=0;
        end
        range = (idxincrement-idxdecrement)*1;
        limits = [idxdecrement-range idxincrement+range flipboolean];
   csvwrite('limits.dat',limits);
   
    cont = 1;
    Aeq=[];
    Beq=[];
    lb=[0.001 5 1 1.43 1534.5 0.98];
    ub=[20 14 100 1.5 1537 1];
    lb=lb';
    ub=ub';
    
    xrand=rand(1,6)
    %xrand(1,3)=5.1-rand(1,1);
    xinit=xrand';
    xinit = xinit+lb;
%     A=-1.*eye(size(xrand,2));
%     b=zeros(size(xinit));
    A=[]
    b=[]
    
   %readin=csvread('xfinaltry1.dat');
    %petersgratingopt(readin);
while (cont ==1)
   
    %this is your final array of values based on your merit function which
    %you will ahve preprogrammed in @plotta

    
    %xinit(1,1)=5*10^(-4);
    %xinit(3,1)=5.1-rand(1,1);
    xfinal = fmincon(@petersgratingopt,xinit,A,b,Aeq,Beq,lb,ub);
    
    if(petersgratingopt(xfinal)<(0.2*1000))
        cont=0;
    else
        xrand=rand(1,6)
    %xrand(1,3)=5.1-rand(1,1);
        xinit=xrand';
    end
    
      
end
   load handel;
player = audioplayer(y, Fs);
play(player);
dlmwrite('xfinaltry98per.dat',xfinal, 'delimiter', ',', 'precision', 9); 