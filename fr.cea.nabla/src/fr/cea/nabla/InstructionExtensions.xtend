package fr.cea.nabla

import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import java.util.ArrayList
import java.util.List

class InstructionExtensions 
{
	// allVars
	def dispatch List<Var> getAllVars(ScalarVarDefinition it) { return #[variable] }
	def dispatch List<Var> getAllVars(VarGroupDeclaration it) { return variables }
	def dispatch List<Var> getAllVars(InstructionBlock it) 
	{  
		val _allVars = new ArrayList<Var>
		for (instruction : instructions)
			_allVars.addAll(instruction.allVars)
		return _allVars
	}
	def dispatch List<Var> getAllVars(Affectation it) { return #[] }
	def dispatch List<Var> getAllVars(Loop it) { return body.allVars }
	def dispatch List<Var> getAllVars(If it) { return #[]}
	
	//allAffectations
	def dispatch List<Affectation> allAffectations(ScalarVarDefinition it) { return #[] }
	def dispatch List<Affectation> allAffectations(VarGroupDeclaration it) { return #[] }
	def dispatch List<Affectation> allAffectations(InstructionBlock it) 
	{  
		val _allAffectations = new ArrayList<Affectation>
		for (instruction : instructions)
			_allAffectations.addAll(instruction.allAffectations)
		return _allAffectations
	}
	def dispatch List<Affectation> allAffectations(Affectation it) { return #[it] }
	def dispatch List<Affectation> allAffectations(Loop it) { return body.allAffectations }
	def dispatch List<Affectation> allAffectations(If it) { return #[]}
}