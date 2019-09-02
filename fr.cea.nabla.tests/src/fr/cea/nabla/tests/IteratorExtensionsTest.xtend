package fr.cea.nabla.tests

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(NablaInjectorProvider))
class IteratorExtensionsTest 
{
	val model = 
	'''
	module Test;
	
	items { cell, node, face }
	
	connectivities {
		cells: → {cell};
		nodes: → {node};
		faces: → {face};
		nodesOfCell: cell → {node};
		cellsOfNode: node → {cell};
		neighbourCells: cell → {cell};
		commonFace: cell × cell → face;
	}
	
	'''
	+ TestUtils::mandatoryOptions +
	'''
	
	ℝ x{cells}, f{cells}, Cjr{cells,nodesOfCell};
	ℝ[2] X{nodes}, u{cells};
	ℝ surface{faces};
	ℝ a;
	
	J1: ∀j∈cells(), x{j} = 2.0;
	J2: ∀j∈cells(), ∀r∈nodesOfCell(j), Cjr{j,r} = 3.0;
	J3: ∀r∈nodes(), ∀j∈cellsOfNode(r), Cjr{j,r} = 1.0;
	J4: ∀j∈cells(), u{j} = 0.5 * ∑{r∈nodesOfCell(j)}(X{r} - X{r+1});
	J5: ∀j1∈cells(), f{j1} = a * ∑{j2∈neighbourCells(j1), cf=commonFace(j1,j2)}( (x{j2}-x{j1}) / surface{cf});	
	'''
	
	
}