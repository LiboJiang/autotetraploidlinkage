


%%%% for em cpt u & sigma2



ou=zeros(1,10);osigma2=0;
emtime=0;

while sum(abs([eval.u,eval.sigma2]-[ou,osigma2])>0.0001)>0

tempu1=zeros(1,10);
tempu2=zeros(1,10);
tempsg=0;

for i=1:10
    for j=1:10
        for l=1:length(samp.PHmtrx{i,j})
            tempsum=    sum(eval.g(MQMmtrx{1}(i,:,j))'./MQMmtrx{2}(i,:,j).*normpdf(samp.PHmtrx{i,j}(l),eval.u,sqrt(eval.sigma2)));
            freqP{i,j}(l,:)=eval.g(MQMmtrx{1}(i,:,j))'./MQMmtrx{2}(i,:,j).*normpdf(samp.PHmtrx{i,j}(l),eval.u,sqrt(eval.sigma2))/tempsum;
            tempu1=tempu1+freqP{i,j}(l,:).*samp.PHmtrx{i,j}(l);
            tempu2=tempu2+freqP{i,j}(l,:);
            tempsg=tempsg+sum(freqP{i,j}(l,:).*(samp.PHmtrx{i,j}(l)-eval.u).^2);
        end
    end
end

ou=eval.u;osigma2=eval.sigma2;
eval.u=tempu1./tempu2;
eval.sigma2=tempsg/samplesize;

emtime=emtime+1;

end



