<?xml version="1.0"?>
<case codename="Variables" codeversion="1.0" xml:lang="en">
	<arcane>
		<title>Variables test</title>
		<timeloop>VariablesLoop</timeloop>
	</arcane>
 
 	<meshes>
		<mesh>
			<generator name="Cartesian2D">
				<nb-part-x>1</nb-part-x>
				<nb-part-y>1</nb-part-y>
				<face-numbering-version>4</face-numbering-version>
				<origin>0.0 0.0</origin>
				<x><n>100</n><length>1.0</length></x>
				<y><n>10</n><length>0.1</length></y>
			</generator>
		</mesh>
 	</meshes>
 
	<variables>
		<opt-dim>2</opt-dim>
		<opt-vect1>1.0 1.0</opt-vect1>
		<opt-vect2>2.0 2.0</opt-vect2>
	</variables>
</case>
