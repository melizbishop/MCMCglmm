#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

extern void MCMCglmm(
    double *yP, double *y2P, double *liabP, int *mvtype, int *nyP,
    int *dimP, int *nzmaxP, int *iXP, int *pXP, double *xXP,
    int *iZP, int *pZP, double *xZP, int *iAP, int *pAP, double *xAP,
    int *AtermP, int *GRdimP, int *levelsRP, int *updateP, int *splitP,
    int *nGP, double *GRinvP, double *GRvpP, double *GRnpP, int *chainP,
    double *LocP, double *VarP, double *PLiabP, int *familyP, double *propCP,
    int *verboseP, double *BvpP, double *BmupP, int *mfacP, int *observedP,
    int *diagP, int *AMtuneP, int *DICP, double *dbarP, int *proposal,
    int *ncutpointsP, int *nordinalP, double *stcutpointsP, double *CPP,
    double *AmupP, int *iAVpP, int *pAVpP, double *xAVpP, int *nzmaxAVpP,
    int *PXtermsP, int *iLXP, int *pLXP, double *xLXP, double *lambdaP,
    double *LvpP, double *LmupP, double *nanteBP, double *anteBvpP,
    double *anteBmupP, int *truncP, int *me_rtermP, double *me_prior_probP,
    double *me_XiP, int *meP, double *entropy_target_ptr,
    double *entropy_intensity_ptr, int *use_entropy_penalty_ptr
); // This is 68 arguments based on your MCMCglmm.cc

// Table of .C functions
static const R_CMethodDef CEntries[] = {
    {"MCMCglmm", (DL_FUNC) &MCMCglmm, 68}, // The C function name, pointer to the C function, and its argument count
    {NULL, NULL, 0} // Terminator for the array
};

void R_init_MCMCglmm(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, NULL, NULL, NULL); // Register the .C methods
    R_useDynamicSymbols(dll, FALSE); // Modern R prefers FALSE here when routines are explicitly registered
}
