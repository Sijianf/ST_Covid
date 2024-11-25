### ######################################################################## ###
###                         MULTI_SCALE ID models                            ###
### Dimensions                                                               ###
###  N: higher areas (eg states, regions, health districts)                  ###
###  M: lower areas (counties, census tracts, zip codes etc)                 ###
###                                                                          ###
###  Assume Poisson models for counted data at this point,                   ###
###  i.e., that higher and lower levels have counts.                         ###
###                                                                          ###
### Outcomes                                                                 ###
###  Ylow[i,j]:  the count of ID cases in i th low region and j th time      ###
###  Yhigh[k,j]: the count of ID cases in k th high region and j th time     ###
###  Dlow[i,j]:  the count of deaths in i th region and j th time            ###
###  Dhigh[k,j]: the count of deaths in k th region and j th time            ###
###                                                                          ###
###  Assume that there is no mis-alignment and that each high region         ###
###  contains a complete set of lower areas.                                 ###
###  HLindex[i] is an index which denotes the high level region              ###
###  to which a low level region belongs                                     ###
### ######################################################################## ###

#  Set up for parallel computing in HPC
setwd("/work/sfan/ST_Covid/")
# setwd("/Users/snorlax/Documents/projects/ST_Covid/")
gc() # garbage collection
slurm_arrayid <- Sys.getenv('SLURM_ARRAY_TASK_ID')
idseed <- as.numeric(slurm_arrayid)
model_ID <- idseed # Pass the index to be the model ID
args <- commandArgs(trailingOnly = TRUE)
model_type <- args[1] # Pass the args to be the model type
if(is.na(model_type)) model_type = ""
cat(model_ID,model_type,"\n")

# Load spatial information from saving on HPC since it's hard to install packages
# library(sf)
# library(spdep)
# SC <- st_read("./data/SC_county_alphasort.shp")
# SC.nb <- nb2WB(poly2nb(SC))
# save(SC.nb,file = "./data/SC.RData")
load("./data/SC.RData")

#  Read in the data here from CDC wonder files
SCCaseDeath<-read.csv(file="./data/SCcounty_weekly_wide.csv",header=TRUE)
Dates<-read.csv("./data/week_numbers_reference.csv",header=TRUE)
Week<-Dates$week.number
date<-Dates$date_reformat

SCCDmat<-cbind(SCCaseDeath[,5:696])
SCCumCase<- SCCDmat[,1:173]
SCCumDeath<-SCCDmat[,174:346]
SCNewCase<-SCCDmat[,347:519]
SCNewDeath<-SCCDmat[,520:692]

time<-seq(1:173)
Tot=173

## assigning variables ##
Ylow<-matrix(0,nrow=46,ncol=173)
Dlow<-matrix(0,nrow=46,ncol=173)
YClow<-matrix(0,nrow=46,ncol=173)
DClow<-matrix(0,nrow=46,ncol=173)
M<-46
Ylow<-as.matrix(SCNewCase,dimnames=NULL)
Dlow<-as.matrix(SCNewDeath,dimnames=NULL)
YClow<-as.matrix(SCCumCase,dimnames=NULL)
DClow<-as.matrix(SCCumDeath,dimnames=NULL)
N=1
Yhigh<-matrix(0,nrow=N,ncol=173,dimnames=NULL)
Dhigh<-matrix(0,nrow=N,ncol=173,dimnames=NULL)
Yhigh<-colSums(Ylow)
Dhigh<-colSums(Dlow)
Yhigh<-t(as.matrix(Yhigh))
Dhigh<-t(as.matrix(Dhigh))
YChigh<-matrix(0,nrow=N,ncol=173)
DChigh<-matrix(0,nrow=N,ncol=173)
YChigh<-colSums(YClow)
DChigh<-colSums(DClow)
YChigh<-t(as.matrix(YChigh))
DChigh<-t(as.matrix(DChigh))

# Load in the models and switch accordingly
library(nimble)
source("./codes/models_raw.R")
# source("./codes/HPC/models_raw.R")
data<-list(Dhigh,Dlow,adj=SC.nb$adj,weights=SC.nb$weights,num=SC.nb$num)
names(data)<-c("Dhigh","Dlow","adj","weights","num")
constants<-list(Ylow,Yhigh,YChigh,YClow,M,Tot)
names(constants)<-c("Ylow","Yhigh","YChigh","YClow","M","Tot")

inits0<-list(
  dl0=0.0,dl1=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  taudl0=0.1,taudl1=0.2,tauDlv1=0.1,tauDlv2=0.1)

inits1<-list(
  dh0=0.0,dh1=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,taudh1=0.1,tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  taudl0=0.1,taudl1=0.2,tauDlv1=0.1,tauDlv2=0.1)

inits2<-list(
  dh0=0.0,dh1=0.0,dh2=0.0,dh3=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,taudh=rep(0.1,3),tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,dl2=0.0,dl3=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  taudl0=0.1,taudl=rep(0.2,3),tauDlv1=0.1,tauDlv2=0.1)

inits3<-list(
  dh0=0.0,dh1=0.0,dh2=0.0,dh3=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,taudh=rep(0.1,3),tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  taudl0=0.1,taudl1=0.2,tauDlv1=0.1,tauDlv2=0.1)

inits4<-list(
  dh0=0.0,dh1=0.0,dh2=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,taudh=rep(0.1,2),tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  taudl0=0.1,taudl1=0.2,tauDlv1=0.1,tauDlv2=0.1)

inits5<-list(
  dh0=0.0,dh1=0.0,dh2=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,taudh=rep(0.1,2),tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,dl2=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  taudl0=0.1,taudl=rep(0.1,2),tauDlv1=0.1,tauDlv2=0.1)

inits6<-list(
  dh0=0.0,dh1=0.0,dh2=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,taudh=rep(0.1,2),tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,dl2=0.0,dl3=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  Dlv=structure(.Data=rep(0.0,M*Tot),.Dim=c(M,Tot)),
  taudl0=0.1,taudl=rep(0.2,3),tauDlv1=0.1,tauDlv2=0.1,tauDlv=0.1)

inits7<-list(
  dh0=0.0,dh1=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,taudh1=0.1,tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,dl2=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  taudl0=0.1,taudl=rep(0.1,2),tauDlv1=0.1,tauDlv2=0.1)

inits8<-list(
  dh0=0.0,dh1=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,taudh1=0.1,tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,dl2=0.0,dl3=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  taudl0=0.1,taudl=rep(0.2,3),tauDlv1=0.1,tauDlv2=0.1)

inits9<-list(
  dh0=0.0,dh1=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,taudh1=0.1,tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,dl2=0.0,dl3=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  Dlv=structure(.Data=rep(0.0,M*Tot),.Dim=c(M,Tot)),
  taudl0=0.1,taudl=rep(0.2,3),tauDlv1=0.1,tauDlv2=0.1,tauDlv=0.1)

inits10<-list(
  dh0=0.0,dh1=0.0,dh2=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,taudh=rep(0.1,2),tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,dl2=0.0,dl3=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  taudl0=0.1,taudl=rep(0.2,3),tauDlv1=0.1,tauDlv2=0.1)

inits11<-list(
  dh0=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  taudl0=0.1,taudl1=0.2,tauDlv1=0.1,tauDlv2=0.1)

inits12<-list(
  dl0=0.0,dl1=0.0,dl2=0.0,dl3=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  Dlv=structure(.Data=rep(0.0,M*Tot),.Dim=c(M,Tot)),
  taudl0=0.1,taudl=rep(0.2,3),tauDlv1=0.1,tauDlv2=0.1,tauDlv=0.1)

inits13<-list(
  dl0=0.0,dl1=0.0,dl2=0.0,dl3=0.0,Dlv2=rep(0,Tot),
  taudl0=0.1,taudl=rep(0.2,3),tauDlv2=0.1)

inits14<-list(
  dh0=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,tauDhv=0.1,

  dl0=0.0,dl1=0.0,dl2=0.0,dl3=0.0,Dlv2=rep(0,Tot),
  taudl0=0.1,taudl=rep(0.2,3),tauDlv2=0.1)

inits15<-list(
  dh0=0.0,dh1=0.0,dh2=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,taudh=rep(0.1,2),tauDhv=0.1,

  dl0=0.0,dl1=0.0,dl2=0.0,dl3=0.0,Dlv2=rep(0,Tot),
  taudl0=0.1,taudl=rep(0.2,3),tauDlv2=0.1)

inits16<-list(
  dh0=0.0,dh1=0.0,dh2=0.0,dh3=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,taudh=rep(0.1,3),tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,dl2=0.0,dl3=0.0,Dlv2=rep(0,Tot),
  taudl0=0.1,taudl=rep(0.2,3),tauDlv2=0.1)

inits17<-list(
  dh0=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,dl2=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  taudl0=0.1,taudl=rep(0.1,2),tauDlv1=0.1,tauDlv2=0.1)

inits18<-list(
  dh0=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,dl2=0.0,dl3=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  taudl0=0.1,taudl=rep(0.2,3),tauDlv1=0.1,tauDlv2=0.1)

inits19<-list(
  dh0=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,dl2=0.0,dl3=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  Dlv=structure(.Data=rep(0.0,M*Tot),.Dim=c(M,Tot)),
  taudl0=0.1,taudl=rep(0.2,3),tauDlv1=0.1,tauDlv2=0.1,tauDlv=0.1)

inits20<-list(
  dh0=0.0,Dhv=rep(0,Tot),
  taudh0=0.1,tauDhv=0.1,
  
  dl0=0.0,dl1=0.0,dl2=0.0,dl3=0.0,Dlv1=rep(0,M),Dlv2=rep(0,Tot),
  Dlv=structure(.Data=rep(0.0,M*Tot),.Dim=c(M,Tot)),
  taudl0=0.1,taudl=rep(0.2,3),tauDlv1=0.1,tauDlv2=0.1,tauDlv=0.1)


###### Try to use parallel ######
library(parallel)
this_cluster <- makeCluster(2)
set.seed(2024)
useWAIC <- TRUE

# Create a function specific to your setting:
run_MCMC_allcode <- function(code, data, constants, inits, seed,
                             monitors = NULL, addon = NULL,
                             niter=50000, nburnin=30000, thin = 2) {
  library(nimble)
  
  myModel <- nimbleModel(code = code,
                         data = data,
                         constants = constants,
                         inits = inits)
  
  CmyModel <- compileNimble(myModel)
  
  if (is.null(monitors)) {
    # If not specified, we monitor all the coefficients.
    monitors <- myModel$getParents(myModel$getNodeNames(dataOnly = TRUE), stochOnly = TRUE)
    if (!is.null(addon)) {
      # this allows extra variables to be monitored.
      monitors <- c(monitors, addon)
    }
  } else {
    # this allows extra variables to be monitored.
    if (!is.null(addon)) {
      monitors <- c(monitors, addon)
    }
  }
  
  myMCMC <- buildMCMC(CmyModel, monitors = monitors)
  CmyMCMC <- compileNimble(myMCMC)
  
  results <- runMCMC(CmyMCMC, niter = niter, nburnin = nburnin, thin = thin, setSeed = seed)
  
  return(results)
}

myCode = get(paste0("model",model_ID,model_type))
myData = data
myConstants = constants
myInits = get(paste0("inits",model_ID))
myMonitors = NULL
if(model_type == "sh"){
  myAddon = c("HDevsum","HDev","DHmu")
} else {
  myAddon = c("Devsum","HDevsum","LDevsum","HDev","LDev","DHmu","DLmu")
}
myNiter = 4000000
myNburnin = 3000000
myThin = 1000

output <- parLapply(cl = this_cluster, X = 1:2,
                    fun = run_MCMC_allcode,
                    code = myCode,
                    data = myData,
                    constants = myConstants,
                    inits = myInits,
                    monitors = myMonitors,
                    addon = myAddon,
                    niter = myNiter,
                    nburnin = myNburnin,
                    thin = myThin)

# It's good practice to close the cluster when you're done with it.
stopCluster(this_cluster)

####  WAIC calculation (will do this later by hand)
# myModel <- nimbleModel(code = myCode, data = myData, constants = myConstants)
# CmyModel <- compileNimble(myModel)   # calculate WAIC needs compiled model to exist
# samples <- do.call(rbind, output)    # single matrix of samples
# waic <- calculateWAIC(samples, myModel)

save(output, file = paste0("./outputs/results_m",model_ID,model_type,".RData"))


