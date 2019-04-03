/**
 * generated by Xtext 2.15.0
 */
package fr.cea.nabla.nabla.provider;


import fr.cea.nabla.nabla.MulOrDiv;
import fr.cea.nabla.nabla.NablaFactory;
import fr.cea.nabla.nabla.NablaPackage;

import java.util.Collection;
import java.util.List;

import org.eclipse.emf.common.notify.AdapterFactory;
import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EStructuralFeature;

import org.eclipse.emf.edit.provider.ComposeableAdapterFactory;
import org.eclipse.emf.edit.provider.IItemPropertyDescriptor;
import org.eclipse.emf.edit.provider.ItemPropertyDescriptor;
import org.eclipse.emf.edit.provider.ViewerNotification;

/**
 * This is the item provider adapter for a {@link fr.cea.nabla.nabla.MulOrDiv} object.
 * <!-- begin-user-doc -->
 * <!-- end-user-doc -->
 * @generated
 */
public class MulOrDivItemProvider extends ExpressionItemProvider {
	/**
	 * This constructs an instance from a factory and a notifier.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public MulOrDivItemProvider(AdapterFactory adapterFactory) {
		super(adapterFactory);
	}

	/**
	 * This returns the property descriptors for the adapted class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public List<IItemPropertyDescriptor> getPropertyDescriptors(Object object) {
		if (itemPropertyDescriptors == null) {
			super.getPropertyDescriptors(object);

			addOpPropertyDescriptor(object);
		}
		return itemPropertyDescriptors;
	}

	/**
	 * This adds a property descriptor for the Op feature.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected void addOpPropertyDescriptor(Object object) {
		itemPropertyDescriptors.add
			(createItemPropertyDescriptor
				(((ComposeableAdapterFactory)adapterFactory).getRootAdapterFactory(),
				 getResourceLocator(),
				 getString("_UI_MulOrDiv_op_feature"),
				 getString("_UI_PropertyDescriptor_description", "_UI_MulOrDiv_op_feature", "_UI_MulOrDiv_type"),
				 NablaPackage.Literals.MUL_OR_DIV__OP,
				 true,
				 false,
				 false,
				 ItemPropertyDescriptor.GENERIC_VALUE_IMAGE,
				 null,
				 null));
	}

	/**
	 * This specifies how to implement {@link #getChildren} and is used to deduce an appropriate feature for an
	 * {@link org.eclipse.emf.edit.command.AddCommand}, {@link org.eclipse.emf.edit.command.RemoveCommand} or
	 * {@link org.eclipse.emf.edit.command.MoveCommand} in {@link #createCommand}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Collection<? extends EStructuralFeature> getChildrenFeatures(Object object) {
		if (childrenFeatures == null) {
			super.getChildrenFeatures(object);
			childrenFeatures.add(NablaPackage.Literals.MUL_OR_DIV__LEFT);
			childrenFeatures.add(NablaPackage.Literals.MUL_OR_DIV__RIGHT);
		}
		return childrenFeatures;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EStructuralFeature getChildFeature(Object object, Object child) {
		// Check the type of the specified child object and return the proper feature to use for
		// adding (see {@link AddCommand}) it as a child.

		return super.getChildFeature(object, child);
	}

	/**
	 * This returns MulOrDiv.gif.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object getImage(Object object) {
		return overlayImage(object, getResourceLocator().getImage("full/obj16/MulOrDiv"));
	}

	/**
	 * This returns the label text for the adapted class.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getText(Object object) {
		String label = ((MulOrDiv)object).getOp();
		return label == null || label.length() == 0 ?
			getString("_UI_MulOrDiv_type") :
			getString("_UI_MulOrDiv_type") + " " + label;
	}


	/**
	 * This handles model notifications by calling {@link #updateChildren} to update any cached
	 * children and by creating a viewer notification, which it passes to {@link #fireNotifyChanged}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void notifyChanged(Notification notification) {
		updateChildren(notification);

		switch (notification.getFeatureID(MulOrDiv.class)) {
			case NablaPackage.MUL_OR_DIV__OP:
				fireNotifyChanged(new ViewerNotification(notification, notification.getNotifier(), false, true));
				return;
			case NablaPackage.MUL_OR_DIV__LEFT:
			case NablaPackage.MUL_OR_DIV__RIGHT:
				fireNotifyChanged(new ViewerNotification(notification, notification.getNotifier(), true, false));
				return;
		}
		super.notifyChanged(notification);
	}

	/**
	 * This adds {@link org.eclipse.emf.edit.command.CommandParameter}s describing the children
	 * that can be created under this object.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected void collectNewChildDescriptors(Collection<Object> newChildDescriptors, Object object) {
		super.collectNewChildDescriptors(newChildDescriptors, object);

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createExpression()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createReal2Constant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createReal3Constant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createVarRef()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createContractedIf()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createOr()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createAnd()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createEquality()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createComparison()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createPlus()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createMinus()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createMulOrDiv()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createModulo()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createParenthesis()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createUnaryMinus()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createNot()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createIntConstant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createRealConstant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createBoolConstant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createReal2x2Constant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createReal3x3Constant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createRealXCompactConstant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createMinConstant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createMaxConstant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createFunctionCall()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__LEFT,
				 NablaFactory.eINSTANCE.createReductionCall()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createExpression()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createReal2Constant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createReal3Constant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createVarRef()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createContractedIf()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createOr()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createAnd()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createEquality()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createComparison()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createPlus()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createMinus()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createMulOrDiv()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createModulo()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createParenthesis()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createUnaryMinus()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createNot()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createIntConstant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createRealConstant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createBoolConstant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createReal2x2Constant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createReal3x3Constant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createRealXCompactConstant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createMinConstant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createMaxConstant()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createFunctionCall()));

		newChildDescriptors.add
			(createChildParameter
				(NablaPackage.Literals.MUL_OR_DIV__RIGHT,
				 NablaFactory.eINSTANCE.createReductionCall()));
	}

	/**
	 * This returns the label text for {@link org.eclipse.emf.edit.command.CreateChildCommand}.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String getCreateChildText(Object owner, Object feature, Object child, Collection<?> selection) {
		Object childFeature = feature;
		Object childObject = child;

		boolean qualify =
			childFeature == NablaPackage.Literals.MUL_OR_DIV__LEFT ||
			childFeature == NablaPackage.Literals.MUL_OR_DIV__RIGHT;

		if (qualify) {
			return getString
				("_UI_CreateChild_text2",
				 new Object[] { getTypeText(childObject), getFeatureText(childFeature), getTypeText(owner) });
		}
		return super.getCreateChildText(owner, feature, child, selection);
	}

}
