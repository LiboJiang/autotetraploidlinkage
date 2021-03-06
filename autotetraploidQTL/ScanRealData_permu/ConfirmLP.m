
%%% figer our Linkage Phase & Pai

function RetureValue = ConfirmLP()

global Mmtrx samp Lphase

output.likelihood=-999999;
 
for ilp=1:length(Lphase)


for mk1=1:Lphase(ilp).dms(1)
    for mk2=1:Lphase(ilp).dms(2)
        MtrxPaiP{mk1,mk2}=[];
        MtrxCoef{mk1,mk2}=[];
        for i1=1:length(Lphase(ilp).mtc{1,mk1})
            for i2=1:length(Lphase(ilp).mtc{2,mk2})
                MtrxPaiP{mk1,mk2}=[MtrxPaiP{mk1,mk2},Mmtrx{1}(Lphase(ilp).mtc{1,mk1}(i1),Lphase(ilp).mtc{2,mk2}(i2))];
                MtrxCoef{mk1,mk2}=[MtrxCoef{mk1,mk2},Mmtrx{2}(Lphase(ilp).mtc{1,mk1}(i1),Lphase(ilp).mtc{2,mk2}(i2))];
            end
        end
    end
end

opai=zeros(9,1);
epai=zeros(9,1)+1/9;
egtime=0;

while sum(abs(opai-epai)>0.000001)>1
opai=epai;

for ipai=1:length(epai)
    tempss=0;
    for mk1=1:Lphase(ilp).dms(1)
        for mk2=1:Lphase(ilp).dms(2)
            if (sum(MtrxPaiP{mk1,mk2}==ipai)>0)&&(samp.mtrx(mk1,mk2)>0)
                tempss=tempss+sum(epai(ipai)./MtrxCoef{mk1,mk2}(MtrxPaiP{mk1,mk2}==ipai))/sum(epai(MtrxPaiP{mk1,mk2})'./MtrxCoef{mk1,mk2})*samp.mtrx(mk1,mk2);   
            end
        end
    end
    epai(ipai)=tempss/samp.size;    
end
egtime=egtime+1;

end

for mk1=1:Lphase(ilp).dms(1)
    for mk2=1:Lphase(ilp).dms(2)
        efreq(mk1,mk2)=sum(epai(MtrxPaiP{mk1,mk2})'./MtrxCoef{mk1,mk2});
    end
end
LphasePar(ilp).epai=epai;
LphasePar(ilp).efreq=efreq;
LphasePar(ilp).likelihood=sum(sum(samp.mtrx.*log(LphasePar(ilp).efreq)));

if  output.likelihood<=LphasePar(ilp).likelihood
    output.likelihood=LphasePar(ilp).likelihood;
    output.epai=LphasePar(ilp).epai;
    output.LinkagePhase=Lphase(ilp).case;
    output.mtc=Lphase(ilp).mtc;
    output.Mpai{1}=MtrxPaiP;
    output.Mpai{2}=MtrxCoef;
end

clear efreq epai

end


RetureValue=output;








