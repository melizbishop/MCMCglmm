# ===Ancestral behaviors of melanogaster fly===
# =============================================
#Best place to understand code are Hadfield course Notes on GlMM chapter 5.
#https://cran.r-project.org/web/packages/MCMCglmm/vignettes/CourseNotes.pdf

# ---Load the necessary libraries

#library(MCMCglmm)
library(coda)
library(ape)
library(Matrix)
library(MCMCglmm)
library(parallel)
##library(parallel,lib.loc="/Rpackages/")


# ---Global parameters
Nb = 134 #number of behaviors

# ---Set the output file
# sink("ancestral0.out")

# ---Defining phylogeny -> pedigree variable for MCMCglmm
tt="((yakuba:0.09,santomea:0.09)oldyasa:0.44,((sechelia:0.15,simulans:0.15,mauritiana:0.15)oldsim:0.14,melanogaster:0.29)oldmela:0.24);"


flytree<-read.tree(text=tt)
# ---Plot of tree
#par(ask=TRUE)
#plot(flytree,edge.width=2,label.offset=0.1)
#nodelabels()
#tiplabels()
#edgelabels(flytree$edge.length, bg="black", col="white", font=2)
#dev.copy2eps()
#par(ask=FALSE)


# ---Load the dataset: l_i= log p(behavior_i) - log p(behavior_0) 
# 134 behaviors + 0 behavior, 593 flies from 6 species (column-> animal)
LFlydat <- read.table("/Users/meganbishop/behavioral-evolution/alphas_tabs_100.txt", header=TRUE, sep="\t", row.names="id")

# ---Defining prior
# non-informative prior
IJ <- (1/(Nb+1))*(diag(Nb)+matrix(1,Nb,Nb))
prior.1<-list(G=list(G1=list(V=IJ/2,nu=Nb)), R=list(V=IJ/2,nu=Nb))

# ---Creating fixed effects
sfix="cbind("
for (i in 1:(Nb-1)){sfix <-paste(sfix,colnames(LFlydat)[i+1],",",sep="")}
sfix <-paste(sfix,colnames(LFlydat)[Nb+1],") ~ trait-1",sep="")
fixed <- as.formula(sfix)

#---Run MCMCglmm
model <- MCMCglmm(fixed=fixed,
                   random = ~us(trait):animal,
                   rcov = ~us(trait):units,
                   data = LFlydat,
                   family = rep("gaussian", Nb),
                   prior=prior.1,
                   pedigree=flytree,
                   pr=TRUE,
                   verbose = FALSE,
                   thin=20)
save(model, file = "MCMCAlphas100.txt")
#write.table(model0$Sol, file="ModelSolAllMinSimNoYak00.txt", row.names=FALSE, col.names=FALSE)
#write.table(model0$VCV, file="ShortScriptVCVMCMC.txt", row.names=FALSE, col.names=FALSE)
