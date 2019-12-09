#include "toto.h"

// ********************************************************
// * perp fct
// ********************************************************
static inline Real3 perp(Real3 greek_alpha , Real3 greek_beta ){return Real3(opSub(greek_beta.y,greek_alpha.y),opAdd(-greek_beta.x,greek_alpha.x),0.0);
}

// ********************************************************
// * trace fct
// ********************************************************
static inline Real trace(Real3x3 M ){return opAdd(opAdd(M.x.x,M.y.y),M.z.z);
}

// ********************************************************
// * kernelFzP5tM job
// ********************************************************
static inline void kernelFzP5tM(const int NABLA_NB_NODES_WARP, const int NABLA_NB_NODES,real3* node_X_ic,real3* node_coord){/*xHookForAllPrefix*/FOR_EACH_NODE_WARP(n){{
		node_X_ic/*NodeVar !20*/[n]/*'='->!isLeft*/=node_coord/*NodeVar !20*/[n];
		}}
}

// ********************************************************
// * Init_t fct
// ********************************************************
static inline void Init_t(real* global_t){/*StdJob*//*GlobalVar*/global_t[0]=0.0;
}

// ********************************************************
// * Init_greek_deltat fct
// ********************************************************
static inline void Init_greek_deltat(real* global_greek_deltat){/*StdJob*//*GlobalVar*/global_greek_deltat[0]=0.0;
}

// ********************************************************
// * IniCenter job
// ********************************************************
static inline void IniCenter(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real3* node_X_ic,real3* cell_center/*isInXS(X_ic)(c,n,0,"",0)?*//*new XS:c->n0*/, const int* xs_cell_node){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){/* 'X_ic:k(0)' is gathered but NOT used InThisForall! */{
		/*Real3*/real3 Sum957dad8 /*'='->!isLeft*/=0 ;
		/*chsf n*/for(int n=0;n<NABLA_NODE_PER_CELL;++n)/*FORALL_INI*/{
			/* 'X_ic:k(0)' is gathered and IS used InThisForall! *//*xCallFilterGather*/
/*const real3*/ real2 gathered_node_X_ic=rgather3k(xs_cell_node[n*NABLA_NB_CELLS+(c<<WARP_BIT)],node_X_ic);
			{
		Sum957dad8 +=/*gathered variable!*/gathered_node_X_ic;
		}/*xCallFilterScatter*//*FORALL_END*/
		}
	cell_center[c]/*'='->!isLeft*/=opMul ( ( opDiv ( 1.0 , 4.0 ) ) , Sum957dad8 ) ;
		}}
}

// ********************************************************
// * ComputeCjrIc job
// ********************************************************
static inline void ComputeCjrIc(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real3* cell_C_ic,real3* node_X_ic/*isInXS(X_ic)(c,n,0,"",0)?*//*new XS:c->n0*/, const int* xs_cell_node/*isInXS(X_ic)(c,n,0,"cn0",1)?*/){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){/* 'X_ic:k(-1)' is gathered but NOT used InThisForall! *//* 'X_ic:k(1)' is gathered but NOT used InThisForall! */{
		/*chsf n*/for(int n=0;n<NABLA_NODE_PER_CELL;++n)/*FORALL_INI*/{
			/* 'X_ic:k(-1)' is gathered and IS used InThisForall! *//* 'X_ic:k(1)' is gathered and IS used InThisForall! *//*xCallFilterGather*/
/*const real3*/ real2 gathered_node_X_ic_ffffffff=rgather3k(xs_cell_node[((n+NABLA_NODE_PER_CELL+(-1))%NABLA_NODE_PER_CELL)*NABLA_NB_CELLS+(c<<WARP_BIT)],node_X_ic);
			/*const real3*/ real2 gathered_node_X_ic_01=rgather3k(xs_cell_node[((n+NABLA_NODE_PER_CELL+(1))%NABLA_NODE_PER_CELL)*NABLA_NB_CELLS+(c<<WARP_BIT)],node_X_ic);
			{
		cell_C_ic[n+NABLA_NODE_PER_CELL*c]/*'='->!isLeft*/=opMul ( 0.5 , /*JOB_CALL*//*got_call*//*isNablaFunction*/perp ( /*gathered variable!*/gathered_node_X_ic_ffffffff, /*gathered variable!*/gathered_node_X_ic_01/*ARGS*//*got_args*/) ) ;
		/*!function_call_arguments*/}/*xCallFilterScatter*//*FORALL_END*/
		}
	}}
}

// ********************************************************
// * Init_ComputeXn job
// ********************************************************
static inline void Init_ComputeXn(const int NABLA_NB_NODES_WARP, const int NABLA_NB_NODES,real3* node_X,real3* node_X_ic){/*xHookForAllPrefix*/FOR_EACH_NODE_WARP(n){{
		node_X/*NodeVar !20*/[n]/*'='->!isLeft*/=node_X_ic/*NodeVar !20*/[n];
		}}
}

// ********************************************************
// * Init_ComputeUn job
// ********************************************************
static inline void Init_ComputeUn(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real3* cell_u){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){{
		cell_u[c]/*'='->!isLeft*/=/*Real3*/real3 ( 0.0 , 0.0 , 0.0 ) ;
		}}
}

// ********************************************************
// * Init_Min6f4a6c1c fct
// ********************************************************
static inline void Init_Min6f4a6c1c(real* global_Min6f4a6c1c){/*StdJob*//*GlobalVar*/global_Min6f4a6c1c[0]=__builtin_inff();
}

// ********************************************************
// * Init_ComputeDt fct
// ********************************************************
static inline void Init_ComputeDt(real* global_greek_deltat){/*StdJob*//*GlobalVar*/global_greek_deltat[0]=/*tt2o*/option_greek_deltat_ini;
}

// ********************************************************
// * Init_ComputeTn fct
// ********************************************************
static inline void Init_ComputeTn(real* global_t){/*StdJob*//*GlobalVar*/global_t[0]=0.0;
}

// ********************************************************
// * IniIc job
// ********************************************************
static inline void IniIc(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real3* cell_center,real* cell_greek_rho_ic,real* cell_p_ic){/*xHookForAllPrefix*/FOR_EACH_CELL(c){{
		if ( cell_center[c]/*hookTurnBracketsToParentheses_X*/. x < /*tt2o*/option_x_interface) {
		cell_greek_rho_ic[c]/*'='->!isLeft*/=/*tt2o*/option_greek_rho_ini_zg;
		cell_p_ic[c]/*'='->!isLeft*/=/*tt2o*/option_p_ini_zg;
		}else {
		cell_greek_rho_ic[c]/*'='->!isLeft*/=/*tt2o*/option_greek_rho_ini_zd;
		cell_p_ic[c]/*'='->!isLeft*/=/*tt2o*/option_p_ini_zd;
		}}}
}

// ********************************************************
// * IniVIc job
// ********************************************************
static inline void IniVIc(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real3* cell_C_ic,real3* node_X_ic,real* cell_V_ic/*isInXS(X_ic)(c,n,0,"",0)?*//*new XS:c->n0*/, const int* xs_cell_node){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){/* 'X_ic:k(0)' is gathered but NOT used InThisForall! */{
		/*Real*/real Sum49fbd39 /*'='->!isLeft*/=0 ;
		/*chsf n*/for(int n=0;n<NABLA_NODE_PER_CELL;++n)/*FORALL_INI*/{
			/* 'X_ic:k(0)' is gathered and IS used InThisForall! *//*xCallFilterGather*/
/*const real3*/ real2 gathered_node_X_ic=rgather3k(xs_cell_node[n*NABLA_NB_CELLS+(c<<WARP_BIT)],node_X_ic);
			{
		Sum49fbd39 +=/*JOB_CALL*//*got_call*//*has not been found*/dot ( cell_C_ic[n+NABLA_NODE_PER_CELL*c], /*gathered variable!*/gathered_node_X_ic/*ARGS*//*got_args*/) ;
		/*!function_call_arguments*/}/*xCallFilterScatter*//*FORALL_END*/
		}
	cell_V_ic[c]/*'='->!isLeft*/=opMul ( 0.5 , Sum49fbd39 ) ;
		}}
}

// ********************************************************
// * IniM job
// ********************************************************
static inline void IniM(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real* cell_m,real* cell_greek_rho_ic,real* cell_V_ic){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){{
		cell_m[c]/*'='->!isLeft*/=opMul ( cell_greek_rho_ic[c], cell_V_ic[c]) ;
		}}
}

// ********************************************************
// * Init_ComputeEn job
// ********************************************************
static inline void Init_ComputeEn(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real* cell_E,real* cell_p_ic,real* cell_greek_rho_ic){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){{
		/*JOB_CALL*//*got_call*//*has not been found*/assert ( /*tt2o*/greek_gamma!= 0.0 /*ARGS*//*got_args*/) ;
		/*!function_call_arguments*/cell_E[c]/*'='->!isLeft*/=opDiv ( cell_p_ic[c], ( opMul ( ( opSub ( /*tt2o*/greek_gamma, 1.0 ) ) , cell_greek_rho_ic[c]) ) ) ;
		}}
}

// ********************************************************
// * computeLoop fct
// ********************************************************
static inline void computeLoop(int* global_iteration,double* global_time){/*function_got_call*//*xHookAddCallNames*//*has not been found*/printf("\n[37m[#%d] %f[0m",/*ITERATION*/global_iteration[0],/*TIME*/global_time[0]);
}

// ********************************************************
// * ComputeCjr job
// ********************************************************
static inline void ComputeCjr(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real3* cell_C,real3* node_X/*isInXS(X)(c,n,0,"",0)?*//*new XS:c->n0*/, const int* xs_cell_node/*isInXS(X)(c,n,0,"cn0",1)?*/){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){/* 'X:k(-1)' is gathered but NOT used InThisForall! *//* 'X:k(1)' is gathered but NOT used InThisForall! */{
		/*chsf n*/for(int n=0;n<NABLA_NODE_PER_CELL;++n)/*FORALL_INI*/{
			/* 'X:k(-1)' is gathered and IS used InThisForall! *//* 'X:k(1)' is gathered and IS used InThisForall! *//*xCallFilterGather*/
/*const real3*/ real2 gathered_node_X_ffffffff=rgather3k(xs_cell_node[((n+NABLA_NODE_PER_CELL+(-1))%NABLA_NODE_PER_CELL)*NABLA_NB_CELLS+(c<<WARP_BIT)],node_X);
			/*const real3*/ real2 gathered_node_X_01=rgather3k(xs_cell_node[((n+NABLA_NODE_PER_CELL+(1))%NABLA_NODE_PER_CELL)*NABLA_NB_CELLS+(c<<WARP_BIT)],node_X);
			{
		cell_C[n+NABLA_NODE_PER_CELL*c]/*'='->!isLeft*/=opMul ( 0.5 , /*JOB_CALL*//*got_call*//*isNablaFunction*/perp ( /*gathered variable!*/gathered_node_X_ffffffff, /*gathered variable!*/gathered_node_X_01/*ARGS*//*got_args*/) ) ;
		/*!function_call_arguments*/}/*xCallFilterScatter*//*FORALL_END*/
		}
	}}
}

// ********************************************************
// * ComputeInternalEngergy job
// ********************************************************
static inline void ComputeInternalEngergy(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real* cell_e,real* cell_E,real3* cell_u){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){{
		cell_e[c]/*'='->!isLeft*/=opSub ( cell_E[c], opMul ( 0.5 , /*JOB_CALL*//*got_call*//*has not been found*/dot ( cell_u[c], cell_u[c]/*ARGS*//*got_args*/) ) ) ;
		/*!function_call_arguments*/}}
}

// ********************************************************
// * ComputeAbsjr job
// ********************************************************
static inline void ComputeAbsjr(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real* cell_absC,real3* cell_C){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){{
		/*chsf n*/for(int n=0;n<NABLA_NODE_PER_CELL;++n)/*FORALL_INI*/{
			/*xCallFilterGather*/
{
		cell_absC[n+NABLA_NODE_PER_CELL*c]/*'='->!isLeft*/=/*JOB_CALL*//*got_call*//*has not been found*/norm ( cell_C[n+NABLA_NODE_PER_CELL*c]/*ARGS*//*got_args*/) ;
		/*!function_call_arguments*/}/*xCallFilterScatter*//*FORALL_END*/
		}
	}}
}

// ********************************************************
// * ComputeV job
// ********************************************************
static inline void ComputeV(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real3* cell_C,real3* node_X,real* cell_V/*isInXS(X)(c,n,0,"",0)?*//*new XS:c->n0*/, const int* xs_cell_node){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){/* 'X:k(0)' is gathered but NOT used InThisForall! */{
		/*Real*/real Sum4da90722 /*'='->!isLeft*/=0 ;
		/*chsf n*/for(int n=0;n<NABLA_NODE_PER_CELL;++n)/*FORALL_INI*/{
			/* 'X:k(0)' is gathered and IS used InThisForall! *//*xCallFilterGather*/
/*const real3*/ real2 gathered_node_X=rgather3k(xs_cell_node[n*NABLA_NB_CELLS+(c<<WARP_BIT)],node_X);
			{
		Sum4da90722 +=/*JOB_CALL*//*got_call*//*has not been found*/dot ( cell_C[n+NABLA_NODE_PER_CELL*c], /*gathered variable!*/gathered_node_X/*ARGS*//*got_args*/) ;
		/*!function_call_arguments*/}/*xCallFilterScatter*//*FORALL_END*/
		}
	cell_V[c]/*'='->!isLeft*/=opMul ( 0.5 , Sum4da90722 ) ;
		}}
}

// ********************************************************
// * ComputeDensity job
// ********************************************************
static inline void ComputeDensity(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real* cell_greek_rho,real* cell_m,real* cell_V){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){{
		cell_greek_rho[c]/*'='->!isLeft*/=opDiv ( cell_m[c], cell_V[c]) ;
		}}
}

// ********************************************************
// * ComputeEOSp job
// ********************************************************
static inline void ComputeEOSp(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real* cell_p,real* cell_greek_rho,real* cell_e){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){{
		cell_p[c]/*'='->!isLeft*/=opMul ( opMul ( ( opSub ( /*tt2o*/greek_gamma, 1.0 ) ) , cell_greek_rho[c]) , cell_e[c]) ;
		}}
}

// ********************************************************
// * ComputeEOSc job
// ********************************************************
static inline void ComputeEOSc(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real* cell_c,real* cell_p,real* cell_greek_rho){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){{
		cell_c[c]/*'='->!isLeft*/=/*JOB_CALL*//*got_call*//*has not been found*/sqrt ( opDiv ( opMul ( /*tt2o*/greek_gamma, cell_p[c]) , cell_greek_rho[c]) /*ARGS*//*got_args*/) ;
		/*!function_call_arguments*/}}
}

// ********************************************************
// * Computegreek_deltatj job
// ********************************************************
static inline void Computegreek_deltatj(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real* cell_absC,real* cell_greek_deltatj,real* cell_V,real* cell_c){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){{
		/*Real*/real Sum369f5f84 /*'='->!isLeft*/=0 ;
		/*chsf n*/for(int n=0;n<NABLA_NODE_PER_CELL;++n)/*FORALL_INI*/{
			/*xCallFilterGather*/
{
		Sum369f5f84 +=cell_absC[n+NABLA_NODE_PER_CELL*c];
		}/*xCallFilterScatter*//*FORALL_END*/
		}
	cell_greek_deltatj[c]/*'='->!isLeft*/=opDiv ( opMul ( 2.0 , cell_V[c]) , ( opMul ( cell_c[c], Sum369f5f84 ) ) ) ;
		}}
}

// ********************************************************
// * ComputeAjr job
// ********************************************************
static inline void ComputeAjr(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real3x3* cell_A,real* cell_greek_rho,real* cell_c,real* cell_absC,real3* cell_C){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){{
		/*chsf n*/for(int n=0;n<NABLA_NODE_PER_CELL;++n)/*FORALL_INI*/{
			/*xCallFilterGather*/
cell_A[n+NABLA_NODE_PER_CELL*c]/*'='->!isLeft*/=opMul ( ( opDiv ( ( opMul ( cell_greek_rho[c], cell_c[c]) ) , cell_absC[n+NABLA_NODE_PER_CELL*c]) ) , /*JOB_CALL*//*got_call*//*has not been found*/opProdTens ( cell_C[n+NABLA_NODE_PER_CELL*c], cell_C[n+NABLA_NODE_PER_CELL*c]/*ARGS*//*got_args*/) ) ;
		/*!function_call_arguments*//*xCallFilterScatter*//*FORALL_END*/
		}
	}}
}

// ********************************************************
// * ComputeMr job
// ********************************************************
static inline void ComputeMr(const int NABLA_NB_NODES_WARP, const int NABLA_NB_NODES,real3x3* cell_A,real3x3* node_M/*isInXS(A)(n,c,1,"",0)?*//*new XS:n->c1*/, const int* xs_node_cell, const int* xs_node_cell_corner){/*xHookForAllPrefix*/FOR_EACH_NODE_WARP(n){/* 'A:k(0)' is gathered but NOT used InThisForall! */{
		Real3x3 Sum17c4ec2b /*'='->!isLeft*/=/*Real3*/real3 ( 0.0 , 0.0 , 1.0 ) ;
		/*n_foreach_c*/FOR_EACH_NODE_CELL(c)/*FORALL_INI*/{
			/* 'A:k(0)' is gathered and IS used InThisForall! *//*xCallFilterGather*/
real3x3 gathered_cell_A=rGatherAndZeroNegOnes(xs_node_cell[NABLA_NODE_PER_CELL*(n<<WARP_BIT)+c],xs_node_cell_corner[NABLA_NODE_PER_CELL*(n<<WARP_BIT)+c], cell_A);
			{
		Sum17c4ec2b +=/*gathered variable!*/gathered_cell_A;
		}/*xCallFilterScatter*//*FORALL_END*/
		}
	node_M/*NodeVar !20*/[n]/*'='->!isLeft*/=Sum17c4ec2b ;
		}}
}

// ********************************************************
// * ComputeBr job
// ********************************************************
static inline void ComputeBr(const int NABLA_NB_NODES_WARP, const int NABLA_NB_NODES,real3* cell_C,real* cell_p,real3x3* cell_A,real3* cell_u,real3* node_b/*isInXS(C)(n,c,1,"",0)?*//*new XS:n->c1*/, const int* xs_node_cell, const int* xs_node_cell_corner/*isInXS(p)(n,c,0,"nc1",1)?*//*new XS:n->c0*//*isInXS(A)(n,c,1,"nc1nc0",2)?*//*isInXS(u)(n,c,0,"nc1nc0",2)?*/){/*xHookForAllPrefix*/FOR_EACH_NODE_WARP(n){/* 'C:k(0)' is gathered but NOT used InThisForall! *//* 'p:k(0)' is gathered but NOT used InThisForall! *//* 'A:k(0)' is gathered but NOT used InThisForall! *//* 'u:k(0)' is gathered but NOT used InThisForall! */{
		/*Real3*/real3 Sum3f9840de /*'='->!isLeft*/=0 ;
		/*n_foreach_c*/FOR_EACH_NODE_CELL(c)/*FORALL_INI*/{
			/* 'C:k(0)' is gathered and IS used InThisForall! *//* 'p:k(0)' is gathered and IS used InThisForall! *//* 'A:k(0)' is gathered and IS used InThisForall! *//* 'u:k(0)' is gathered and IS used InThisForall! *//*xCallFilterGather*/
real2 gathered_cell_C=rGatherAndZeroNegOnes(xs_node_cell[NABLA_NODE_PER_CELL*(n<<WARP_BIT)+c],xs_node_cell_corner[NABLA_NODE_PER_CELL*(n<<WARP_BIT)+c], cell_C);
			real gathered_cell_p=rGatherAndZeroNegOnes(xs_node_cell[NABLA_NODE_PER_CELL*(n<<WARP_BIT)+c], cell_p);
			real3x3 gathered_cell_A=rGatherAndZeroNegOnes(xs_node_cell[NABLA_NODE_PER_CELL*(n<<WARP_BIT)+c],xs_node_cell_corner[NABLA_NODE_PER_CELL*(n<<WARP_BIT)+c], cell_A);
			real2 gathered_cell_u=rGatherAndZeroNegOnes(xs_node_cell[NABLA_NODE_PER_CELL*(n<<WARP_BIT)+c], cell_u);
			{
		Sum3f9840de +=opAdd ( opMul ( /*gathered variable!*/gathered_cell_C, /*gathered variable!*/gathered_cell_p) , /*JOB_CALL*//*got_call*//*has not been found*/opProdTensVec ( /*gathered variable!*/gathered_cell_A, /*gathered variable!*/gathered_cell_u/*ARGS*//*got_args*/) ) ;
		/*!function_call_arguments*/}/*xCallFilterScatter*//*FORALL_END*/
		}
	node_b/*NodeVar !20*/[n]/*'='->!isLeft*/=Sum3f9840de ;
		}}
}

// ******************************************************************************
// * Kernel de reduction de la variable 'greek_deltatj' vers la globale 'Min6f4a6c1c'
// ******************************************************************************
void reduction_Min6f4a6c1c_at_0(const int NABLA_NB_CELLS_WARP, const int NABLA_NB_CELLS,real* __restrict__ global_Min6f4a6c1c,const real* __restrict__ cell_greek_deltatj){ // @  ( 
	const double reduction_init=1.000000e+020;
	const int threads = omp_get_max_threads();
#if not defined(__APPLE__) and defined(__STDC_NO_THREADS__)
	real *Min6f4a6c1c_per_thread=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*threads);
#else
	real Min6f4a6c1c_per_thread[threads];
#endif
	// GCC OK, not CLANG real %s_per_thread[threads];
	for (int i=0; i<threads;i+=1) Min6f4a6c1c_per_thread[i] = reduction_init;
	FOR_EACH_CELL_WARP_SHARED(c,reduction_init){
		const int tid = omp_get_thread_num();
		Min6f4a6c1c_per_thread[tid] = min(cell_greek_deltatj[c],Min6f4a6c1c_per_thread[tid]);
	}
	global_Min6f4a6c1c[0]=reduction_init;
	for (int i=0; i<threads; i+=1){
		const Real real_global_Min6f4a6c1c=global_Min6f4a6c1c[0];
		global_Min6f4a6c1c[0]=(ReduceMinToDouble(Min6f4a6c1c_per_thread[i])<ReduceMinToDouble(real_global_Min6f4a6c1c))?
									ReduceMinToDouble(Min6f4a6c1c_per_thread[i]):ReduceMinToDouble(real_global_Min6f4a6c1c);
	}
#if not defined(__APPLE__) and defined(__STDC_NO_THREADS__)
	delete [] Min6f4a6c1c_per_thread;
#endif
}


// ********************************************************
// * ComputeMt job
// ********************************************************
static inline void ComputeMt(const int NABLA_NB_NODES_WARP, const int NABLA_NB_NODES,real3x3* node_Mt,real3x3* node_M){/*xHookForAllPrefix*/
#warning Should be INNER nodes
	FOR_EACH_NODE_WARP(n){{
		node_Mt/*NodeVar !20*/[n]/*'='->!isLeft*/=node_M/*NodeVar !20*/[n];
		}}
}

// ********************************************************
// * ComputeBt job
// ********************************************************
static inline void ComputeBt(const int NABLA_NB_NODES_WARP, const int NABLA_NB_NODES,real3* node_bt,real3* node_b){/*xHookForAllPrefix*/
#warning Should be INNER nodes
	FOR_EACH_NODE_WARP(n){{
		node_bt/*NodeVar !20*/[n]/*'='->!isLeft*/=node_b/*NodeVar !20*/[n];
		}}
}

// ********************************************************
// * YOuterFacesComputations job
// ********************************************************
static inline void YOuterFacesComputations(const int NABLA_NB_FACES, const int NABLA_NB_FACES_INNER, const int NABLA_NB_FACES_OUTER,real3* node_X,real3* node_bt,real3* node_b,real3x3* node_Mt,real3x3* node_M/*isInXS(X)(f,n,0,"",0)?*//*new XS:f->n0*/, const int* xs_face_node/*isInXS(bt)(f,n,0,"fn0",1)?*//*isInXS(b)(f,n,0,"fn0",1)?*//*isInXS(Mt)(f,n,0,"fn0",1)?*//*isInXS(M)(f,n,0,"fn0",1)?*/){/*xHookForAllPrefix*/FOR_EACH_OUTER_FACE(f){/* 'X:k(0)' is gathered but NOT used InThisForall! *//* 'bt:k(0)' is gathered but NOT used InThisForall! *//* 'b:k(0)' is gathered but NOT used InThisForall! *//* 'Mt:k(0)' is gathered but NOT used InThisForall! *//* 'M:k(0)' is gathered but NOT used InThisForall! */{
		/*Real*/real Y_MIN /*'='->!isLeft*/=0.0 ;
		/*Real*/real Y_MAX /*'='->!isLeft*/=/*tt2o*/LENGTH;
		Real3x3 I /*'='->!isLeft*/=matrix3x3Id ( ) ;
		/*Real3*/real3 nY /*'='->!isLeft*/={
		0.0 , 1.0 , 0.0 };
		/*chsf n*/for(int n=0;n<NABLA_NODE_PER_FACE;++n)/*FORALL_INI*/{
			/* 'X:k(0)' is gathered and IS used InThisForall! *//* 'bt:k(0)' is gathered and IS used InThisForall! *//* 'b:k(0)' is gathered and IS used InThisForall! *//* 'Mt:k(0)' is gathered and IS used InThisForall! *//* 'M:k(0)' is gathered and IS used InThisForall! *//*xCallFilterGather*/
real2 gathered_node_X=rGatherAndZeroNegOnes(xs_face_node[NABLA_NB_FACES*(n<<WARP_BIT)+f], node_X);
			real2 gathered_node_bt=rGatherAndZeroNegOnes(xs_face_node[NABLA_NB_FACES*(n<<WARP_BIT)+f], node_bt);
			real2 gathered_node_b=rGatherAndZeroNegOnes(xs_face_node[NABLA_NB_FACES*(n<<WARP_BIT)+f], node_b);
			real3x3 gathered_node_Mt=rGatherAndZeroNegOnes(xs_face_node[NABLA_NB_FACES*(n<<WARP_BIT)+f], node_Mt);
			real3x3 gathered_node_M=rGatherAndZeroNegOnes(xs_face_node[NABLA_NB_FACES*(n<<WARP_BIT)+f], node_M);
			{
		if ( ( /*gathered variable!*/gathered_node_X. y == Y_MIN ) || ( /*gathered variable!*/gathered_node_X. y == Y_MAX ) ) {
		/*Real*/real sign /*'='->!isLeft*/=opTernary ( ( /*gathered variable!*/gathered_node_X. y == Y_MIN ) , - 1.0 , 1.0 ) ;
		/*Real3*/real3 n /*'='->!isLeft*/=opMul ( sign , nY ) ;
		Real3x3 nxn /*'='->!isLeft*/=/*JOB_CALL*//*got_call*//*has not been found*/opProdTens ( n , n /*ARGS*//*got_args*/) ;
		/*!function_call_arguments*/Real3x3 IcP /*'='->!isLeft*/=opSub ( I , nxn ) ;
		/*gathered variable!*/gathered_node_bt/*'='->!isLeft*/=/*JOB_CALL*//*got_call*//*has not been found*/opProdTensVec ( IcP , /*gathered variable!*/gathered_node_b/*ARGS*//*got_args*/) ;
		/*!function_call_arguments*//*gathered variable!*/gathered_node_Mt/*'='->!isLeft*/=opAdd ( opMul ( IcP , ( opMul ( /*gathered variable!*/gathered_node_M, IcP ) ) ) , opMul ( nxn , /*JOB_CALL*//*got_call*//*isNablaFunction*/trace ( /*gathered variable!*/gathered_node_Mt/*ARGS*//*got_args*/) ) ) ;
		/*!function_call_arguments*/}}/*xCallFilterScatter*/
		scatter3k(xs_face_node[NABLA_NB_FACES*(n<<WARP_BIT)+f], &gathered_node_bt,  node_bt);
			
		scatter3x3k(xs_face_node[NABLA_NB_FACES*(n<<WARP_BIT)+f], &gathered_node_Mt,  node_Mt);
			/*FORALL_END*/
		}
	}}
}

// ********************************************************
// * XOuterFacesComputations job
// ********************************************************
static inline void XOuterFacesComputations(const int NABLA_NB_FACES, const int NABLA_NB_FACES_INNER, const int NABLA_NB_FACES_OUTER,real3* node_X,real3x3* node_Mt,real3* node_bt/*isInXS(X)(f,n,0,"",0)?*//*new XS:f->n0*/, const int* xs_face_node/*isInXS(Mt)(f,n,0,"fn0",1)?*//*isInXS(bt)(f,n,0,"fn0",1)?*/){/*xHookForAllPrefix*/FOR_EACH_OUTER_FACE(f){/* 'X:k(0)' is gathered but NOT used InThisForall! *//* 'Mt:k(0)' is gathered but NOT used InThisForall! *//* 'bt:k(0)' is gathered but NOT used InThisForall! */{
		/*Real*/real X_MIN /*'='->!isLeft*/=0.0 ;
		/*Real*/real X_MAX /*'='->!isLeft*/=/*tt2o*/LENGTH;
		Real3x3 I /*'='->!isLeft*/=matrix3x3Id ( ) ;
		/*chsf n*/for(int n=0;n<NABLA_NODE_PER_FACE;++n)/*FORALL_INI*/{
			/* 'X:k(0)' is gathered and IS used InThisForall! *//* 'Mt:k(0)' is gathered and IS used InThisForall! *//* 'bt:k(0)' is gathered and IS used InThisForall! *//*xCallFilterGather*/
real2 gathered_node_X=rGatherAndZeroNegOnes(xs_face_node[NABLA_NB_FACES*(n<<WARP_BIT)+f], node_X);
			real3x3 gathered_node_Mt=rGatherAndZeroNegOnes(xs_face_node[NABLA_NB_FACES*(n<<WARP_BIT)+f], node_Mt);
			real2 gathered_node_bt=rGatherAndZeroNegOnes(xs_face_node[NABLA_NB_FACES*(n<<WARP_BIT)+f], node_bt);
			{
		if ( ! ( ( /*JOB_CALL*//*got_call*//*has not been found*/fabs ( opSub ( /*gathered variable!*/gathered_node_X. x , X_MIN ) /*ARGS*//*got_args*/) < 1.e-10 ) || ( ( /*JOB_CALL*//*got_call*//*has not been found*/fabs ( opSub ( /*gathered variable!*/gathered_node_X. x , X_MAX ) /*ARGS*//*got_args*/) < 1.e-10 ) ) ) ) continue ;
		/*!function_call_arguments*//*gathered variable!*/gathered_node_Mt/*'='->!isLeft*/=I ;
		/*gathered variable!*/gathered_node_bt/*'='->!isLeft*/=/*Real3*/real3 ( 0.0 , 0.0 , 0.0 ) ;
		}/*xCallFilterScatter*/
		scatter3x3k(xs_face_node[NABLA_NB_FACES*(n<<WARP_BIT)+f], &gathered_node_Mt,  node_Mt);
			
		scatter3k(xs_face_node[NABLA_NB_FACES*(n<<WARP_BIT)+f], &gathered_node_bt,  node_bt);
			/*FORALL_END*/
		}
	}}
}

// ********************************************************
// * Compute_ComputeDt fct
// ********************************************************
static inline void Compute_ComputeDt(real* global_greek_deltat_n_plus_1,real* global_Min6f4a6c1c){/*StdJob*//*GlobalVar*/global_greek_deltat_n_plus_1[0]=opMul(/*tt2o*/option_greek_deltat_cfl,/*StdJob*//*GlobalVar*/global_Min6f4a6c1c[0]);
}

// ********************************************************
// * Copygreek_deltat_n_plus_1 fct
// ********************************************************
static inline void Copygreek_deltat_n_plus_1(real* global_greek_deltat,real* global_greek_deltat_n_plus_1){/*StdJob*//*GlobalVar*/global_greek_deltat[0]=/*StdJob*//*GlobalVar*/global_greek_deltat_n_plus_1[0];
}

// ********************************************************
// * ComputeU job
// ********************************************************
static inline void ComputeU(const int NABLA_NB_NODES_WARP, const int NABLA_NB_NODES,real3x3* node_Mt,real3* node_fu,real3* node_bt){/*xHookForAllPrefix*/FOR_EACH_NODE_WARP(n){{
		/*Real*/real det /*'='->!isLeft*/=/*JOB_CALL*//*got_call*//*has not been found*/matrixDeterminant ( node_Mt/*NodeVar !20*/[n]/*ARGS*//*got_args*/) ;
		/*!function_call_arguments*//*JOB_CALL*//*got_call*//*has not been found*/assert ( det != 0.0 /*ARGS*//*got_args*/) ;
		/*!function_call_arguments*/node_fu/*NodeVar !20*/[n]/*'='->!isLeft*/=/*JOB_CALL*//*got_call*//*has not been found*/opProdTensVec ( /*JOB_CALL*//*got_call*//*has not been found*/inverseMatrix ( node_Mt/*NodeVar !20*/[n], det /*ARGS*//*got_args*/) , node_bt/*NodeVar !20*/[n]/*ARGS*//*got_args*/) ;
		/*!function_call_arguments*/}}
}

// ********************************************************
// * Compute_ComputeTn fct
// ********************************************************
static inline void Compute_ComputeTn(real* global_t_n_plus_1,real* global_t,real* global_greek_deltat_n_plus_1){/*StdJob*//*GlobalVar*/global_t_n_plus_1[0]=opAdd(/*StdJob*//*GlobalVar*/global_t[0],/*StdJob*//*GlobalVar*/global_greek_deltat_n_plus_1[0]);
}

// ********************************************************
// * Copyt_n_plus_1 fct
// ********************************************************
static inline void Copyt_n_plus_1(real* global_t,real* global_t_n_plus_1){/*StdJob*//*GlobalVar*/global_t[0]=/*StdJob*//*GlobalVar*/global_t_n_plus_1[0];
}

// ********************************************************
// * ComputeFjr job
// ********************************************************
static inline void ComputeFjr(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real3* cell_F,real* cell_p,real3* cell_C,real3x3* cell_A,real3* cell_u,real3* node_fu/*isInXS(fu)(c,n,0,"",0)?*//*new XS:c->n0*/, const int* xs_cell_node){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){/* 'fu:k(0)' is gathered but NOT used InThisForall! */{
		/*chsf n*/for(int n=0;n<NABLA_NODE_PER_CELL;++n)/*FORALL_INI*/{
			/* 'fu:k(0)' is gathered and IS used InThisForall! *//*xCallFilterGather*/
/*const real3*/ real2 gathered_node_fu=rgather3k(xs_cell_node[n*NABLA_NB_CELLS+(c<<WARP_BIT)],node_fu);
			{
		cell_F[n+NABLA_NODE_PER_CELL*c]/*'='->!isLeft*/=opAdd ( opMul ( cell_p[c], cell_C[n+NABLA_NODE_PER_CELL*c]) , /*JOB_CALL*//*got_call*//*has not been found*/opProdTensVec ( cell_A[n+NABLA_NODE_PER_CELL*c], ( opSub ( cell_u[c], /*gathered variable!*/gathered_node_fu) ) /*ARGS*//*got_args*/) ) ;
		/*!function_call_arguments*/}/*xCallFilterScatter*//*FORALL_END*/
		}
	}}
}

// ********************************************************
// * Compute_ComputeXn job
// ********************************************************
static inline void Compute_ComputeXn(const int NABLA_NB_NODES_WARP, const int NABLA_NB_NODES,real3* node_X_n_plus_1,real3* node_X,real* global_greek_deltat,real3* node_fu){/*xHookForAllPrefix*/FOR_EACH_NODE_WARP(n){{
		node_X_n_plus_1/*NodeVar !20*/[n]/*'='->!isLeft*/=opAdd ( node_X/*NodeVar !20*/[n], opMul ( /*GlobalVar*/global_greek_deltat[0], node_fu/*NodeVar !20*/[n]) ) ;
		}}
}

// ********************************************************
// * CopyX_n_plus_1 job
// ********************************************************
static inline void CopyX_n_plus_1(const int NABLA_NB_NODES_WARP, const int NABLA_NB_NODES,real3* node_X,real3* node_X_n_plus_1){/*xHookForAllPrefix*/FOR_EACH_NODE_WARP(n){{
		node_X/*NodeVar !20*/[n]/*'='->!isLeft*/=node_X_n_plus_1/*NodeVar !20*/[n];
		}}
}

// ********************************************************
// * Compute_ComputeUn job
// ********************************************************
static inline void Compute_ComputeUn(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real3* cell_F,real3* cell_u_n_plus_1,real3* cell_u,real* global_greek_deltat,real* cell_m){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){{
		/*Real3*/real3 Sum20e1e014 /*'='->!isLeft*/=0 ;
		/*chsf n*/for(int n=0;n<NABLA_NODE_PER_CELL;++n)/*FORALL_INI*/{
			/*xCallFilterGather*/
{
		Sum20e1e014 +=cell_F[n+NABLA_NODE_PER_CELL*c];
		}/*xCallFilterScatter*//*FORALL_END*/
		}
	cell_u_n_plus_1[c]/*'='->!isLeft*/=opSub ( cell_u[c], opMul ( ( opDiv ( /*GlobalVar*/global_greek_deltat[0], cell_m[c]) ) , Sum20e1e014 ) ) ;
		}}
}

// ********************************************************
// * Compute_ComputeEn job
// ********************************************************
static inline void Compute_ComputeEn(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real3* cell_F,real3* node_fu,real* cell_E_n_plus_1,real* cell_E,real* global_greek_deltat,real* cell_m/*isInXS(fu)(c,n,0,"",0)?*//*new XS:c->n0*/, const int* xs_cell_node){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){/* 'fu:k(0)' is gathered but NOT used InThisForall! */{
		/*Real*/real Sum3fd117d8 /*'='->!isLeft*/=0 ;
		/*chsf n*/for(int n=0;n<NABLA_NODE_PER_CELL;++n)/*FORALL_INI*/{
			/* 'fu:k(0)' is gathered and IS used InThisForall! *//*xCallFilterGather*/
/*const real3*/ real2 gathered_node_fu=rgather3k(xs_cell_node[n*NABLA_NB_CELLS+(c<<WARP_BIT)],node_fu);
			{
		Sum3fd117d8 +=/*JOB_CALL*//*got_call*//*has not been found*/dot ( cell_F[n+NABLA_NODE_PER_CELL*c], /*gathered variable!*/gathered_node_fu/*ARGS*//*got_args*/) ;
		/*!function_call_arguments*/}/*xCallFilterScatter*//*FORALL_END*/
		}
	cell_E_n_plus_1[c]/*'='->!isLeft*/=opSub ( cell_E[c], opMul ( ( opDiv ( /*GlobalVar*/global_greek_deltat[0], cell_m[c]) ) , Sum3fd117d8 ) ) ;
		}}
}

// ********************************************************
// * CopyE_n_plus_1 job
// ********************************************************
static inline void CopyE_n_plus_1(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real* cell_E,real* cell_E_n_plus_1){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){{
		cell_E[c]/*'='->!isLeft*/=cell_E_n_plus_1[c];
		}}
}

// ********************************************************
// * Copyu_n_plus_1 job
// ********************************************************
static inline void Copyu_n_plus_1(const int NABLA_NB_CELLS_WARP,const int NABLA_NB_CELLS,real3* cell_u,real3* cell_u_n_plus_1){/*xHookForAllPrefix*/FOR_EACH_CELL_WARP(c){{
		cell_u[c]/*'='->!isLeft*/=cell_u_n_plus_1[c];
		}}
}

// ****************************************************************************
// * 2D
// ****************************************************************************

// ****************************************************************************
// * Connectivité cell->node
// ****************************************************************************
static void nabla_ini_cell_node(const nablaMesh msh,
                                int *cell_node){
  if (DBG_DUMP) printf("\n[1;33mcell->node:[0m");
  dbg(DBG_INI_CELL,"\nOn associe a chaque maille ses noeuds");
  int iCell=0;
  for(int iY=0;iY<msh.NABLA_NB_CELLS_Y_AXIS;iY++){
    for(int iX=0;iX<msh.NABLA_NB_CELLS_X_AXIS;iX++,iCell+=1){
      const int cell_uid=iX + iY*msh.NABLA_NB_CELLS_X_AXIS;
      const int node_bid=iX + iY*msh.NABLA_NB_NODES_X_AXIS;
      dbg(DBG_INI_CELL,"\n\tSetting cell #%d %dx%d, cell_uid=%d, node_bid=%d",
          iCell,iX,iY,cell_uid,node_bid);
      cell_node[0*msh.NABLA_NB_CELLS+iCell] = node_bid;
      cell_node[1*msh.NABLA_NB_CELLS+iCell] = node_bid + 1;
      cell_node[2*msh.NABLA_NB_CELLS+iCell] = node_bid + msh.NABLA_NB_NODES_X_AXIS + 1;
      cell_node[3*msh.NABLA_NB_CELLS+iCell] = node_bid + msh.NABLA_NB_NODES_X_AXIS + 0;
      dbg(DBG_INI_CELL,"\n\tCell_%d's nodes are %d,%d,%d,%d", iCell,
          cell_node[0*msh.NABLA_NB_CELLS+iCell],
          cell_node[1*msh.NABLA_NB_CELLS+iCell],
          cell_node[2*msh.NABLA_NB_CELLS+iCell],
          cell_node[3*msh.NABLA_NB_CELLS+iCell]);
      if (DBG_DUMP) printf("\n\t%d,%d,%d,%d,",
            cell_node[0*msh.NABLA_NB_CELLS+iCell],
            cell_node[1*msh.NABLA_NB_CELLS+iCell],
            cell_node[2*msh.NABLA_NB_CELLS+iCell],
            cell_node[3*msh.NABLA_NB_CELLS+iCell]);
    }
  }
}
 
// ****************************************************************************
// * Vérification: Connectivité cell->next et cell->prev
// ****************************************************************************
__attribute__((unused)) static
void verifNextPrev(const nablaMesh msh,
                   int *cell_prev, int *cell_next){
 for (int i=0; i<msh.NABLA_NB_CELLS; ++i) {
    dbg(DBG_INI_CELL,"\nNext/Prev(X) for cells %d <- #%d -> %d: ",
        cell_prev[MD_DirX*msh.NABLA_NB_CELLS+i],
        i,
        cell_next[MD_DirX*msh.NABLA_NB_CELLS+i]);
  }
  for (int i=0; i<msh.NABLA_NB_CELLS; ++i) {
    dbg(DBG_INI_CELL,"\nNext/Prev(Y) for cells %d <- #%d -> %d: ",
        cell_prev[MD_DirY*msh.NABLA_NB_CELLS+i],
        i,
        cell_next[MD_DirY*msh.NABLA_NB_CELLS+i]);
  }
}

// ****************************************************************************
// * Connectivité cell->next et cell->prev
// ****************************************************************************
static void nabla_ini_cell_next_prev(const nablaMesh msh,
                                     int *cell_prev, int *cell_next){
  dbg(DBG_INI_CELL,"\nOn associe a chaque maille ses next et prev");
  // On met des valeurs négatives pour rGatherAndZeroNegOnes
  // Dans la direction X
  for (int i=0; i<msh.NABLA_NB_CELLS; ++i) {
    cell_prev[MD_DirX*msh.NABLA_NB_CELLS+i] = i-1 ;
    cell_next[MD_DirX*msh.NABLA_NB_CELLS+i] = i+1 ;
  }
  for (int i=0; i<msh.NABLA_NB_CELLS; ++i) {
    if ((i%msh.NABLA_NB_CELLS_X_AXIS)==0){
      cell_prev[MD_DirX*msh.NABLA_NB_CELLS+i] = -33333333 ;
      cell_next[MD_DirX*msh.NABLA_NB_CELLS+i+msh.NABLA_NB_CELLS_X_AXIS-1] = -44444444 ;
    }
  }
  // Dans la direction Y
  for (int i=0; i<msh.NABLA_NB_CELLS; ++i) {
    cell_prev[MD_DirY*msh.NABLA_NB_CELLS+i] = i-msh.NABLA_NB_CELLS_X_AXIS ;
    cell_next[MD_DirY*msh.NABLA_NB_CELLS+i] = i+msh.NABLA_NB_CELLS_X_AXIS ;
  }
  for (int i=0; i<msh.NABLA_NB_CELLS; ++i) {
    if ((i%(msh.NABLA_NB_CELLS_X_AXIS*msh.NABLA_NB_CELLS_Y_AXIS))<msh.NABLA_NB_CELLS_Y_AXIS){
      cell_prev[MD_DirY*msh.NABLA_NB_CELLS+i] = -55555555 ;
      cell_next[MD_DirY*msh.NABLA_NB_CELLS+i+
                (msh.NABLA_NB_CELLS_X_AXIS-1)*msh.NABLA_NB_CELLS_Y_AXIS] = -66666666 ;
    }
  }
  verifNextPrev(msh,cell_prev,cell_next); 
}

// ****************************************************************************
// * qsort compare fonction for a Node and a Cell
// ****************************************************************************
static int comparNodeCell(const void *a, const void *b){
  return (*(int*)a)>(*(int*)b);
}

// ****************************************************************************
// * qsort compare fonction for a Node, Cell and Corner
// ****************************************************************************
static int comparNodeCellAndCorner(const void *pa, const void *pb){
  int *a=(int*)pa;
  int *b=(int*)pb;
  return a[0]>b[0];
}

// ****************************************************************************
// * Vérification: Connectivité node->cell et node->corner
// ****************************************************************************
__attribute__((unused))
static void verifConnectivity(const nablaMesh msh,
                              int* node_cell,
                              int *node_cell_and_corner){
  if (DBG_DUMP) printf("\n[1;33mnode->cell:[0m");
  dbg(DBG_INI_NODE,"\nVérification des connectivité des noeuds");
  FOR_EACH_NODE_MSH(n){
    dbg(DBG_INI_NODE,"\nFocusing on node %d",n);
    if (DBG_DUMP) printf("\n\t");
    FOR_EACH_NODE_CELL_MSH(c){
      dbg(DBG_INI_NODE,"\n\tnode_%d knows cell %d",n,node_cell[nc]);
      dbg(DBG_INI_NODE,", and node_%d knows cell %d",n,node_cell_and_corner[2*nc+0]);
      if (DBG_DUMP) printf(" %d,",node_cell[nc]);
    }
  }
}

__attribute__((unused))
static void verifCorners(const nablaMesh msh,
                         int* node_cell,
                         int *node_cell_corner){
  if (DBG_DUMP) printf("\n[1;33mnode->corner:[0m");
  dbg(DBG_INI_NODE,"\nVérification des coins des noeuds");
  FOR_EACH_NODE_MSH(n){
    dbg(DBG_INI_NODE,"\nFocusing on node %d",n);
    if (DBG_DUMP) printf("\n\t");
    FOR_EACH_NODE_CELL_MSH(c){
      //if (node_cell_corner[nc]==-1) continue;
      dbg(DBG_INI_NODE,"\n\tnode_%d is corner #%d of cell %d",n,
          node_cell_corner[nc],node_cell[nc]);
      if (DBG_DUMP) printf(" %d,",node_cell_corner[nc]);
      //dbg(DBG_INI,", and node_%d is corner #%d of cell %d",n,node_cell_and_corner[2*nc+1],node_cell_and_corner[2*nc+0]);
    }
  }
}

// ****************************************************************************
// * Connectivité node->cell et node->corner
// ****************************************************************************
static void nabla_ini_node_cell(const nablaMesh msh,
                                const int* cell_node,
                                int *node_cell,
                                int* node_cell_corner,
                                int* node_cell_and_corner){
  dbg(DBG_INI_NODE,"\nMaintenant, on re-scan pour remplir la connectivité des noeuds et des coins");
  dbg(DBG_INI_NODE,"\nOn flush le nombre de mailles attachées à ce noeud");
  for(int n=0;n<msh.NABLA_NB_NODES;n+=1){
    for(int c=0;c<msh.NABLA_CELL_PER_NODE;++c){
      node_cell[msh.NABLA_CELL_PER_NODE*n+c]=-1;
      node_cell_corner[msh.NABLA_CELL_PER_NODE*n+c]=-1;
      node_cell_and_corner[2*(msh.NABLA_CELL_PER_NODE*n+c)+0]=-1;//cell
      node_cell_and_corner[2*(msh.NABLA_CELL_PER_NODE*n+c)+1]=-1;//corner
    }
  }  
  for(int c=0;c<msh.NABLA_NB_CELLS;c+=1){
    dbg(DBG_INI_NODE,"\nFocusing on cell %d",c);
    for(int n=0;n<msh.NABLA_CELL_PER_NODE;n++){
      const int iNode = cell_node[n*msh.NABLA_NB_CELLS+c];
      dbg(DBG_INI_NODE,"\n\tcell_%d @%d: pushs node %d",c,n,iNode);
      // les NABLA_CELL_PER_NODE emplacements donnent l'offset jusqu'aux mailles
      // node_corner a une structure en NABLA_CELL_PER_NODE*NABLA_NB_NODES
      node_cell[msh.NABLA_CELL_PER_NODE*iNode+n]=c;
      node_cell_corner[msh.NABLA_CELL_PER_NODE*iNode+n]=n;
      node_cell_and_corner[2*(msh.NABLA_CELL_PER_NODE*iNode+n)+0]=c;//cell
      node_cell_and_corner[2*(msh.NABLA_CELL_PER_NODE*iNode+n)+1]=n;//corner
    }
  }
  // On va maintenant trier les connectivités node->cell pour assurer l'associativité
  // void qsort(void *base, size_t nmemb, size_t size,
  //            int (*compar)(const void *, const void *));
  for(int n=0;n<msh.NABLA_NB_NODES;n+=1){
    qsort(&node_cell[msh.NABLA_CELL_PER_NODE*n],
          msh.NABLA_CELL_PER_NODE,sizeof(int),comparNodeCell);
    qsort(&node_cell_and_corner[2*msh.NABLA_CELL_PER_NODE*n],
          msh.NABLA_CELL_PER_NODE,2*sizeof(int),comparNodeCellAndCorner);
  }
  // And we come back to set our node_cell_corner
  for(int n=0;n<msh.NABLA_NB_NODES;n+=1)
    for(int c=0;c<msh.NABLA_CELL_PER_NODE;++c)
      node_cell_corner[msh.NABLA_CELL_PER_NODE*n+c]=
        node_cell_and_corner[2*(msh.NABLA_CELL_PER_NODE*n+c)+1];
  verifConnectivity(msh,node_cell,node_cell_corner);
  verifCorners(msh,node_cell,node_cell_corner);
}

// ****************************************************************************
// * Connectivité face->cell
// * Un encodage des directions est utilisé en poids faibles:
// * bit:   2 1 0
// *     sign|.|.
// * MD_DirX => 1, MD_DirY => 2
// ****************************************************************************
__attribute__((unused)) static const int dir2bit(int d){
  assert((d==MD_DirX)||(d==MD_DirY));
  return d+1;
}
static const char cXY(int d){
  assert((d==MD_DirX)||(d==MD_DirY));
  return (d==MD_DirX)?'X':(d==MD_DirY)?'Y':'?';
}
static const char* sXY(int f){
  char str[32];
  const char sign=((f&4)==4)?'-':'+';
  f&=3;
  const char XorY=(f==1)?'X':(f==2)?'Y':'?';
  assert(XorY!='?');
  snprintf(str,32,"%c%c",sign,XorY);
  return strdup(str);
}
static char* f2d(int f,bool shift=true){
  char str[32];
  if (f>=0 && shift) snprintf(str,32,"%d",f>>MD_Shift);
  if (f>=0 && !shift) snprintf(str,32,"%d",f);
  if (f<0) snprintf(str,32,"[1;31m%s[m",sXY(-f));
  return strdup(str);
}
static int nabla_ini_face_cell_outer_minus(const nablaMesh msh,
                                           int* face_cell,
                                           const int *iof,
                                           const int c,
                                           const int i,
                                           const int MD_Dir){
  const int f=iof[1];
  face_cell[0*msh.NABLA_NB_FACES+f] = (c<<MD_Shift)|MD_Negt|(MD_Dir+1);
  face_cell[1*msh.NABLA_NB_FACES+f] = -(MD_Negt|(MD_Dir+1));
  dbg(DBG_INI_FACE," %s-%c->%s",
      f2d(face_cell[0*msh.NABLA_NB_FACES+f]),
      cXY(MD_Dir),
      f2d(face_cell[1*msh.NABLA_NB_FACES+f]));
  return 1;
}
static int nabla_ini_face_cell_inner(const nablaMesh msh,
                                     int* face_cell,
                                     const int *iof, const int c,
                                     const int i, const int MD_Dir){
  const int f=iof[0];
  face_cell[0*msh.NABLA_NB_FACES+f] = (c<<MD_Shift)|MD_Plus|(MD_Dir+1);
  if (MD_Dir==MD_DirX) face_cell[1*msh.NABLA_NB_FACES+f] = c+1;
  if (MD_Dir==MD_DirY) face_cell[1*msh.NABLA_NB_FACES+f] = c+msh.NABLA_NB_CELLS_X_AXIS;
  face_cell[1*msh.NABLA_NB_FACES+f] <<= MD_Shift;
  face_cell[1*msh.NABLA_NB_FACES+f] |= (MD_Plus|(MD_Dir+1));
  dbg(DBG_INI_FACE," %s-%c->%s",
      f2d(face_cell[0*msh.NABLA_NB_FACES+f]),
      cXY(MD_Dir),
      f2d(face_cell[1*msh.NABLA_NB_FACES+f]));
  return 1;
}
static int nabla_ini_face_cell_outer_plus(const nablaMesh msh,
                                          int* face_cell,
                                          const int *iof, const int c,
                                          const int i, const int MD_Dir){
  const int f=iof[1];
  face_cell[0*msh.NABLA_NB_FACES+f] = (c<<MD_Shift)|MD_Plus|(MD_Dir+1);
  face_cell[1*msh.NABLA_NB_FACES+f] = -(MD_Plus|(MD_Dir+1));
  dbg(DBG_INI_FACE," %s-%c->%s",
      f2d(face_cell[0*msh.NABLA_NB_FACES+f]),
      cXY(MD_Dir),
      f2d(face_cell[1*msh.NABLA_NB_FACES+f]));
  return 1;
}
static void nabla_ini_face_cell_XY(const nablaMesh msh,
                                   int* face_cell,
                                   int *f, const int c,
                                   const int i, const int MD_Dir){
  const int n =
    (MD_Dir==MD_DirX)?msh.NABLA_NB_CELLS_X_AXIS:
    (MD_Dir==MD_DirY)?msh.NABLA_NB_CELLS_Y_AXIS:-0xDEADBEEF;  
  if (i<n-1)  f[0]+=nabla_ini_face_cell_inner(msh,face_cell,f,c,i,MD_Dir);
  if (i==0)   f[1]+=nabla_ini_face_cell_outer_minus(msh,face_cell,f,c,i,MD_Dir);
  if (i==n-1) f[1]+=nabla_ini_face_cell_outer_plus(msh,face_cell,f,c,i,MD_Dir);
}
static void nabla_ini_face_cell(const nablaMesh msh,
                                int* face_cell){
  dbg(DBG_INI_FACE,"\n[1;33m[nabla_ini_face_cell] On associe a chaque maille ses faces:[m");
  int f[2]={0,msh.NABLA_NB_FACES_INNER}; // inner and outer faces
  for(int iY=0;iY<msh.NABLA_NB_CELLS_Y_AXIS;iY++){
    for(int iX=0;iX<msh.NABLA_NB_CELLS_X_AXIS;iX++){
      const int c=iX + iY*msh.NABLA_NB_CELLS_X_AXIS;
      dbg(DBG_INI_FACE,"\n\tCell #[1;36m%d[m @ %dx%d:",c,iX,iY);
      nabla_ini_face_cell_XY(msh,face_cell,f,c,iX,MD_DirX);
      nabla_ini_face_cell_XY(msh,face_cell,f,c,iY,MD_DirY);
    }
  }
  dbg(DBG_INI_FACE,"\n\tNumber of faces = %d",f[0]+f[1]-msh.NABLA_NB_FACES_INNER);
  assert(f[0]==msh.NABLA_NB_FACES_INNER);
  assert(f[1]==msh.NABLA_NB_FACES_INNER+msh.NABLA_NB_FACES_OUTER);
  assert((f[0]+f[1])==msh.NABLA_NB_FACES+msh.NABLA_NB_FACES_INNER);
  // On laisse les faces shiftées/encodées avec les directions pour les face_node
}

// ****************************************************************************
// * On les a shifté pour connaitre les directions, on flush les positifs
// ****************************************************************************
void nabla_ini_shift_back_face_cell(const nablaMesh msh,
                                    int* face_cell){
  for(int f=0;f<msh.NABLA_NB_FACES;f+=1){
    if (face_cell[0*msh.NABLA_NB_FACES+f]>0) face_cell[0*msh.NABLA_NB_FACES+f]>>=MD_Shift;
    if (face_cell[1*msh.NABLA_NB_FACES+f]>0) face_cell[1*msh.NABLA_NB_FACES+f]>>=MD_Shift;
  }
  dbg(DBG_INI_FACE,"\n[nabla_ini_shift_back_face_cell] Inner faces:\n");
  for(int f=0;f<msh.NABLA_NB_FACES_INNER;f+=1)
    dbg(DBG_INI_FACE," %s->%s",
        f2d(face_cell[0*msh.NABLA_NB_FACES+f],false),
        f2d(face_cell[1*msh.NABLA_NB_FACES+f],false));
  dbg(DBG_INI_FACE,"\n[nabla_ini_shift_back_face_cell] Outer faces:\n");
  for(int f=msh.NABLA_NB_FACES_INNER;f<msh.NABLA_NB_FACES_INNER+msh.NABLA_NB_FACES_OUTER;f+=1)
    dbg(DBG_INI_FACE," %s->%s",
        f2d(face_cell[0*msh.NABLA_NB_FACES+f],false),
        f2d(face_cell[1*msh.NABLA_NB_FACES+f],false));
  dbg(DBG_INI_FACE,"\n[nabla_ini_shift_back_face_cell] All faces:\n");
  if (DBG_DUMP) printf("\n[1;33mface->cell:[0m");
  for(int f=0;f<msh.NABLA_NB_FACES;f+=1){
    dbg(DBG_INI_FACE," %d->%d",
        face_cell[0*msh.NABLA_NB_FACES+f],
        face_cell[1*msh.NABLA_NB_FACES+f]);
    if (DBG_DUMP) printf("\n\t%d,%d,",
        face_cell[0*msh.NABLA_NB_FACES+f],
        face_cell[1*msh.NABLA_NB_FACES+f]);
  }
}

// ****************************************************************************
// * Connectivité cell->face
// ****************************************************************************
/*static void addThisfaceToCellConnectivity(const nablaMesh msh,
                                          int* cell_face,
                                          const int f, const int c){
  dbg(DBG_INI_FACE,"\n\t\t[addThisfaceToCellConnectivity] Adding face #%d to cell %d ",f,c);
  for(int i=0;i<msh.NABLA_FACE_PER_CELL;i+=1){
    // On scrute le premier emplacement 
    if (cell_face[i*msh.NABLA_NB_CELLS+c]>=0) continue;
    dbg(DBG_INI_FACE,"[%d] ",i);
    cell_face[i*msh.NABLA_NB_CELLS+c]=f;
    break; // We're finished here
  }
  }*/
static void addThisfaceToCellConnectivity(const nablaMesh msh,
                                          const int* cell_node,const int c,
                                          const int* face_node,const int f,
                                          int* cell_face){
  const int n0 = face_node[0*msh.NABLA_NB_FACES+f];
  const int n1 = face_node[1*msh.NABLA_NB_FACES+f];
  dbg(DBG_INI_FACE,"\n\t\t[addThisfaceToCellConnectivity] Adding face #%d (%d->%d) to cell %d ",f,n0,n1,c);
  for(int i=0;i<msh.NABLA_FACE_PER_CELL;i+=1){
    const int cn0=cell_node[i*msh.NABLA_NB_CELLS+c];
    const int cn1=cell_node[((i+1)%NABLA_NODE_PER_CELL)*msh.NABLA_NB_CELLS+c];
    const int ocn0=min(cn0,cn1);
    const int ocn1=max(cn0,cn1);
    dbg(DBG_INI_FACE,", cell_nodes %d->%d",ocn0,ocn1); 
    if (ocn0!=n0) continue;
    if (ocn1!=n1) continue;
    dbg(DBG_INI_FACE," at %d",i);
    cell_face[i*msh.NABLA_NB_CELLS+c]=f;
    return; // We're finished here
  }
}


static void nabla_ini_cell_face(const nablaMesh msh,
                                const int* face_cell,
                                const int* cell_node,
                                const int* face_node,
                                int* cell_face){
  dbg(DBG_INI_FACE,"\n[1;33mOn revient pour remplir cell->face:[m (flushing)");
  for(int c=0;c<msh.NABLA_NB_CELLS;c+=1){
    for(int f=0;f<msh.NABLA_FACE_PER_CELL;f+=1){
      cell_face[f*msh.NABLA_NB_CELLS+c]=-1;
    }
  }
 
  for(int f=0;f<msh.NABLA_NB_FACES;f+=1){
    const int cell0 = face_cell[0*msh.NABLA_NB_FACES+f];
    const int cell1 = face_cell[1*msh.NABLA_NB_FACES+f];
    dbg(DBG_INI_FACE,"\n\t[nabla_ini_cell_face] Pushing face #%d: %d->%d",f,cell0,cell1);
    if (cell0>=0) addThisfaceToCellConnectivity(msh,cell_node,cell0,face_node,f,cell_face);
    if (cell1>=0) addThisfaceToCellConnectivity(msh,cell_node,cell1,face_node,f,cell_face);
  }
  
  dbg(DBG_INI_FACE,"\n[1;33mOn revient pour dumper cell->face:[m");
  if (DBG_DUMP) printf("\n[1;33mcell->face:[0m");
  for(int c=0;c<msh.NABLA_NB_CELLS;c+=1){
    if (DBG_DUMP) printf("\n");
    for(int f=0;f<msh.NABLA_FACE_PER_CELL;f+=1){
      if (DBG_DUMP) printf(" %d,",cell_face[f*msh.NABLA_NB_CELLS+c]);
      if (cell_face[f*msh.NABLA_NB_CELLS+c]<0) continue;
      dbg(DBG_INI_FACE,"\n\t[nabla_ini_cell_face] cell[%d]_face[%d] %d",
          c,f,cell_face[f*msh.NABLA_NB_CELLS+c]);
    }
  }
}


// ****************************************************************************
// * Connectivité face->node
// ****************************************************************************
static const char* i2XY(const int i){
  const int c=i&MD_Mask;
  //dbg(DBG_INI_FACE,"\n\t\t[33m[i2XY] i=%d, Shift=%d, c=%d[m",i,MD_Shift,c);
  if (c==(MD_Plus|(MD_DirX+1))) return strdup("x+");
  if (c==(MD_Negt|(MD_DirX+1))) return strdup("x-");
  if (c==(MD_Plus|(MD_DirY+1))) return strdup("y+");
  if (c==(MD_Negt|(MD_DirY+1))) return strdup("y-");
  fprintf(stderr,"[i2XY] Error, could not distinguish XY!");
  exit(-1);
  return NULL;
}
static const char* c2XY(const int c){
  char str[16];
  if (c==-(MD_Negt|(MD_DirX+1))) return strdup("[1;31mX-[m");
  if (c==-(MD_Plus|(MD_DirX+1))) return strdup("[1;31mX+[m");
  if (c==-(MD_Negt|(MD_DirY+1))) return strdup("[1;31mY-[m");
  if (c==-(MD_Plus|(MD_DirY+1))) return strdup("[1;31mY+[m");
  if (snprintf(str,16,"%d%s",c>>MD_Shift,i2XY(c))<0) fprintf(stderr,"c2XY!");
  return strdup(str);
}
static void setFWithTheseNodes(const nablaMesh msh,
                               int* face_node,
                               int* cell_node,
                               const int f, const int c,
                               const int n0, const int n1){
  //dbg(DBG_INI_FACE,"\n[1;33m[setFWithTheseNodes] %d & %d[m",n0,n1);
  const int nid0=cell_node[n0*msh.NABLA_NB_CELLS+c];
  const int nid1=cell_node[n1*msh.NABLA_NB_CELLS+c];
  face_node[0*msh.NABLA_NB_FACES+f]=min(nid0,nid1);
  face_node[1*msh.NABLA_NB_FACES+f]=max(nid0,nid1);
}
static void nabla_ini_face_node(const nablaMesh msh,
                                const int* face_cell,
                                int* face_node,
                                int* cell_node){
  dbg(DBG_INI_FACE,"\n[1;33m[nabla_ini_face_node] On associe a chaque faces ses noeuds:[m");
  // On flush toutes les connectivités face_noeuds
  for(int f=0;f<msh.NABLA_NB_FACES;f+=1)
    for(int n=0;n<msh.NABLA_NODE_PER_FACE;n+=1)
      face_node[n*msh.NABLA_NB_FACES+f]=-1;
  
  for(int f=0;f<msh.NABLA_NB_FACES;f+=1){
    const int backCell=face_cell[0*msh.NABLA_NB_FACES+f];
    const int frontCell=face_cell[1*msh.NABLA_NB_FACES+f];
    dbg(DBG_INI_FACE,"\n\tFace #[1;36m%d[m: %d => %d, ",f, backCell>>MD_Shift, frontCell>>MD_Shift);
    dbg(DBG_INI_FACE,"\t%s => %s: ", c2XY(backCell), c2XY(frontCell));
    // On va travailler avec sa backCell
    const int c=backCell>>MD_Shift;
    const int d=backCell &MD_Mask;
    dbg(DBG_INI_FACE,"\t%d ", c);
    dbg(DBG_INI_FACE,"\t%d ", d);
    assert(c>=0);
    if (d==(MD_Plus|(MD_DirX+1)))
      { setFWithTheseNodes(msh,face_node,cell_node,f,c,1,2); continue; }
    if (d==(MD_Negt|(MD_DirX+1)))
      { setFWithTheseNodes(msh,face_node,cell_node,f,c,0,3); continue; }
    if (d==(MD_Plus|(MD_DirY+1)))
      { setFWithTheseNodes(msh,face_node,cell_node,f,c,2,3); continue; }
    if (d==(MD_Negt|(MD_DirY+1)))
      { setFWithTheseNodes(msh,face_node,cell_node,f,c,0,1); continue; }
    fprintf(stderr,"[nabla_ini_face_node] Error!");
    exit(-1);
    //for(int n=0;n<NABLA_NODE_PER_CELL;n+=1)
    //  dbg(DBG_INI_FACE,"%d ", cell_node[n*NABLA_NB_CELLS+c]);
  }
  if (DBG_DUMP) printf("\n[1;33mface->node:[0m");
  for(int f=0;f<msh.NABLA_NB_FACES;f+=1){
    dbg(DBG_INI_FACE,"\n\tface #%d: nodes ",f);
    if (DBG_DUMP) printf("\n");
    for(int n=0;n<msh.NABLA_NODE_PER_FACE;++n){
      dbg(DBG_INI_FACE,"%d ",face_node[n*msh.NABLA_NB_FACES+f]);
      if (DBG_DUMP) printf(" %d,",face_node[n*msh.NABLA_NB_FACES+f]);
      assert(face_node[n*msh.NABLA_NB_FACES+f]>=0);
    }
  }
}

// ****************************************************************************
// * xOf7 & yOf7
// ****************************************************************************
static double xOf7(const nablaMesh msh,
                   const int n){
  return
    ((double)(n%msh.NABLA_NB_NODES_X_AXIS))*msh.NABLA_NB_NODES_X_TICK;
}
static double yOf7(const nablaMesh msh,
                   const int n){
  return
    ((double)((n/msh.NABLA_NB_NODES_X_AXIS)
              %msh.NABLA_NB_NODES_Y_AXIS))*msh.NABLA_NB_NODES_Y_TICK;
}

// ****************************************************************************
// * Vérification des coordonnées
// ****************************************************************************
__attribute__((unused))
static void verifCoords(const nablaMesh msh,
                        Real3 *node_coord){
  dbg(DBG_INI_NODE,"\nVérification des coordonnés des noeuds");
  if (DBG_DUMP && DBG_LVL&DBG_INI_NODE) printf("\n[1;33mnode_coord:[0m");
  FOR_EACH_NODE_MSH(n){
    dbg(DBG_INI_NODE,"\n%d:",n);
    if (DBG_DUMP && DBG_LVL&DBG_INI_NODE) printf("\n\t%f,%f,%f,",node_coord[n].x,node_coord[n].y,node_coord[n].z);
    dbgReal3(DBG_INI_NODE,node_coord[n]);
  }
}

// ****************************************************************************
// * Initialisation des coordonnées
// ****************************************************************************
static void nabla_ini_node_coord(const nablaMesh msh,
                                 Real3 *node_coord){
  dbg(DBG_INI_NODE,"\nasserting NABLA_NB_NODES_Y_AXIS >= 1...");
  assert((msh.NABLA_NB_NODES_Y_AXIS >= 1));

  dbg(DBG_INI_NODE,"\nasserting (NABLA_NB_CELLS % 1)==0...");
  assert((msh.NABLA_NB_CELLS % 1)==0);
    
  for(int iNode=0; iNode<msh.NABLA_NB_NODES; iNode+=1){
    const int n=iNode;
    Real x,y;
    x=set(xOf7(msh,n));
    y=set(yOf7(msh,n));
    node_coord[iNode]=Real3(x,y,0.0);
  }
  verifCoords(msh,node_coord);
}

// ****************************************************************************
// * nabla_ini_connectivity
// ****************************************************************************
static void nabla_ini_connectivity(const nablaMesh msh,
                                   Real3 *node_coord,
                                   int *cell_node,
                                   int *cell_prev, int *cell_next,
                                   int* cell_face,
                                   int *node_cell,
                                   int* node_cell_corner,
                                   int* node_cell_and_corner,
                                   int* face_cell,
                                   int* face_node){
  nabla_ini_node_coord(msh,node_coord);
  nabla_ini_cell_node(msh,cell_node);
  nabla_ini_cell_next_prev(msh,cell_prev,cell_next);
  nabla_ini_node_cell(msh,
                      cell_node,
                      node_cell,
                      node_cell_corner,
                      node_cell_and_corner);
  nabla_ini_face_cell(msh,face_cell);
  nabla_ini_face_node(msh,face_cell,face_node,cell_node);
  nabla_ini_shift_back_face_cell(msh,face_cell);
  nabla_ini_cell_face(msh,face_cell,cell_node,face_node,cell_face);
  if (DBG_DUMP){
    printf("\n");
    exit(-1);
  }
  dbg(DBG_INI,"\nIni done");
}

// xHookMainVarInitKernel
//extern "C" int MPI_Init(int*, char ***);


extern "C" int inOpt(char *file,int *argc, char **argv);


extern void glvis3DHex(const int,const int,const int,const double,const double,const double,double*,double*);
extern void glvis2DQud(const int,const int,const double,const double,double*,double*);
extern void glvis1D(const int,const double,double*,double*);




// ******************************************************************************
// * Main
// ******************************************************************************
int main(int argc, char *argv[]){
	//MPI_Init(&argc,&argv);
	float alltime=0.0;
	struct timeval st, et;
	__attribute__((unused)) const int NABLA_NB_PARTICLES=(argc==1)?1024:atoi(argv[1]);
	// Initialisation des Swirls
	__attribute__((unused)) int hlt_level=0;
	__attribute__((unused)) bool glvis=false;
	__attribute__((unused)) int glvis_optarg=0;
	__attribute__((unused)) bool* hlt_exit=(bool*)calloc(64,sizeof(bool));
	// Initialisation de la précision du cout
	std::cout.precision(14);//21, 14 pour Arcane
	//std::cout.setf(std::ios::floatfield);
	std::cout.setf(std::ios::scientific, std::ios::floatfield);
	// ********************************************************
	// Initialisation du temps et du deltaT
	// ********************************************************
	double global_time[1]={0.0};//{option_dtt_initial};// Arcane fait comme cela!;
	int global_iteration[1]={1};
	real global_greek_deltat[1] = {set1(0.0)};// @ 0;
	//printf("\n\33[7;32m[main] time=%e, iteration is #%d\33[m",global_time[0],global_iteration[0]);

	// ********************************************************
	// Parse command-line options
	// ********************************************************
	int o; int longindex=0;
	const struct option longopts[]={
		{"vis",required_argument,NULL,(int)0x5d8a73d0},
		{"org",required_argument,NULL,(int)0x3c0f6f4c},
		{"LENGTH",required_argument,NULL,(int)0xc0ff90},
		{"X_EDGE_ELEMS",required_argument,NULL,(int)0xb6fda0},
		{"Y_EDGE_ELEMS",required_argument,NULL,(int)0xb6fde0},
		{"Z_EDGE_ELEMS",required_argument,NULL,(int)0xb6fe20},
		{"option_stoptime",required_argument,NULL,(int)0xb6fe60},
		{"option_max_iterations",required_argument,NULL,(int)0xb6fea0},
		{"greek_gamma",required_argument,NULL,(int)0xb6fee0},
		{"option_p_ini_zg",required_argument,NULL,(int)0xb6ff20},
		{"option_greek_rho_ini_zg",required_argument,NULL,(int)0xb6ff60},
		{"option_p_ini_zd",required_argument,NULL,(int)0x2421420},
		{"option_greek_rho_ini_zd",required_argument,NULL,(int)0x2421460},
		{"option_x_interface",required_argument,NULL,(int)0x24214a0},
		{"option_greek_deltat_ini",required_argument,NULL,(int)0x24214e0},
		{"option_greek_deltat_max",required_argument,NULL,(int)0x2421520},
		{"option_greek_deltat_cfl",required_argument,NULL,(int)0x2421560},
		{"option_greek_deltat_min_variation",required_argument,NULL,(int)0x24215a0},
		{"option_greek_deltat_max_variation",required_argument,NULL,(int)0x2421e10},
		{NULL,0,NULL,0}
	};
	while ((o=getopt_long_only(argc, argv, "",longopts,&longindex))!=-1){
		switch (o){
		case 0x5d8a73d0:{
			glvis=true;
			glvis_optarg=atoi(optarg);
			printf("[1;33mGLVis optarg offset is %d[m\n",glvis_optarg);
			break;
			};
		case 0x3c0f6f4c:{//optorg
			const int org_optind=optind;
			optind=0;
			char *org_optarg=strdup(optarg);
			printf("[1;33morg input file '%s'[0m\n",optarg);
			{
				int org_o,org_longindex=0;
				int org_argc=1;// +1 for the fake cmd name
				char **org_argv=(char**)calloc(1024,sizeof(char*));
				int status=inOpt(optarg,&org_argc,org_argv);
				//printf("[1;33morg_argc=%d[0m\n",org_argc);
				//for(int i=0;i<1024;i+=1)
				//	if (org_argv[i]!=NULL)
				//		printf("\t[33morg_argv[%d] is '%s'[m\n",i,org_argv[i]);
				assert(status==0);
				while ((org_o=getopt_long_only(org_argc,
															org_argv,"",
															longopts,&org_longindex))!=-1){
						//printf("\t[33morg_o=0x%X[m\n",org_o);
					switch (org_o){
					case (int)0xc0ff90: //real LENGTH
			 LENGTH=atof(optarg);
						break;
					case (int)0xb6fda0: //integer X_EDGE_ELEMS
			 X_EDGE_ELEMS=atol(optarg);
						break;
					case (int)0xb6fde0: //integer Y_EDGE_ELEMS
			 Y_EDGE_ELEMS=atol(optarg);
						break;
					case (int)0xb6fe20: //integer Z_EDGE_ELEMS
			 Z_EDGE_ELEMS=atol(optarg);
						break;
					case (int)0xb6fe60: //real option_stoptime
			 option_stoptime=atof(optarg);
						break;
					case (int)0xb6fea0: //integer option_max_iterations
			 option_max_iterations=atol(optarg);
						break;
					case (int)0xb6fee0: //real greek_gamma
			 greek_gamma=atof(optarg);
						break;
					case (int)0xb6ff20: //real option_p_ini_zg
			 option_p_ini_zg=atof(optarg);
						break;
					case (int)0xb6ff60: //real option_greek_rho_ini_zg
			 option_greek_rho_ini_zg=atof(optarg);
						break;
					case (int)0x2421420: //real option_p_ini_zd
			 option_p_ini_zd=atof(optarg);
						break;
					case (int)0x2421460: //real option_greek_rho_ini_zd
			 option_greek_rho_ini_zd=atof(optarg);
						break;
					case (int)0x24214a0: //real option_x_interface
			 option_x_interface=atof(optarg);
						break;
					case (int)0x24214e0: //real option_greek_deltat_ini
			 option_greek_deltat_ini=atof(optarg);
						break;
					case (int)0x2421520: //real option_greek_deltat_max
			 option_greek_deltat_max=atof(optarg);
						break;
					case (int)0x2421560: //real option_greek_deltat_cfl
			 option_greek_deltat_cfl=atof(optarg);
						break;
					case (int)0x24215a0: //real option_greek_deltat_min_variation
			 option_greek_deltat_min_variation=atof(optarg);
						break;
					case (int)0x2421e10: //real option_greek_deltat_max_variation
			 option_greek_deltat_max_variation=atof(optarg);
						break;
					default: exit(fprintf(stderr, "[nabla] Error in orgopt option line\n"));
					}
				}
			}
			optind=org_optind;
			optarg=org_optarg;
			break;}
		case (int)0xc0ff90: //real LENGTH
			if (!optarg) break;
 LENGTH=atof(optarg);
			break;
		case (int)0xb6fda0: //integer X_EDGE_ELEMS
			if (!optarg) break;
 X_EDGE_ELEMS=atol(optarg);
			break;
		case (int)0xb6fde0: //integer Y_EDGE_ELEMS
			if (!optarg) break;
 Y_EDGE_ELEMS=atol(optarg);
			break;
		case (int)0xb6fe20: //integer Z_EDGE_ELEMS
			if (!optarg) break;
 Z_EDGE_ELEMS=atol(optarg);
			break;
		case (int)0xb6fe60: //real option_stoptime
			if (!optarg) break;
 option_stoptime=atof(optarg);
			break;
		case (int)0xb6fea0: //integer option_max_iterations
			if (!optarg) break;
 option_max_iterations=atol(optarg);
			break;
		case (int)0xb6fee0: //real greek_gamma
			if (!optarg) break;
 greek_gamma=atof(optarg);
			break;
		case (int)0xb6ff20: //real option_p_ini_zg
			if (!optarg) break;
 option_p_ini_zg=atof(optarg);
			break;
		case (int)0xb6ff60: //real option_greek_rho_ini_zg
			if (!optarg) break;
 option_greek_rho_ini_zg=atof(optarg);
			break;
		case (int)0x2421420: //real option_p_ini_zd
			if (!optarg) break;
 option_p_ini_zd=atof(optarg);
			break;
		case (int)0x2421460: //real option_greek_rho_ini_zd
			if (!optarg) break;
 option_greek_rho_ini_zd=atof(optarg);
			break;
		case (int)0x24214a0: //real option_x_interface
			if (!optarg) break;
 option_x_interface=atof(optarg);
			break;
		case (int)0x24214e0: //real option_greek_deltat_ini
			if (!optarg) break;
 option_greek_deltat_ini=atof(optarg);
			break;
		case (int)0x2421520: //real option_greek_deltat_max
			if (!optarg) break;
 option_greek_deltat_max=atof(optarg);
			break;
		case (int)0x2421560: //real option_greek_deltat_cfl
			if (!optarg) break;
 option_greek_deltat_cfl=atof(optarg);
			break;
		case (int)0x24215a0: //real option_greek_deltat_min_variation
			if (!optarg) break;
 option_greek_deltat_min_variation=atof(optarg);
			break;
		case (int)0x2421e10: //real option_greek_deltat_max_variation
			if (!optarg) break;
 option_greek_deltat_max_variation=atof(optarg);
			break;
		case '?':
			if ((optopt>(int)'A')&&(optopt<(int)'z'))
				exit(fprintf (stderr, "\n[nabla] Unknown option `-%c'.\n", optopt));
		default: exit(fprintf(stderr, "[nabla] Error in command line\n"));
		}
	}

	// ********************************************************
	// * MESH GENERATION (2D)
	// ********************************************************
	const int NABLA_NB_NODES_X_AXIS = X_EDGE_ELEMS+1;
	const int NABLA_NB_NODES_Y_AXIS = Y_EDGE_ELEMS+1;
	const int NABLA_NB_NODES_Z_AXIS = 1;
	
	const int NABLA_NB_CELLS_X_AXIS = X_EDGE_ELEMS;
	const int NABLA_NB_CELLS_Y_AXIS = Y_EDGE_ELEMS;
	const int NABLA_NB_CELLS_Z_AXIS = 1;
	
	const int NABLA_NB_FACES_X_INNER = (X_EDGE_ELEMS-1)*Y_EDGE_ELEMS;
	const int NABLA_NB_FACES_Y_INNER = (Y_EDGE_ELEMS-1)*X_EDGE_ELEMS;
	const int NABLA_NB_FACES_Z_INNER = 0;
	const int NABLA_NB_FACES_X_OUTER = 2*NABLA_NB_CELLS_Y_AXIS;
	const int NABLA_NB_FACES_Y_OUTER = 2*NABLA_NB_CELLS_X_AXIS;
	const int NABLA_NB_FACES_Z_OUTER = 0;
	const int NABLA_NB_FACES_INNER = NABLA_NB_FACES_X_INNER+NABLA_NB_FACES_Y_INNER;
	const int NABLA_NB_FACES_OUTER = NABLA_NB_FACES_X_OUTER+NABLA_NB_FACES_Y_OUTER;
	const int NABLA_NB_FACES = NABLA_NB_FACES_INNER+NABLA_NB_FACES_OUTER;
	
	const double NABLA_NB_NODES_X_TICK = LENGTH/(NABLA_NB_CELLS_X_AXIS);
	const double NABLA_NB_NODES_Y_TICK = LENGTH/(NABLA_NB_CELLS_Y_AXIS);
	const double NABLA_NB_NODES_Z_TICK = 0.0;
	
	const int NABLA_NB_NODES        = (NABLA_NB_NODES_X_AXIS*NABLA_NB_NODES_Y_AXIS);
	const int NABLA_NODES_PADDING   = (((NABLA_NB_NODES%WARP_SIZE)==0)?0:1);
	const int NABLA_NB_CELLS        = (NABLA_NB_CELLS_X_AXIS*NABLA_NB_CELLS_Y_AXIS);
	
	const int NABLA_NB_NODES_WARP   = (NABLA_NODES_PADDING+NABLA_NB_NODES/WARP_SIZE);
	const int NABLA_NB_CELLS_WARP   = (NABLA_NB_CELLS/WARP_SIZE);
	const int NABLA_NB_OUTER_CELLS_WARP   = ((2*(X_EDGE_ELEMS+Y_EDGE_ELEMS)-4)/WARP_SIZE);
	
	//int NABLA_NB_PARTICLES /*= NB_PARTICLES*/;

	// ********************************************************
	// * Déclaration & Malloc des Variables
	// ********************************************************
	// generateSingleVariableMalloc coord
	real2* node_coord=(real2*)aligned_alloc(WARP_ALIGN,sizeof(real2)*(NABLA_NODES_PADDING+NABLA_NB_NODES));
	// generateSingleVariableMalloc t
	real* global_t=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_GLOBAL));
	// generateSingleVariableMalloc t_n_plus_1
	real* global_t_n_plus_1=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_GLOBAL));
	// generateSingleVariableMalloc greek_deltat_n_plus_1
	real* global_greek_deltat_n_plus_1=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_GLOBAL));
	// generateSingleVariableMalloc Min6f4a6c1c
	real* global_Min6f4a6c1c=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_GLOBAL));
	// generateSingleVariableMalloc X
	real2* node_X=(real2*)aligned_alloc(WARP_ALIGN,sizeof(real2)*(NABLA_NODES_PADDING+NABLA_NB_NODES));
	// generateSingleVariableMalloc X_n_plus_1
	real2* node_X_n_plus_1=(real2*)aligned_alloc(WARP_ALIGN,sizeof(real2)*(NABLA_NODES_PADDING+NABLA_NB_NODES));
	// generateSingleVariableMalloc X_ic
	real2* node_X_ic=(real2*)aligned_alloc(WARP_ALIGN,sizeof(real2)*(NABLA_NODES_PADDING+NABLA_NB_NODES));
	// generateSingleVariableMalloc b
	real2* node_b=(real2*)aligned_alloc(WARP_ALIGN,sizeof(real2)*(NABLA_NODES_PADDING+NABLA_NB_NODES));
	// generateSingleVariableMalloc bt
	real2* node_bt=(real2*)aligned_alloc(WARP_ALIGN,sizeof(real2)*(NABLA_NODES_PADDING+NABLA_NB_NODES));
	// generateSingleVariableMalloc fu
	real2* node_fu=(real2*)aligned_alloc(WARP_ALIGN,sizeof(real2)*(NABLA_NODES_PADDING+NABLA_NB_NODES));
	// generateSingleVariableMalloc M
	real3x3* node_M=(real3x3*)aligned_alloc(WARP_ALIGN,sizeof(real3x3)*(NABLA_NODES_PADDING+NABLA_NB_NODES));
	// generateSingleVariableMalloc Mt
	real3x3* node_Mt=(real3x3*)aligned_alloc(WARP_ALIGN,sizeof(real3x3)*(NABLA_NODES_PADDING+NABLA_NB_NODES));
	// generateSingleVariableMalloc p_ic
	real* cell_p_ic=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc greek_rho_ic
	real* cell_greek_rho_ic=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc V_ic
	real* cell_V_ic=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc c
	real* cell_c=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc m
	real* cell_m=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc p
	real* cell_p=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc greek_rho
	real* cell_greek_rho=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc e
	real* cell_e=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc E
	real* cell_E=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc E_n_plus_1
	real* cell_E_n_plus_1=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc V
	real* cell_V=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc greek_deltatj
	real* cell_greek_deltatj=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc absC
	real* cell_absC=(real*)aligned_alloc(WARP_ALIGN,sizeof(real)*(NABLA_NODES_PADDING+8*NABLA_NB_CELLS));
	// generateSingleVariableMalloc u
	real2* cell_u=(real2*)aligned_alloc(WARP_ALIGN,sizeof(real2)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc u_n_plus_1
	real2* cell_u_n_plus_1=(real2*)aligned_alloc(WARP_ALIGN,sizeof(real2)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc center
	real2* cell_center=(real2*)aligned_alloc(WARP_ALIGN,sizeof(real2)*(NABLA_NODES_PADDING+NABLA_NB_CELLS));
	// generateSingleVariableMalloc C_ic
	real2* cell_C_ic=(real2*)aligned_alloc(WARP_ALIGN,sizeof(real2)*(NABLA_NODES_PADDING+8*NABLA_NB_CELLS));
	// generateSingleVariableMalloc C
	real2* cell_C=(real2*)aligned_alloc(WARP_ALIGN,sizeof(real2)*(NABLA_NODES_PADDING+8*NABLA_NB_CELLS));
	// generateSingleVariableMalloc F
	real2* cell_F=(real2*)aligned_alloc(WARP_ALIGN,sizeof(real2)*(NABLA_NODES_PADDING+8*NABLA_NB_CELLS));
	// generateSingleVariableMalloc A
	real3x3* cell_A=(real3x3*)aligned_alloc(WARP_ALIGN,sizeof(real3x3)*(NABLA_NODES_PADDING+8*NABLA_NB_CELLS));
	const real* i2var[14]={
		cell_p_ic,
		cell_greek_rho_ic,
		cell_V_ic,
		cell_c,
		cell_m,
		cell_p,
		cell_greek_rho,
		cell_e,
		cell_E,
		cell_E_n_plus_1,
		cell_V,
		cell_greek_deltatj,
		cell_absC,
		NULL
	};

	// BACKEND_MAIN_PREINIT

	// ********************************************************
	// * MESH CONNECTIVITY (2D)
	// ********************************************************
	int* xs_cell_node=(int*)aligned_alloc(WARP_ALIGN,NABLA_NB_CELLS*sizeof(int)*NABLA_NODE_PER_CELL);
	int* xs_cell_next=(int*)aligned_alloc(WARP_ALIGN,NABLA_NB_CELLS*sizeof(int)*2);
	int* xs_cell_prev=(int*)aligned_alloc(WARP_ALIGN,NABLA_NB_CELLS*sizeof(int)*2);
	int* xs_cell_face=(int*)aligned_alloc(WARP_ALIGN,NABLA_NB_CELLS*sizeof(int)*NABLA_FACE_PER_CELL);
	int* xs_node_cell=(int*)aligned_alloc(WARP_ALIGN,NABLA_NB_NODES*sizeof(int)*NABLA_CELL_PER_NODE);
	int* xs_node_cell_corner=(int*)aligned_alloc(WARP_ALIGN,NABLA_NB_NODES*sizeof(int)*NABLA_CELL_PER_NODE);
	int* xs_node_cell_and_corner=(int*)aligned_alloc(WARP_ALIGN,NABLA_NB_NODES*sizeof(int)*2*NABLA_CELL_PER_NODE);
	int* xs_face_cell=(int*)aligned_alloc(WARP_ALIGN,NABLA_NB_FACES*sizeof(int)*NABLA_CELL_PER_FACE);
	int* xs_face_node=(int*)aligned_alloc(WARP_ALIGN,NABLA_NB_FACES*sizeof(int)*NABLA_NODE_PER_FACE);
	assert(xs_cell_node && xs_cell_next && xs_cell_prev && xs_cell_face);
	assert(xs_node_cell && xs_node_cell_corner && xs_node_cell_and_corner);
	assert(xs_face_cell && xs_face_node);
	const nablaMesh msh={
		NABLA_NODE_PER_CELL,
		NABLA_CELL_PER_NODE,
		NABLA_CELL_PER_FACE,
		NABLA_NODE_PER_FACE,
		NABLA_FACE_PER_CELL,

		NABLA_NB_NODES_X_AXIS,
		NABLA_NB_NODES_Y_AXIS,
		NABLA_NB_NODES_Z_AXIS,

		NABLA_NB_CELLS_X_AXIS,
		NABLA_NB_CELLS_Y_AXIS,
		NABLA_NB_CELLS_Z_AXIS,

		NABLA_NB_FACES_X_INNER,
		NABLA_NB_FACES_Y_INNER,
		NABLA_NB_FACES_Z_INNER,
		NABLA_NB_FACES_X_OUTER,
		NABLA_NB_FACES_Y_OUTER,
		NABLA_NB_FACES_Z_OUTER,
		NABLA_NB_FACES_INNER,
		NABLA_NB_FACES_OUTER,
		NABLA_NB_FACES,

		NABLA_NB_NODES_X_TICK,
		NABLA_NB_NODES_Y_TICK,
		NABLA_NB_NODES_Z_TICK,

		NABLA_NB_NODES,
		NABLA_NODES_PADDING,
		NABLA_NB_CELLS,
		NABLA_NB_NODES_WARP,
		NABLA_NB_CELLS_WARP,
		NABLA_NB_OUTER_CELLS_WARP
};
	printf("[nabla] %d noeuds, %d mailles & %d faces",NABLA_NB_NODES,NABLA_NB_CELLS,NABLA_NB_FACES);
 	nabla_ini_connectivity(msh,node_coord,
									xs_cell_node,xs_cell_prev,xs_cell_next,xs_cell_face,
									xs_node_cell,xs_node_cell_corner,xs_node_cell_and_corner,
									xs_face_cell,xs_face_node);

	// ****************************************************************
	// Initialisation des variables
	// ****************************************************************
	FOR_EACH_NODE_WARP(n){
		node_X[n]=real3();
		node_X_n_plus_1[n]=real3();
		node_X_ic[n]=real3();
		node_b[n]=real3();
		node_bt[n]=real3();
		node_fu[n]=real3();
		node_M[n]=real3x3();
		node_Mt[n]=real3x3();
	}
	FOR_EACH_CELL_WARP(c){
		cell_p_ic[c]=zero();
		cell_greek_rho_ic[c]=zero();
		cell_V_ic[c]=zero();
		cell_c[c]=zero();
		cell_m[c]=zero();
		cell_p[c]=zero();
		cell_greek_rho[c]=zero();
		cell_e[c]=zero();
		cell_E[c]=zero();
		cell_E_n_plus_1[c]=zero();
		cell_V[c]=zero();
		cell_greek_deltatj[c]=zero();
		FOR_EACH_CELL_WARP_NODE(n) cell_absC[n+NABLA_NODE_PER_CELL*c]=0.0;
		cell_u[c]=real3();
		cell_u_n_plus_1[c]=real3();
		cell_center[c]=real3();
		FOR_EACH_CELL_WARP_NODE(n) cell_C_ic[n+NABLA_NODE_PER_CELL*c]=real3();
		FOR_EACH_CELL_WARP_NODE(n) cell_C[n+NABLA_NODE_PER_CELL*c]=real3();
		FOR_EACH_CELL_WARP_NODE(n) cell_F[n+NABLA_NODE_PER_CELL*c]=real3();
		FOR_EACH_CELL_WARP_NODE(n) cell_A[n+NABLA_NODE_PER_CELL*c]=real3x3();
	}
	/*xHookMainVarInitCall*/
	kernelFzP5tM(NABLA_NB_NODES_WARP,NABLA_NB_NODES,node_X_ic,node_coord);
		Init_ComputeDt(global_greek_deltat);
	Init_ComputeTn(global_t);
	Init_t(global_t);
	Init_greek_deltat(global_greek_deltat);
	IniCenter(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,node_X_ic,cell_center, xs_cell_node);
	ComputeCjrIc(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_C_ic,node_X_ic, xs_cell_node);
	Init_ComputeXn(NABLA_NB_NODES_WARP,NABLA_NB_NODES,node_X,node_X_ic);
	Init_ComputeUn(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_u);
	Init_Min6f4a6c1c(global_Min6f4a6c1c);
		IniIc(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_center,cell_greek_rho_ic,cell_p_ic);
	IniVIc(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_C_ic,node_X_ic,cell_V_ic, xs_cell_node);
		IniM(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_m,cell_greek_rho_ic,cell_V_ic);
	Init_ComputeEn(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_E,cell_p_ic,cell_greek_rho_ic);
	gettimeofday(&st, NULL);gettimeofday(&et, NULL);

	if (glvis and global_iteration[0]==0) glvis2DQud(X_EDGE_ELEMS,Y_EDGE_ELEMS,LENGTH,LENGTH,(double*)node_coord,(double*)i2var[glvis_optarg]);
	while ((global_time[0]<option_stoptime) && (global_iteration[0]!=option_max_iterations)){gettimeofday(&et, NULL);

	if (glvis and global_iteration[0]==0) glvis2DQud(X_EDGE_ELEMS,Y_EDGE_ELEMS,LENGTH,LENGTH,(double*)node_coord,(double*)i2var[glvis_optarg]);
				computeLoop(global_iteration,global_time);
				ComputeCjr(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_C,node_X, xs_cell_node);
		ComputeInternalEngergy(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_e,cell_E,cell_u);
				ComputeAbsjr(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_absC,cell_C);
		ComputeV(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_C,node_X,cell_V, xs_cell_node);
				ComputeDensity(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_greek_rho,cell_m,cell_V);
				ComputeEOSp(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_p,cell_greek_rho,cell_e);
				ComputeEOSc(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_c,cell_p,cell_greek_rho);
				Computegreek_deltatj(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_absC,cell_greek_deltatj,cell_V,cell_c);
		ComputeAjr(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_A,cell_greek_rho,cell_c,cell_absC,cell_C);
				ComputeMr(NABLA_NB_NODES_WARP,NABLA_NB_NODES,cell_A,node_M, xs_node_cell, xs_node_cell_corner);
		ComputeBr(NABLA_NB_NODES_WARP,NABLA_NB_NODES,cell_C,cell_p,cell_A,cell_u,node_b, xs_node_cell, xs_node_cell_corner);
		reduction_Min6f4a6c1c_at_0(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,global_Min6f4a6c1c,cell_greek_deltatj);
				Compute_ComputeDt(global_greek_deltat_n_plus_1,global_Min6f4a6c1c);
		ComputeMt(NABLA_NB_NODES_WARP,NABLA_NB_NODES,node_Mt,node_M);
		ComputeBt(NABLA_NB_NODES_WARP,NABLA_NB_NODES,node_bt,node_b);
		YOuterFacesComputations(NABLA_NB_FACES,NABLA_NB_FACES_INNER,NABLA_NB_FACES_OUTER,node_X,node_bt,node_b,node_Mt,node_M, xs_face_node);
		XOuterFacesComputations(NABLA_NB_FACES,NABLA_NB_FACES_INNER,NABLA_NB_FACES_OUTER,node_X,node_Mt,node_bt, xs_face_node);
				Copygreek_deltat_n_plus_1(global_greek_deltat,global_greek_deltat_n_plus_1);
		ComputeU(NABLA_NB_NODES_WARP,NABLA_NB_NODES,node_Mt,node_fu,node_bt);
		Compute_ComputeTn(global_t_n_plus_1,global_t,global_greek_deltat_n_plus_1);
				Copyt_n_plus_1(global_t,global_t_n_plus_1);
		Compute_ComputeXn(NABLA_NB_NODES_WARP,NABLA_NB_NODES,node_X_n_plus_1,node_X,global_greek_deltat,node_fu);
		ComputeFjr(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_F,cell_p,cell_C,cell_A,cell_u,node_fu, xs_cell_node);
				Compute_ComputeEn(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_F,node_fu,cell_E_n_plus_1,cell_E,global_greek_deltat,cell_m, xs_cell_node);
		CopyX_n_plus_1(NABLA_NB_NODES_WARP,NABLA_NB_NODES,node_X,node_X_n_plus_1);
		Compute_ComputeUn(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_F,cell_u_n_plus_1,cell_u,global_greek_deltat,cell_m);
				Copyu_n_plus_1(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_u,cell_u_n_plus_1);
		CopyE_n_plus_1(NABLA_NB_CELLS_WARP,NABLA_NB_CELLS,cell_E,cell_E_n_plus_1);
		//BACKEND_MAIN_POSTINIT
		//BACKEND_MAIN_POSTFIX
		global_time[0]+=*(double*)&global_greek_deltat[0];
		global_iteration[0]+=1;
		//printf("\ntime=%e, dt=%e\n", global_time[0], *(double*)&global_greek_deltat[0]);
	}
	gettimeofday(&et, NULL);
	alltime = ((et.tv_sec-st.tv_sec)*1000.+ (et.tv_usec - st.tv_usec)/1000.0);
	printf("\n\t\33[7m[#%04d] Elapsed time = %12.6e(s)\33[m\n", global_iteration[0]-1, alltime/1000.0);
gettimeofday(&et, NULL);

	if (glvis and global_iteration[0]==0) glvis2DQud(X_EDGE_ELEMS,Y_EDGE_ELEMS,LENGTH,LENGTH,(double*)node_coord,(double*)i2var[glvis_optarg]);
	// ********************************************************
	// * FREE MESH CONNECTIVITY 
	// ********************************************************
	free(xs_cell_node);
	free(xs_node_cell);
	free(xs_node_cell_corner);
	free(xs_cell_next);
	free(xs_cell_prev);
	free(xs_node_cell_and_corner);
	free(xs_face_cell);
	free(xs_face_node);
	free(xs_cell_face);

	// ********************************************************
	// * Free Variables
	// ********************************************************
	free(node_coord);
	free(global_t);
	free(global_t_n_plus_1);
	free(global_greek_deltat_n_plus_1);
	free(global_Min6f4a6c1c);
	free(node_X);
	free(node_X_n_plus_1);
	free(node_X_ic);
	free(node_b);
	free(node_bt);
	free(node_fu);
	free(node_M);
	free(node_Mt);
	free(cell_p_ic);
	free(cell_greek_rho_ic);
	free(cell_V_ic);
	free(cell_c);
	free(cell_m);
	free(cell_p);
	free(cell_greek_rho);
	free(cell_e);
	free(cell_E);
	free(cell_E_n_plus_1);
	free(cell_V);
	free(cell_greek_deltatj);
	free(cell_absC);
	free(cell_u);
	free(cell_u_n_plus_1);
	free(cell_center);
	free(cell_C_ic);
	free(cell_C);
	free(cell_F);
	free(cell_A);

	return 0;
}