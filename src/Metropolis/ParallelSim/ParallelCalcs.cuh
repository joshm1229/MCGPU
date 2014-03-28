/*
	Contains calculations for ParallelBox
	Same functions as SerialCalcs with function qualifiers and CUDA code

	Author: Nathan Coleman
*/

#ifndef PARALLELCALCS_CUH
#define PARALLELCALCS_CUH

#include "Metropolis/Utilities/StructLibrary.h"
#include "Metropolis/DataTypes.h"
#include "ParallelBox.cuh"

struct SimPointers
{
	ParallelBox *innerbox;
    Environment *envH, *envD;
    Atom *atomsH, *atomsD;
    Molecule *moleculesH, *moleculesD, *molTrans;
	int numA, numM, numEnergies, maxMolSize;
	int *nbrMolsH, *nbrMolsD, *molBatchH, *molBatchD;
	double *energiesH, *energiesD;
};

SimPointers *ptrs;
int steps;
float currentEnergy;
float oldEnergy;
int accepted;
int rejected;

__global__ void checkMoleculeDistances(Molecule *molecules, int currentMol, int startIdx, int numM, Environment *enviro, int *inCutoff);
__global__ void calcInterAtomicEnergy(Molecule *molecules, int curentMol, Environment *enviro, Real *energies, int numEnergies, int *molBatch, int maxMolSize);
__global__ void aggregateEnergies(Real *energies, int numEnergies, int interval, int batchSize);
__device__ Real calc_lj(Atom atom1, Atom atom2, Real r2);
__device__ Real calcCharge(Real charge1, Real charge2, Real r);
__device__ Real makePeriodic(Real x, Real box);
__device__ Real calcBlending(Real d1, Real d2);
__device__ int getXFromIndex(int idx);
__device__ int getYFromIndex(int x, int idx);

#endif