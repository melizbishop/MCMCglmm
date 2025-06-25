# ===Ancestral behaviors of melanogaster fly===
# =============================================

# ---Load the necessary libraries
library(coda)
library(ape)
library(Matrix)
library(parallel)

# ---Global parameters
Nb = 12 #number of behaviors

# ---Defining phylogeny -> pedigree variable for MCMCglmm
tt="((yakuba:0.09,santomea:0.09)oldyasa:0.44,((sechelia:0.15,simulans:0.15,mauritiana:0.15)oldsim:0.14,melanogaster:0.29)oldmela:0.24);"

flytree<-read.tree(text=tt)
LFlydat <- read.table("/Users/meganbishop/Desktop/log_bottleneck_alphas.txt", header=TRUE, sep="", row.names="id")
# ---Defining prior
# non-informative prior
IJ <- (1/(Nb+1))*(diag(Nb)+matrix(1,Nb,Nb))
prior.1<-list(G=list(G1=list(V=IJ/2,nu=Nb)), R=list(V=IJ/2,nu=Nb))

MY_ENTROPY_TARGET <- 40 # Example: close to log(Gamma(12)) if alphas ~ 1
MY_ENTROPY_INTENSITY <- .01 # Start with a very small intensity

# ---Creating fixed effects
sfix="cbind("
for (i in 1:(Nb-1)){sfix <-paste(sfix,colnames(LFlydat)[i+1],",",sep="")}
sfix <-paste(sfix,colnames(LFlydat)[Nb+1],") ~ trait-1",sep="")
fixed <- as.formula(sfix)
model <- MCMCglmm(fixed=fixed,
                   random = ~us(trait):animal,
                   rcov = ~us(trait):units,
                   data = LFlydat,
                   family = rep("gaussian", Nb),
                   prior=prior.1,
                   pedigree=flytree,
                   pr=TRUE,
                   verbose = TRUE,
                   thin=20,
                   entropy_target = MY_ENTROPY_TARGET,
                   entropy_intensity = MY_ENTROPY_INTENSITY)
save(model, file = "BottleneckModel_Ent1.Rdata")
write.table(model$Sol, file="E_BN_fixed1.txt", row.names=TRUE, col.names=TRUE)
write.table(model$VCV, file="E_BN_vars1.txt", row.names=TRUE, col.names=TRUE)
