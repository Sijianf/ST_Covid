#------------------------------------------------------------------------------#
####                          Model 0: Basic model                          ####
#------------------------------------------------------------------------------#
# - High-level mean = sum of low-level means
# - No cumulative counts as covariates
# - No cross-level random effects

model0<-nimbleCode({
  
  ### High level deaths 
  DHmu[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  for(j in 2:Tot){
    DHmu[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv[i]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+Dlv[i]
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
  #### end model 0 
})

#------------------------------------------------------------------------------#
####                               Model 1                                  ####
#------------------------------------------------------------------------------#
# - High-level mean = sum of low-level means (as above)
# - No cumulative counts as covariates
# - Added cross-level random effects 

model1<-nimbleCode({
  
  ### High level deaths 
  DHmu[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(DHmu1[1,1]+0.001)+Dhv[1]
  for(j in 2:Tot){
    DHmu[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(DHmu1[1,j]+0.001)+Dhv[j]
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv[i]+Dhv[1] 
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
  #### end model 1
})


#------------------------------------------------------------------------------#
####                               Model 2                                  ####
#------------------------------------------------------------------------------#
# - High-level mean now is a function of high level cases and cumulative cases
# - Added lagged time effects for both high and low level models: e.g., YChigh[1,j] and DHmu[1,j-1]
# - Added cross-level random effects 

model2<-nimbleCode({
  
  ### High level deaths 
  DHmu[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  for(j in 2:Tot){
    DHmu[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(YChigh[1,j]+0.001)+dh3*log(DHmu[1,j-1]+0.001)+Dhv[j]
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv[i]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(DLmu[i,j-1]+0.001)+Dlv[i]+Dhv[j]
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
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dh3~dnorm(0,taudh[3])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  tauDlv~dgamma(2,0.5)
  tauDhv~dgamma(2,0.5)
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  
  for (k in 1:3){
    taudh[k]~dgamma(2,0.5)
    taudl[k]~dgamma(2,0.5)
  }
  
  #### end model 2 
})



#------------------------------------------------------------------------------#
####                               Model 3                                  ####
#------------------------------------------------------------------------------#
# - Simpler version of Model 2 
# - High-level mean now is a function of high level cases and cumulative cases
# - Removed lagged time effects in low-level models
# - Added cross-level random effects 

model3<-nimbleCode({
  
  ### High level deaths 
  DHmu[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  for(j in 2:Tot){
    DHmu[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(YChigh[1,j]+0.001)+dh3*log(DHmu[1,j-1]+0.001)+Dhv[j]
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv[i]+Dhv[1]
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
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dh3~dnorm(0,taudh[3])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl1)
  
  tauDlv~dgamma(2,0.5)
  tauDhv~dgamma(2,0.5)
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  taudl1~dgamma(2,0.5)
  
  for (k in 1:1){
    taudh[k]~dgamma(2,0.5)
  }
  
  #### end model 3 
})





