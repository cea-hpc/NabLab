The content of the folder src-gen must not be deleted.

The file fr.cea.nabla.ir.ir.impl.ConnectivityTypeImpl overrides the method getConnectivities to bypass
an EMF bug that not allows duplicated elements even if the ecore unique attribute is set to false.

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated NOT 
	 * FIXME workaround BUG 89325
	 */
	@SuppressWarnings("serial")
	public EList<Connectivity> getConnectivities() {
		if (connectivities == null) {
			connectivities = new EObjectResolvingEList<Connectivity>(Connectivity.class, this, IrPackage.CONNECTIVITY_TYPE__CONNECTIVITIES) {
				@Override
	    		protected boolean isUnique() { return false; }
			};
		}
		return connectivities;
	}

Same problem for method getIterators of ArgOrVarRefImpl.
