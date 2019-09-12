The content of the folder src-gen must not be deleted.

The file fr.cea.nabla.ir.ir.impl.ConnectivityVariableImpl overrides the method getSupports to bypass
an EMF bug that not allows duplicated elements even if the ecore unique attribute is set to false.

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated NOT FIXME workaround BUG 89325
	 */
	@SuppressWarnings("serial")
	public EList<Connectivity> getSupports() {
		if (supports == null) {
			supports = new EObjectResolvingEList<Connectivity>(Connectivity.class, this, IrPackage.CONNECTIVITY_VARIABLE__SUPPORTS) {
				@Override
	    		protected boolean isUnique() { return false; }
			};
		}
		return supports;
	}

