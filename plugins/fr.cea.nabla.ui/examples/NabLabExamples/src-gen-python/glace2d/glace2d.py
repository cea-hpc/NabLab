"""
DO NOT EDIT THIS FILE - it is machine generated
"""
import sys
import json
import numpy as np
import math
from cartesianmesh2d import CartesianMesh2D
from pvdfilewriter2d import PvdFileWriter2D

class Glace2d:
	gamma = 1.4
	xInterface = 0.5
	deltatCfl = 0.4
	rhoIniZg = 1.0
	rhoIniZd = 0.125
	pIniZg = 1.0
	pIniZd = 0.1

	def __init__(self, mesh):
		self.__mesh = mesh
		self.__nbNodes = mesh.nbNodes
		self.__nbCells = mesh.nbCells
		self.__nbTopNodes = len(mesh.getGroup("TopNodes"))
		self.__nbBottomNodes = len(mesh.getGroup("BottomNodes"))
		self.__nbLeftNodes = len(mesh.getGroup("LeftNodes"))
		self.__nbRightNodes = len(mesh.getGroup("RightNodes"))
		self.__nbInnerNodes = len(mesh.getGroup("InnerNodes"))

	def jsonInit(self, jsonContent):
		self.__outputPath = jsonContent["outputPath"]
		self.__writer = PvdFileWriter2D("Glace2d", self.__outputPath)
		self.outputPeriod = jsonContent["outputPeriod"]
		self.lastDump = -sys.maxsize - 1
		self.n = 0
		self.stopTime = jsonContent["stopTime"]
		self.maxIterations = jsonContent["maxIterations"]
		self.X_n = np.empty((self.__nbNodes, 2), dtype=np.double)
		self.X_nplus1 = np.empty((self.__nbNodes, 2), dtype=np.double)
		self.X_n0 = np.empty((self.__nbNodes, 2), dtype=np.double)
		self.b = np.empty((self.__nbNodes, 2), dtype=np.double)
		self.bt = np.empty((self.__nbNodes, 2), dtype=np.double)
		self.Ar = np.empty((self.__nbNodes, 2, 2), dtype=np.double)
		self.Mt = np.empty((self.__nbNodes, 2, 2), dtype=np.double)
		self.ur = np.empty((self.__nbNodes, 2), dtype=np.double)
		self.c = np.empty((self.__nbCells), dtype=np.double)
		self.m = np.empty((self.__nbCells), dtype=np.double)
		self.p = np.empty((self.__nbCells), dtype=np.double)
		self.rho = np.empty((self.__nbCells), dtype=np.double)
		self.e = np.empty((self.__nbCells), dtype=np.double)
		self.E_n = np.empty((self.__nbCells), dtype=np.double)
		self.E_nplus1 = np.empty((self.__nbCells), dtype=np.double)
		self.V = np.empty((self.__nbCells), dtype=np.double)
		self.deltatj = np.empty((self.__nbCells), dtype=np.double)
		self.uj_n = np.empty((self.__nbCells, 2), dtype=np.double)
		self.uj_nplus1 = np.empty((self.__nbCells, 2), dtype=np.double)
		self.l = np.empty((self.__nbCells, 4), dtype=np.double)
		self.Cjr_ic = np.empty((self.__nbCells, 4, 2), dtype=np.double)
		self.C = np.empty((self.__nbCells, 4, 2), dtype=np.double)
		self.F = np.empty((self.__nbCells, 4, 2), dtype=np.double)
		self.Ajr = np.empty((self.__nbCells, 4, 2, 2), dtype=np.double)

		# Copy node coordinates
		gNodes = mesh.geometry.nodes
		for rNodes in range(self.__nbNodes):
			self.X_n0[rNodes] = gNodes[rNodes]

	"""
	 Job computeCjr called @1.0 in executeTimeLoopN method.
	 In variables: X_n
	 Out variables: C
	"""
	def _computeCjr(self):
		for jCells in range(self.__nbCells):
			jId = jCells
			nodesOfCellJ = mesh.getNodesOfCell(jId)
			nbNodesOfCellJ = len(nodesOfCellJ)
			for rNodesOfCellJ in range(nbNodesOfCellJ):
				rPlus1Id = nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCellJ)%nbNodesOfCellJ]
				rMinus1Id = nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCellJ)%nbNodesOfCellJ]
				rPlus1Nodes = rPlus1Id
				rMinus1Nodes = rMinus1Id
				self.C[jCells, rNodesOfCellJ] = self.__operatorMult(0.5, self.__perp(self.__operatorSub(self.X_n[rPlus1Nodes], self.X_n[rMinus1Nodes])))

	"""
	 Job computeInternalEnergy called @1.0 in executeTimeLoopN method.
	 In variables: E_n, uj_n
	 Out variables: e
	"""
	def _computeInternalEnergy(self):
		for jCells in range(self.__nbCells):
			self.e[jCells] = self.E_n[jCells] - 0.5 * self.__dot(self.uj_n[jCells], self.uj_n[jCells])

	"""
	 Job iniCjrIc called @1.0 in simulate method.
	 In variables: X_n0
	 Out variables: Cjr_ic
	"""
	def _iniCjrIc(self):
		for jCells in range(self.__nbCells):
			jId = jCells
			nodesOfCellJ = mesh.getNodesOfCell(jId)
			nbNodesOfCellJ = len(nodesOfCellJ)
			for rNodesOfCellJ in range(nbNodesOfCellJ):
				rPlus1Id = nodesOfCellJ[(rNodesOfCellJ+1+nbNodesOfCellJ)%nbNodesOfCellJ]
				rMinus1Id = nodesOfCellJ[(rNodesOfCellJ-1+nbNodesOfCellJ)%nbNodesOfCellJ]
				rPlus1Nodes = rPlus1Id
				rMinus1Nodes = rMinus1Id
				self.Cjr_ic[jCells, rNodesOfCellJ] = self.__operatorMult(0.5, self.__perp(self.__operatorSub(self.X_n0[rPlus1Nodes], self.X_n0[rMinus1Nodes])))

	"""
	 Job iniTime called @1.0 in simulate method.
	 In variables: 
	 Out variables: t_n0
	"""
	def _iniTime(self):
		self.t_n0 = 0.0

	"""
	 Job computeLjr called @2.0 in executeTimeLoopN method.
	 In variables: C
	 Out variables: l
	"""
	def _computeLjr(self):
		for jCells in range(self.__nbCells):
			jId = jCells
			nodesOfCellJ = mesh.getNodesOfCell(jId)
			nbNodesOfCellJ = len(nodesOfCellJ)
			for rNodesOfCellJ in range(nbNodesOfCellJ):
				self.l[jCells, rNodesOfCellJ] = self.__norm(self.C[jCells, rNodesOfCellJ])

	"""
	 Job computeV called @2.0 in executeTimeLoopN method.
	 In variables: C, X_n
	 Out variables: V
	"""
	def _computeV(self):
		for jCells in range(self.__nbCells):
			jId = jCells
			reduction0 = 0.0
			nodesOfCellJ = mesh.getNodesOfCell(jId)
			nbNodesOfCellJ = len(nodesOfCellJ)
			for rNodesOfCellJ in range(nbNodesOfCellJ):
				rId = nodesOfCellJ[rNodesOfCellJ]
				rNodes = rId
				reduction0 = self.__sumR0(reduction0, self.__dot(self.C[jCells, rNodesOfCellJ], self.X_n[rNodes]))
			self.V[jCells] = 0.5 * reduction0

	"""
	 Job initialize called @2.0 in simulate method.
	 In variables: Cjr_ic, X_n0, gamma, pIniZd, pIniZg, rhoIniZd, rhoIniZg, xInterface
	 Out variables: E_n, m, p, rho, uj_n
	"""
	def _initialize(self):
		for jCells in range(self.__nbCells):
			jId = jCells
			reduction0 = np.full((2), 0.0, dtype=np.double)
			nodesOfCellJ = mesh.getNodesOfCell(jId)
			nbNodesOfCellJ = len(nodesOfCellJ)
			for rNodesOfCellJ in range(nbNodesOfCellJ):
				rId = nodesOfCellJ[rNodesOfCellJ]
				rNodes = rId
				reduction0 = self.__sumR1(reduction0, self.X_n0[rNodes])
			center = self.__operatorMult(0.25, reduction0)
			if center[0] < self.xInterface:
				rho_ic = self.rhoIniZg
				p_ic = self.pIniZg
			else:
				rho_ic = self.rhoIniZd
				p_ic = self.pIniZd
			reduction1 = 0.0
			nodesOfCellJ = mesh.getNodesOfCell(jId)
			nbNodesOfCellJ = len(nodesOfCellJ)
			for rNodesOfCellJ in range(nbNodesOfCellJ):
				rId = nodesOfCellJ[rNodesOfCellJ]
				rNodes = rId
				reduction1 = self.__sumR0(reduction1, self.__dot(self.Cjr_ic[jCells, rNodesOfCellJ], self.X_n0[rNodes]))
			V_ic = 0.5 * reduction1
			self.m[jCells] = rho_ic * V_ic
			self.p[jCells] = p_ic
			self.rho[jCells] = rho_ic
			self.E_n[jCells] = p_ic / ((self.gamma - 1.0) * rho_ic)
			self.uj_n[jCells] = np.array([0.0, 0.0], dtype=np.double)

	"""
	 Job setUpTimeLoopN called @2.0 in simulate method.
	 In variables: X_n0, t_n0
	 Out variables: X_n, t_n
	"""
	def _setUpTimeLoopN(self):
		self.t_n = self.t_n0
		for i1Nodes in range(self.__nbNodes):
			for i1 in range(2):
				self.X_n[i1Nodes, i1] = self.X_n0[i1Nodes, i1]

	"""
	 Job computeDensity called @3.0 in executeTimeLoopN method.
	 In variables: V, m
	 Out variables: rho
	"""
	def _computeDensity(self):
		for jCells in range(self.__nbCells):
			self.rho[jCells] = self.m[jCells] / self.V[jCells]

	"""
	 Job executeTimeLoopN called @3.0 in simulate method.
	 In variables: E_n, X_n, lastDump, maxIterations, n, outputPeriod, stopTime, t_n, t_nplus1, uj_n
	 Out variables: E_nplus1, X_nplus1, t_nplus1, uj_nplus1
	"""
	def _executeTimeLoopN(self):
		self.n = 0
		self.t_n = 0.0
		self.deltat = 0.0
		continueLoop = True
		while continueLoop:
			self.n += 1
			print("START ITERATION n: %5d - t: %5.5f - deltat: %5.5f\n" % (self.n, self.t_n, self.deltat))
			if (self.n >= self.lastDump + self.outputPeriod):
				self.__dumpVariables(self.n)
		
			self._computeCjr() # @1.0
			self._computeInternalEnergy() # @1.0
			self._computeLjr() # @2.0
			self._computeV() # @2.0
			self._computeDensity() # @3.0
			self._computeEOSp() # @4.0
			self._computeEOSc() # @5.0
			self._computeAjr() # @6.0
			self._computedeltatj() # @6.0
			self._computeAr() # @7.0
			self._computeBr() # @7.0
			self._computeDt() # @7.0
			self._computeBoundaryConditions() # @8.0
			self._computeBt() # @8.0
			self._computeMt() # @8.0
			self._computeTn() # @8.0
			self._computeU() # @9.0
			self._computeFjr() # @10.0
			self._computeXn() # @10.0
			self._computeEn() # @11.0
			self._computeUn() # @11.0
		
			# Evaluate loop condition with variables at time n
			continueLoop = (self.t_nplus1 < self.stopTime  and  self.n + 1 < self.maxIterations)
		
			self.t_n = self.t_nplus1
			for i1Nodes in range(self.__nbNodes):
				for i1 in range(2):
					self.X_n[i1Nodes, i1] = self.X_nplus1[i1Nodes, i1]
			for i1Cells in range(self.__nbCells):
				self.E_n[i1Cells] = self.E_nplus1[i1Cells]
			for i1Cells in range(self.__nbCells):
				for i1 in range(2):
					self.uj_n[i1Cells, i1] = self.uj_nplus1[i1Cells, i1]
		
		print("FINAL TIME: %5.5f - deltat: %5.5f\n" % (self.t_n, self.deltat))
		self.__dumpVariables(self.n+1);

	"""
	 Job computeEOSp called @4.0 in executeTimeLoopN method.
	 In variables: e, gamma, rho
	 Out variables: p
	"""
	def _computeEOSp(self):
		for jCells in range(self.__nbCells):
			self.p[jCells] = (self.gamma - 1.0) * self.rho[jCells] * self.e[jCells]

	"""
	 Job computeEOSc called @5.0 in executeTimeLoopN method.
	 In variables: gamma, p, rho
	 Out variables: c
	"""
	def _computeEOSc(self):
		for jCells in range(self.__nbCells):
			self.c[jCells] = math.sqrt(self.gamma * self.p[jCells] / self.rho[jCells])

	"""
	 Job computeAjr called @6.0 in executeTimeLoopN method.
	 In variables: C, c, l, rho
	 Out variables: Ajr
	"""
	def _computeAjr(self):
		for jCells in range(self.__nbCells):
			jId = jCells
			nodesOfCellJ = mesh.getNodesOfCell(jId)
			nbNodesOfCellJ = len(nodesOfCellJ)
			for rNodesOfCellJ in range(nbNodesOfCellJ):
				self.Ajr[jCells, rNodesOfCellJ] = self.__operatorMult1(((self.rho[jCells] * self.c[jCells]) / self.l[jCells, rNodesOfCellJ]), self.__tensProduct(self.C[jCells, rNodesOfCellJ], self.C[jCells, rNodesOfCellJ]))

	"""
	 Job computedeltatj called @6.0 in executeTimeLoopN method.
	 In variables: V, c, l
	 Out variables: deltatj
	"""
	def _computedeltatj(self):
		for jCells in range(self.__nbCells):
			jId = jCells
			reduction0 = 0.0
			nodesOfCellJ = mesh.getNodesOfCell(jId)
			nbNodesOfCellJ = len(nodesOfCellJ)
			for rNodesOfCellJ in range(nbNodesOfCellJ):
				reduction0 = self.__sumR0(reduction0, self.l[jCells, rNodesOfCellJ])
			self.deltatj[jCells] = 2.0 * self.V[jCells] / (self.c[jCells] * reduction0)

	"""
	 Job computeAr called @7.0 in executeTimeLoopN method.
	 In variables: Ajr
	 Out variables: Ar
	"""
	def _computeAr(self):
		for rNodes in range(self.__nbNodes):
			rId = rNodes
			reduction0 = np.full((2, 2), 0.0, dtype=np.double)
			cellsOfNodeR = mesh.getCellsOfNode(rId)
			nbCellsOfNodeR = len(cellsOfNodeR)
			for jCellsOfNodeR in range(nbCellsOfNodeR):
				jId = cellsOfNodeR[jCellsOfNodeR]
				jCells = jId
				rNodesOfCellJ = mesh.getNodesOfCell(jId).tolist().index(rId)
				reduction0 = self.__sumR2(reduction0, self.Ajr[jCells, rNodesOfCellJ])
			for i1 in range(2):
				for i2 in range(2):
					self.Ar[rNodes, i1, i2] = reduction0[i1, i2]

	"""
	 Job computeBr called @7.0 in executeTimeLoopN method.
	 In variables: Ajr, C, p, uj_n
	 Out variables: b
	"""
	def _computeBr(self):
		for rNodes in range(self.__nbNodes):
			rId = rNodes
			reduction0 = np.full((2), 0.0, dtype=np.double)
			cellsOfNodeR = mesh.getCellsOfNode(rId)
			nbCellsOfNodeR = len(cellsOfNodeR)
			for jCellsOfNodeR in range(nbCellsOfNodeR):
				jId = cellsOfNodeR[jCellsOfNodeR]
				jCells = jId
				rNodesOfCellJ = mesh.getNodesOfCell(jId).tolist().index(rId)
				reduction0 = self.__sumR1(reduction0, self.__operatorAdd(self.__operatorMult(self.p[jCells], self.C[jCells, rNodesOfCellJ]), self.__matVectProduct(self.Ajr[jCells, rNodesOfCellJ], self.uj_n[jCells])))
			for i1 in range(2):
				self.b[rNodes, i1] = reduction0[i1]

	"""
	 Job computeDt called @7.0 in executeTimeLoopN method.
	 In variables: deltatCfl, deltatj, stopTime, t_n
	 Out variables: deltat
	"""
	def _computeDt(self):
		reduction0 = sys.float_info.max
		for jCells in range(self.__nbCells):
			reduction0 = self.__minR0(reduction0, self.deltatj[jCells])
		self.deltat = min((self.deltatCfl * reduction0), (self.stopTime - self.t_n))

	"""
	 Job computeBoundaryConditions called @8.0 in executeTimeLoopN method.
	 In variables: Ar, b
	 Out variables: Mt, bt
	"""
	def _computeBoundaryConditions(self):
		I = np.array([np.array([1.0, 0.0], dtype=np.double), np.array([0.0, 1.0], dtype=np.double)], dtype=np.double)
		topNodes = mesh.getGroup("TopNodes")
		for rTopNodes in range(self.__nbTopNodes):
			rId = topNodes[rTopNodes]
			rNodes = rId
			N = np.array([0.0, 1.0], dtype=np.double)
			NxN = self.__tensProduct(N, N)
			IcP = self.__operatorSub1(I, NxN)
			self.bt[rNodes] = self.__matVectProduct(IcP, self.b[rNodes])
			self.Mt[rNodes] = self.__operatorAdd1(self.__operatorMult2(IcP, (self.__operatorMult2(self.Ar[rNodes], IcP))), self.__operatorMult3(NxN, self.__trace(self.Ar[rNodes])))
		bottomNodes = mesh.getGroup("BottomNodes")
		for rBottomNodes in range(self.__nbBottomNodes):
			rId = bottomNodes[rBottomNodes]
			rNodes = rId
			N = np.array([0.0, -1.0], dtype=np.double)
			NxN = self.__tensProduct(N, N)
			IcP = self.__operatorSub1(I, NxN)
			self.bt[rNodes] = self.__matVectProduct(IcP, self.b[rNodes])
			self.Mt[rNodes] = self.__operatorAdd1(self.__operatorMult2(IcP, (self.__operatorMult2(self.Ar[rNodes], IcP))), self.__operatorMult3(NxN, self.__trace(self.Ar[rNodes])))
		leftNodes = mesh.getGroup("LeftNodes")
		for rLeftNodes in range(self.__nbLeftNodes):
			rId = leftNodes[rLeftNodes]
			rNodes = rId
			for i1 in range(2):
				for i2 in range(2):
					self.Mt[rNodes, i1, i2] = I[i1, i2]
			self.bt[rNodes] = np.array([0.0, 0.0], dtype=np.double)
		rightNodes = mesh.getGroup("RightNodes")
		for rRightNodes in range(self.__nbRightNodes):
			rId = rightNodes[rRightNodes]
			rNodes = rId
			for i1 in range(2):
				for i2 in range(2):
					self.Mt[rNodes, i1, i2] = I[i1, i2]
			self.bt[rNodes] = np.array([0.0, 0.0], dtype=np.double)

	"""
	 Job computeBt called @8.0 in executeTimeLoopN method.
	 In variables: b
	 Out variables: bt
	"""
	def _computeBt(self):
		innerNodes = mesh.getGroup("InnerNodes")
		for rInnerNodes in range(self.__nbInnerNodes):
			rId = innerNodes[rInnerNodes]
			rNodes = rId
			for i1 in range(2):
				self.bt[rNodes, i1] = self.b[rNodes, i1]

	"""
	 Job computeMt called @8.0 in executeTimeLoopN method.
	 In variables: Ar
	 Out variables: Mt
	"""
	def _computeMt(self):
		innerNodes = mesh.getGroup("InnerNodes")
		for rInnerNodes in range(self.__nbInnerNodes):
			rId = innerNodes[rInnerNodes]
			rNodes = rId
			for i1 in range(2):
				for i2 in range(2):
					self.Mt[rNodes, i1, i2] = self.Ar[rNodes, i1, i2]

	"""
	 Job computeTn called @8.0 in executeTimeLoopN method.
	 In variables: deltat, t_n
	 Out variables: t_nplus1
	"""
	def _computeTn(self):
		self.t_nplus1 = self.t_n + self.deltat

	"""
	 Job computeU called @9.0 in executeTimeLoopN method.
	 In variables: Mt, bt
	 Out variables: ur
	"""
	def _computeU(self):
		for rNodes in range(self.__nbNodes):
			self.ur[rNodes] = self.__matVectProduct(self.__inverse(self.Mt[rNodes]), self.bt[rNodes])

	"""
	 Job computeFjr called @10.0 in executeTimeLoopN method.
	 In variables: Ajr, C, p, uj_n, ur
	 Out variables: F
	"""
	def _computeFjr(self):
		for jCells in range(self.__nbCells):
			jId = jCells
			nodesOfCellJ = mesh.getNodesOfCell(jId)
			nbNodesOfCellJ = len(nodesOfCellJ)
			for rNodesOfCellJ in range(nbNodesOfCellJ):
				rId = nodesOfCellJ[rNodesOfCellJ]
				rNodes = rId
				self.F[jCells, rNodesOfCellJ] = self.__operatorAdd(self.__operatorMult(self.p[jCells], self.C[jCells, rNodesOfCellJ]), self.__matVectProduct(self.Ajr[jCells, rNodesOfCellJ], (self.__operatorSub(self.uj_n[jCells], self.ur[rNodes]))))

	"""
	 Job computeXn called @10.0 in executeTimeLoopN method.
	 In variables: X_n, deltat, ur
	 Out variables: X_nplus1
	"""
	def _computeXn(self):
		for rNodes in range(self.__nbNodes):
			self.X_nplus1[rNodes] = self.__operatorAdd(self.X_n[rNodes], self.__operatorMult(self.deltat, self.ur[rNodes]))

	"""
	 Job computeEn called @11.0 in executeTimeLoopN method.
	 In variables: E_n, F, deltat, m, ur
	 Out variables: E_nplus1
	"""
	def _computeEn(self):
		for jCells in range(self.__nbCells):
			jId = jCells
			reduction0 = 0.0
			nodesOfCellJ = mesh.getNodesOfCell(jId)
			nbNodesOfCellJ = len(nodesOfCellJ)
			for rNodesOfCellJ in range(nbNodesOfCellJ):
				rId = nodesOfCellJ[rNodesOfCellJ]
				rNodes = rId
				reduction0 = self.__sumR0(reduction0, self.__dot(self.F[jCells, rNodesOfCellJ], self.ur[rNodes]))
			self.E_nplus1[jCells] = self.E_n[jCells] - (self.deltat / self.m[jCells]) * reduction0

	"""
	 Job computeUn called @11.0 in executeTimeLoopN method.
	 In variables: F, deltat, m, uj_n
	 Out variables: uj_nplus1
	"""
	def _computeUn(self):
		for jCells in range(self.__nbCells):
			jId = jCells
			reduction0 = np.full((2), 0.0, dtype=np.double)
			nodesOfCellJ = mesh.getNodesOfCell(jId)
			nbNodesOfCellJ = len(nodesOfCellJ)
			for rNodesOfCellJ in range(nbNodesOfCellJ):
				reduction0 = self.__sumR1(reduction0, self.F[jCells, rNodesOfCellJ])
			self.uj_nplus1[jCells] = self.__operatorSub(self.uj_n[jCells], self.__operatorMult((self.deltat / self.m[jCells]), reduction0))

	def __det1(self, a):
		return a[0, 0] * a[1, 1] - a[0, 1] * a[1, 0]

	def __perp(self, a):
		return np.array([a[1], -a[0]], dtype=np.double)

	def __dot(self, a, b):
		result = 0.0
		for i in range(len(a)):
			result = result + a[i] * b[i]
		return result

	def __norm(self, a):
		return math.sqrt(self.__dot(a, a))

	def __tensProduct(self, a, b):
		result = np.empty((len(a), len(a)), dtype=np.double)
		for ia in range(len(a)):
			for ib in range(len(a)):
				result[ia, ib] = a[ia] * b[ib]
		return result

	def __matVectProduct(self, a, b):
		result = np.empty((len(a)), dtype=np.double)
		for ix in range(len(a)):
			tmp = np.empty((len(a[0])), dtype=np.double)
			for iy in range(len(a[0])):
				tmp[iy] = a[ix, iy]
			result[ix] = self.__dot(tmp, b)
		return result

	def __trace(self, a):
		result = 0.0
		for ia in range(len(a)):
			result = result + a[ia, ia]
		return result

	def __inverse(self, a):
		alpha = 1.0 / self.__det1(a)
		return np.array([np.array([a[1, 1] * alpha, -a[0, 1] * alpha], dtype=np.double), np.array([-a[1, 0] * alpha, a[0, 0] * alpha], dtype=np.double)], dtype=np.double)

	def __sumR1(self, a, b):
		return self.__operatorAdd(a, b)

	def __sumR0(self, a, b):
		return a + b

	def __sumR2(self, a, b):
		return self.__operatorAdd1(a, b)

	def __minR0(self, a, b):
		return min(a, b)

	def __operatorAdd(self, a, b):
		result = np.empty((len(a)), dtype=np.double)
		for ix0 in range(len(a)):
			result[ix0] = a[ix0] + b[ix0]
		return result

	def __operatorAdd1(self, a, b):
		result = np.empty((len(a), len(a[0])), dtype=np.double)
		for ix0 in range(len(a)):
			for ix1 in range(len(a[0])):
				result[ix0, ix1] = a[ix0, ix1] + b[ix0, ix1]
		return result

	def __operatorMult(self, a, b):
		result = np.empty((len(b)), dtype=np.double)
		for ix0 in range(len(b)):
			result[ix0] = a * b[ix0]
		return result

	def __operatorSub(self, a, b):
		result = np.empty((len(a)), dtype=np.double)
		for ix0 in range(len(a)):
			result[ix0] = a[ix0] - b[ix0]
		return result

	def __operatorMult1(self, a, b):
		result = np.empty((len(b), len(b[0])), dtype=np.double)
		for ix0 in range(len(b)):
			for ix1 in range(len(b[0])):
				result[ix0, ix1] = a * b[ix0, ix1]
		return result

	def __operatorSub1(self, a, b):
		result = np.empty((len(a), len(a[0])), dtype=np.double)
		for ix0 in range(len(a)):
			for ix1 in range(len(a[0])):
				result[ix0, ix1] = a[ix0, ix1] - b[ix0, ix1]
		return result

	def __operatorMult2(self, a, b):
		result = np.empty((len(a), len(a[0])), dtype=np.double)
		for ix0 in range(len(a)):
			for ix1 in range(len(a[0])):
				result[ix0, ix1] = a[ix0, ix1] * b[ix0, ix1]
		return result

	def __operatorMult3(self, a, b):
		result = np.empty((len(a), len(a[0])), dtype=np.double)
		for ix0 in range(len(a)):
			for ix1 in range(len(a[0])):
				result[ix0, ix1] = a[ix0, ix1] * b
		return result

	def simulate(self):
		print("Start execution of glace2d")
		self._iniCjrIc() # @1.0
		self._iniTime() # @1.0
		self._initialize() # @2.0
		self._setUpTimeLoopN() # @2.0
		self._executeTimeLoopN() # @3.0
		print("End of execution of glace2d")

	def __dumpVariables(self, iteration):
		if not self.__writer.disabled:
			quads = mesh.geometry.quads
			self.__writer.startVtpFile(iteration, self.t_n, self.X_n, quads)
			self.__writer.openNodeData()
			self.__writer.closeNodeData()
			self.__writer.openCellData()
			self.__writer.openCellArray("Density", 0);
			for i in range(self.__nbCells):
				self.__writer.write(self.rho[i])
			self.__writer.closeCellArray()
			self.__writer.closeCellData()
			self.__writer.closeVtpFile()
			self.lastDump = self.n

if __name__ == '__main__':
	args = sys.argv[1:]
	
	if len(args) == 1:
		f = open(args[0])
		data = json.load(f)
		f.close()

		# Mesh instanciation
		mesh = CartesianMesh2D()
		mesh.jsonInit(data["mesh"])

		# Module instanciation
		glace2d = Glace2d(mesh)
		glace2d.jsonInit(data["glace2d"])

		# Start simulation
		glace2d.simulate()
	else:
		print("[ERROR] Wrong number of arguments: expected 1, actual " + str(len(args)), file=sys.stderr)
		print("        Expecting user data file name, for example Glace2d.json", file=sys.stderr)
		exit(1)