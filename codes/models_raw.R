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
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))

  for(j in 2:Tot){
    DHmu[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+Dlv1[i]+Dlv2[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }

  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dlv2[j]~dnorm(0,tauDlv2)
  }
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl1)
  
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  taudl1~dgamma(2,0.5)
  #### end model 0
})



#------------------------------------------------------------------------------#
####                                Model 0s                                ####
#------------------------------------------------------------------------------#
# This is now the separate modeling, added "s" to distinguish.
# This is actually the same as the model 0 since the high level model is not doing regression.
# This model is also partially separated, since DHmu is calculated by DLmu's.

model0s<-nimbleCode({
  
  ### High level deaths
  DHmu[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  
  for(j in 2:Tot){
    DHmu[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+Dlv1[i]+Dlv2[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dlv2[j]~dnorm(0,tauDlv2)
  }
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl1)
  
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  taudl1~dgamma(2,0.5)
  #### end model 0s
})


#------------------------------------------------------------------------------#
####                               Model 1                                  ####
#------------------------------------------------------------------------------#
# - High-level mean = sum of low-level means
# - Added high-level random effects to effect low-level. 

model1<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(DHmu1[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(DHmu1[1,j]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+Dlv1[i]+Dlv2[j]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }
  
  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh1)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl1)
  
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  tauDhv~dgamma(2,0.5)
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  taudh1~dgamma(2,0.5)
  taudl1~dgamma(2,0.5)
  #### end model 1
})



#------------------------------------------------------------------------------#
####                               Model 1s                                 ####
#------------------------------------------------------------------------------#
# This model is partially separated, sicne DHmu1 is calcuated based on low-level. 

model1s<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(DHmu1[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(DHmu1[1,j]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+Dlv1[i]+Dlv2[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }
  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh1)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl1)
  
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  tauDhv~dgamma(2,0.5)
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  taudh1~dgamma(2,0.5)
  taudl1~dgamma(2,0.5)
  #### end model 1s
})


#------------------------------------------------------------------------------#
####                               Model 2                                  ####
#------------------------------------------------------------------------------#
# - High-level mean now is a regression function
# - Added cumulative cases and lagged time effects for both high and low level models:
#   e.g., YChigh[1,j] and Dhigh[1,j-1]
# - Added cross-level random effects

model2<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+dh2*log(YChigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(YChigh[1,j]+0.001)+dh3*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }
  
  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dh3~dnorm(0,taudh[3])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudh[k]~dgamma(2,0.5)
    taudl[k]~dgamma(2,0.5)
  }
  #### end model 2
})



#------------------------------------------------------------------------------#
####                               Model 2s                                 ####
#------------------------------------------------------------------------------#

model2s<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+dh2*log(YChigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(YChigh[1,j]+0.001)+dh3*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv1[i]+Dlv2[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }
  
  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dh3~dnorm(0,taudh[3])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudh[k]~dgamma(2,0.5)
    taudl[k]~dgamma(2,0.5)
  }
  #### end model 2s
})



#------------------------------------------------------------------------------#
####                               Model H4                                 ####
#------------------------------------------------------------------------------#

model_h4<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+dh2*log(YChigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(YChigh[1,j]+0.001)+dh3*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
  }
  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dh3~dnorm(0,taudh[3])
  
  tauDhv~dgamma(2,0.5)
  taudh0~dgamma(2,0.5)
  for (k in 1:3){
    taudh[k]~dgamma(2,0.5)
  }
  #### end model h4
})



#------------------------------------------------------------------------------#
####                               Model 3                                  ####
#------------------------------------------------------------------------------#
# - Simpler version of Model 2

model3<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+dh2*log(YChigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(YChigh[1,j]+0.001)+dh3*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+Dlv1[i]+Dlv2[j]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dh3~dnorm(0,taudh[3])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl1)
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudh[k]~dgamma(2,0.5)
  }
  taudl1~dgamma(2,0.5)
  #### end model 3
})



#------------------------------------------------------------------------------#
####                               Model 3s                                 ####
#------------------------------------------------------------------------------#

model3s<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+dh2*log(YChigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(YChigh[1,j]+0.001)+dh3*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+Dlv1[i]+Dlv2[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dh3~dnorm(0,taudh[3])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl1)
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudh[k]~dgamma(2,0.5)
  }
  taudl1~dgamma(2,0.5)  #### end model 3s
})




#------------------------------------------------------------------------------#
####                               Model 4                                  ####
#------------------------------------------------------------------------------#
# - See the Readme.md file for details

model4<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+Dlv1[i]+Dlv2[j]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl1)

  taudh0~dgamma(2,0.5)
  for (k in 1:2){
    taudh[k]~dgamma(2,0.5)
  }
  taudl0~dgamma(2,0.5)
  taudl1~dgamma(2,0.5)
  #### end model 4
})



#------------------------------------------------------------------------------#
####                               Model 4s                                 ####
#------------------------------------------------------------------------------#

model4s<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+Dlv1[i]+Dlv2[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl1)

  taudh0~dgamma(2,0.5)
  for (k in 1:2){
    taudh[k]~dgamma(2,0.5)
  }
  taudl0~dgamma(2,0.5)
  taudl1~dgamma(2,0.5)  
  #### end model 4s
})



#------------------------------------------------------------------------------#
####                               Model H2                                 ####
#------------------------------------------------------------------------------#

model_h2<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
  }
  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])

  tauDhv~dgamma(2,0.5)
  taudh0~dgamma(2,0.5)
  
  for (k in 1:2){
    taudh[k]~dgamma(2,0.5)
  }
  
  #### end model h2
})



#------------------------------------------------------------------------------#
####                               Model 5                                  ####
#------------------------------------------------------------------------------#
# - See the Readme.md file for details

model5<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:2){
    taudh[k]~dgamma(2,0.5)
    taudl[k]~dgamma(2,0.5)
  }
  #### end model 5
})



#------------------------------------------------------------------------------#
####                               Model 5s                                 ####
#------------------------------------------------------------------------------#

model5s<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:2){
    taudh[k]~dgamma(2,0.5)
    taudl[k]~dgamma(2,0.5)
  }
  #### end model 5s
})



#------------------------------------------------------------------------------#
####                               Model 5sh                                ####
#------------------------------------------------------------------------------#

model5sh<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
  }
  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])

  tauDhv~dgamma(2,0.5)
  taudh0~dgamma(2,0.5)
  
  for (k in 1:2){
    taudh[k]~dgamma(2,0.5)
  }
  
  #### end model 5sh
})


#------------------------------------------------------------------------------#
####                               Model 6                                  ####
#------------------------------------------------------------------------------#
# - See the Readme.md file for details

model6<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,j]+0.001)+Dlv1[i]+Dlv2[1]+Dlv[i,1]+Dhv[1]+u[i]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dlv[i,j]+Dhv[j]+u[i]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
    for (i in 1:M){
      Dlv[i,j]~dnorm(0,tauDlv)
    }
  }
  
  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  tauDlv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  tauDhv~dgamma(2,0.5)
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  
  for (k in 1:2){
    taudh[k]~dgamma(2,0.5)
  }
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }
  tauU~dgamma(2,0.5)
  
  #### end model 6
})



#------------------------------------------------------------------------------#
####                               Model 6s                                 ####
#------------------------------------------------------------------------------#

model6s<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dlv[i,1]+u[i]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dlv[i,j]+u[i]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
    for (i in 1:M){
      Dlv[i,j]~dnorm(0,tauDlv)
    }
  }
  
  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  tauDlv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  tauDhv~dgamma(2,0.5)
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  
  for (k in 1:2){
    taudh[k]~dgamma(2,0.5)
  }
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }
  tauU~dgamma(2,0.5)
  
  #### end model 6s
})




#------------------------------------------------------------------------------#
####                               Model 7                                  ####
#------------------------------------------------------------------------------#
# - See the Readme.md file for details

model7<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(DHmu1[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(DHmu1[1,j]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh1)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])

  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  taudh1~dgamma(2,0.5)
  for (k in 1:2){
    taudl[k]~dgamma(2,0.5)
  }
  #### end model 7
})



#------------------------------------------------------------------------------#
####                               Model 7s                                 ####
#------------------------------------------------------------------------------#

model7s<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(DHmu1[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(DHmu1[1,j]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  
  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh1)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])

  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  taudh1~dgamma(2,0.5)
  for (k in 1:2){
    taudl[k]~dgamma(2,0.5)
  }
  #### end model 7s
})



#------------------------------------------------------------------------------#
####                               Model 8                                  ####
#------------------------------------------------------------------------------#
# - See the Readme.md file for details

model8<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(DHmu1[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(DHmu1[1,j]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh1)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudh1~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }
  #### end model 8
})


#------------------------------------------------------------------------------#
####                               Model 8s                                 ####
#------------------------------------------------------------------------------#

model8s<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(DHmu1[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(DHmu1[1,j]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh1)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudh1~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }
  #### end model 8s
})




#------------------------------------------------------------------------------#
####                               Model 9                                  ####
#------------------------------------------------------------------------------#
# - See the Readme.md file for details

model9<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(DHmu1[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(DHmu1[1,j]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dlv[i,1]+u[i]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dlv[i,j]+u[i]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
    for (i in 1:M){
      Dlv[i,j]~dnorm(0,tauDlv)
    }
  }

  tauDhv~dgamma(2,0.5)
  tauDlv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  
  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh1)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudh1~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }

  tauU~dgamma(2,0.5)
  #### end model 9
})



#------------------------------------------------------------------------------#
####                               Model 9s                                 ####
#------------------------------------------------------------------------------#

model9s<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(DHmu1[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(DHmu1[1,j]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dlv[i,1]+u[i]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dlv[i,j]+u[i]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
    for (i in 1:M){
      Dlv[i,j]~dnorm(0,tauDlv)
    }
  }

  tauDhv~dgamma(2,0.5)
  tauDlv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  
  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh1)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudh1~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }

  tauU~dgamma(2,0.5)
  #### end model 9s
})





#------------------------------------------------------------------------------#
####                               Model 10                                 ####
#------------------------------------------------------------------------------#
# - See the Readme.md file for details

model10<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:2){
    taudh[k]~dgamma(2,0.5)
  }
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }
  #### end model 10
})



#------------------------------------------------------------------------------#
####                               Model 10s                                ####
#------------------------------------------------------------------------------#

model10s<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv1[i]+Dlv2[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:2){
    taudh[k]~dgamma(2,0.5)
  }
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }
  #### end model 10s
})




#------------------------------------------------------------------------------#
####                              Model H0b                                 ####
#------------------------------------------------------------------------------#

model_h0b<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  
  dh0~dnorm(0,taudh0)
  taudh0~dgamma(2,0.5)
  
  #### end model h0b
})




#------------------------------------------------------------------------------#
####                              Model H2a                                 ####
#------------------------------------------------------------------------------#

model_h2a<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
  }
  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh1)

  tauDhv~dgamma(2,0.5)
  taudh0~dgamma(2,0.5)
  taudh1~dgamma(2,0.5)
  
  #### end model h2a
})



#------------------------------------------------------------------------------#
####                             Model H2b                                  ####
#------------------------------------------------------------------------------#

model_h2b<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Dhigh[1,j-1]+0.001)
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  
  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh1)

  taudh0~dgamma(2,0.5)
  taudh1~dgamma(2,0.5)
  
  #### end model h2b
})



#------------------------------------------------------------------------------#
####                               Model 11                                 ####
#------------------------------------------------------------------------------#
model11<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+Dlv1[i]+Dlv2[j]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }
  
  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl1)

  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  taudl1~dgamma(2,0.5)
  #### end model 11
})


#------------------------------------------------------------------------------#
####                               Model 11s                                ####
#------------------------------------------------------------------------------#
model11s<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+Dlv1[i]+Dlv2[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  
  dh0~dnorm(0,taudh0)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl1)

  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  taudl1~dgamma(2,0.5)
  #### end model 11s
})





#------------------------------------------------------------------------------#
####                               Model 12                                 ####
#------------------------------------------------------------------------------#
model12<-nimbleCode({
  
  ### High level deaths
  DHmu[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))

  for(j in 2:Tot){
    DHmu[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dlv[i,1]+u[i]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dlv[i,j]+u[i]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  
  for (j in 1:Tot){
    Dlv2[j]~dnorm(0,tauDlv2)
    for (i in 1:M){
      Dlv[i,j]~dnorm(0,tauDlv)
    }
  }

  tauDlv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }

  tauU~dgamma(2,0.5)
  #### end model 12
})


#------------------------------------------------------------------------------#
####                               Model 12s                                ####
#------------------------------------------------------------------------------#
# This is the same as model 12 since high level is not regression based.  

model12s<-nimbleCode({
  
  ### High level deaths
  DHmu[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))

  for(j in 2:Tot){
    DHmu[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dlv[i,1]+u[i]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dlv[i,j]+u[i]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  
  for (j in 1:Tot){
    Dlv2[j]~dnorm(0,tauDlv2)
    for (i in 1:M){
      Dlv[i,j]~dnorm(0,tauDlv)
    }
  }
  tauDlv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }

  tauU~dgamma(2,0.5)
  #### end model 12s
})



#------------------------------------------------------------------------------#
####                               Model 13                                 ####
#------------------------------------------------------------------------------#
model13<-nimbleCode({
  
  ### High level deaths
  DHmu[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))

  for(j in 2:Tot){
    DHmu[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv2[1]+u[i]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv2[j]+u[i]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (j in 1:Tot){
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDlv2~dgamma(2,0.5)
  
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }

  tauU~dgamma(2,0.5)
  #### end model 13
})



#------------------------------------------------------------------------------#
####                               Model 13s                                ####
#------------------------------------------------------------------------------#
# This is the same as model 13 since high level is not regression based.  

model13s<-nimbleCode({
  
  ### High level deaths
  DHmu[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))

  for(j in 2:Tot){
    DHmu[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv2[1]+u[i]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv2[j]+u[i]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (j in 1:Tot){
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDlv2~dgamma(2,0.5)

  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }

  tauU~dgamma(2,0.5)
  #### end model 13s
})




#------------------------------------------------------------------------------#
####                               Model 14                                 ####
#------------------------------------------------------------------------------#
model14<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }

  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv2[1]+u[i]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv2[j]+u[i]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDlv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDlv~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }

  tauU~dgamma(2,0.5)
  #### end model 14
})





#------------------------------------------------------------------------------#
####                               Model 14s                                ####
#------------------------------------------------------------------------------#
model14s<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }

  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv2[1]+u[i]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv2[j]+u[i]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDlv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }
  
  tauDlv~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  
  dh0~dnorm(0,taudh0)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }

  tauU~dgamma(2,0.5)
  #### end model 14s
})




#------------------------------------------------------------------------------#
####                               Model 15                                 ####
#------------------------------------------------------------------------------#
model15<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }

  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv2[1]+u[i]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv2[j]+u[i]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }
  
  tauDhv~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:2){
    taudh[k]~dgamma(2,0.5)
  }
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }

  tauU~dgamma(2,0.5)
  #### end model 15
})



#------------------------------------------------------------------------------#
####                               Model 15s                                ####
#------------------------------------------------------------------------------#
model15s<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }

  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv2[1]+u[i]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv2[j]+u[i]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }
  
  tauDhv~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:2){
    taudh[k]~dgamma(2,0.5)
  }
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }
  
  tauU~dgamma(2,0.5)
  #### end model 15s
})



#------------------------------------------------------------------------------#
####                               Model 16                                 ####
#------------------------------------------------------------------------------#
model16<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+dh2*log(YChigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(YChigh[1,j]+0.001)+dh3*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }

  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv2[1]+u[i]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv2[j]+u[i]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dh3~dnorm(0,taudh[3])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudh[k]~dgamma(2,0.5)
    taudl[k]~dgamma(2,0.5)
  }

  tauU~dgamma(2,0.5)
  #### end model 16
})



#------------------------------------------------------------------------------#
####                               Model 16s                                ####
#------------------------------------------------------------------------------#
model16s<-nimbleCode({
  
  ### High level deaths
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+dh1*log(Yhigh[1,1]+0.001)+dh2*log(YChigh[1,1]+0.001)+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+dh1*log(Yhigh[1,j]+0.001)+dh2*log(YChigh[1,j]+0.001)+dh3*log(Dhigh[1,j-1]+0.001)+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }

  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv2[1]+u[i]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv2[j]+u[i]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dh1~dnorm(0,taudh[1])
  dh2~dnorm(0,taudh[2])
  dh3~dnorm(0,taudh[3])
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudh[k]~dgamma(2,0.5)
    taudl[k]~dgamma(2,0.5)
  }

  tauU~dgamma(2,0.5)
  #### end model 16s
})



#------------------------------------------------------------------------------#
####                               Model 17                                 ####
#------------------------------------------------------------------------------#
model17<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])

  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:2){
    taudl[k]~dgamma(2,0.5)
  }
  #### end model 17
})



#------------------------------------------------------------------------------#
####                               Model 17s                                ####
#------------------------------------------------------------------------------#
model17s<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])

  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:2){
    taudl[k]~dgamma(2,0.5)
  }
  #### end model 17s
})



#------------------------------------------------------------------------------#
####                               Model 18                                 ####
#------------------------------------------------------------------------------#
model18<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }
  #### end model 18
})


#------------------------------------------------------------------------------#
####                               Model 18s                                ####
#------------------------------------------------------------------------------#
model18s<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+Dlv1[i]+Dlv2[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
  }

  tauDhv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)

  dh0~dnorm(0,taudh0)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }
  #### end model 18s
})



#------------------------------------------------------------------------------#
####                               Model 19                                 ####
#------------------------------------------------------------------------------#
model19<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dlv[i,1]+u[i]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dlv[i,j]+u[i]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
    for (i in 1:M){
      Dlv[i,j]~dnorm(0,tauDlv)
    }
  }
  
  tauDhv~dgamma(2,0.5)
  tauDlv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  
  dh0~dnorm(0,taudh0)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }

  tauU~dgamma(2,0.5)
  #### end model 19
})



#------------------------------------------------------------------------------#
####                               Model 19s                                ####
#------------------------------------------------------------------------------#
model19s<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dlv[i,1]+u[i]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dlv[i,j]+u[i]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  u[1:M]~dcar_normal(adj[],weights[],num[],tauU,zero_mean=1)
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
    for (i in 1:M){
      Dlv[i,j]~dnorm(0,tauDlv)
    }
  }
  
  tauDhv~dgamma(2,0.5)
  tauDlv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  
  dh0~dnorm(0,taudh0)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }

  tauU~dgamma(2,0.5)
  #### end model 19s
})



#------------------------------------------------------------------------------#
####                               Model 20                                 ####
#------------------------------------------------------------------------------#
model20<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dlv[i,1]+Dhv[1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dlv[i,j]+Dhv[j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
    for (i in 1:M){
      Dlv[i,j]~dnorm(0,tauDlv)
    }
  }
  
  tauDhv~dgamma(2,0.5)
  tauDlv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  
  dh0~dnorm(0,taudh0)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }

  #### end model 20
})



#------------------------------------------------------------------------------#
####                               Model 20s                                ####
#------------------------------------------------------------------------------#
model20s<-nimbleCode({
  
  ### High level deaths
  DHmu1[1,1]<-sum(DLmu[1:M,1])
  Dhigh[1,1]~dpois(DHmu[1,1])
  log(DHmu[1,1])<-dh0+Dhv[1]
  HDev[1,1]<--2*(Dhigh[1,1]*log(DHmu[1,1]+0.001)-(DHmu[1,1]+0.001)-lfactorial(Dhigh[1,1]))
  for(j in 2:Tot){
    DHmu1[1,j]<-sum(DLmu[1:M,j])
    Dhigh[1,j]~dpois(DHmu[1,j])
    log(DHmu[1,j])<-dh0+Dhv[j]
    HDev[1,j]<--2*(Dhigh[1,j]*log(DHmu[1,j]+0.001)-(DHmu[1,j]+0.001)-lfactorial(Dhigh[1,j]))
  }
  
  ### Low level deaths (M = 46 county)
  for(i in 1:M){
    Dlow[i,1]~dpois(DLmu[i,1])
    log(DLmu[i,1])<-dl0+dl1*log(Ylow[i,1]+0.001)+dl2*log(YClow[i,1]+0.001)+Dlv1[i]+Dlv2[1]+Dlv[i,1]
    LDev[i,1]<--2*(Dlow[i,1]*log(DLmu[i,1]+0.001)-(DLmu[i,1]+0.001)-lfactorial(Dlow[i,1]))
    
    for(j in 2:Tot){
      Dlow[i,j]~dpois(DLmu[i,j])
      log(DLmu[i,j])<-dl0+dl1*log(Ylow[i,j]+0.001)+dl2*log(YClow[i,j]+0.001)+dl3*log(Dlow[i,j-1]+0.001)+Dlv1[i]+Dlv2[j]+Dlv[i,j]
      LDev[i,j]<--2*(Dlow[i,j]*log(DLmu[i,j]+0.001)-(DLmu[i,j]+0.001)-lfactorial(Dlow[i,j]))
    }
  }
  
  HDevsum<-sum(HDev[1,1:Tot])
  LDevsum<-sum(LDev[1:M,1:Tot])
  Devsum<-HDevsum+LDevsum
  
  for (i in 1:M){
    Dlv1[i]~dnorm(0,tauDlv1)
  }
  for (j in 1:Tot){
    Dhv[j]~dnorm(0,tauDhv)
    Dlv2[j]~dnorm(0,tauDlv2)
    for (i in 1:M){
      Dlv[i,j]~dnorm(0,tauDlv)
    }
  }
  
  tauDhv~dgamma(2,0.5)
  tauDlv~dgamma(2,0.5)
  tauDlv1~dgamma(2,0.5)
  tauDlv2~dgamma(2,0.5)
  
  dh0~dnorm(0,taudh0)
  dl0~dnorm(0,taudl0)
  dl1~dnorm(0,taudl[1])
  dl2~dnorm(0,taudl[2])
  dl3~dnorm(0,taudl[3])
  
  taudh0~dgamma(2,0.5)
  taudl0~dgamma(2,0.5)
  for (k in 1:3){
    taudl[k]~dgamma(2,0.5)
  }

  #### end model 20s
})

















