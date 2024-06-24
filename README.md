# ST_Covid_project
 This is the project about spatial temproal analysis for Covid data. 

```r
model0<-nimbleCode({
  
  ### High level deaths 
  #### The high level mean is the sum of lower level mean
  DHmu[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  for(j in 2:Tot){
    DHmu[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+Dhv[j]
  }
  
  ### Low level deaths 
  #### Dealing with county level in SC in our example (M=46)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv[i]+Dhv[1] # This Dhv[1] is needed? 
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+Dlv[i]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  Dev<-sum(LDev[1:M,1:Tot])
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
  }
  for (i in 1:M){
    Dlv[i]~dnorm(0,tauDlv)
  }
  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh1)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl1)
  
  tauDlv~dgamma(2,0.5)
  tauDhv~dgamma(2,0.5)
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  taudh1~dgamma(2,0.5)
  taudl1~dgamma(2,0.5)
  #### end model0 
})

```
