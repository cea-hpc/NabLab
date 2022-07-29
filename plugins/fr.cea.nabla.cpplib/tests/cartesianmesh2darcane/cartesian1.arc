<?xml version="1.0"?>
<cas codename="Arcane" xml:lang="fr" codeversion="1.0">
  <arcane>
    <titre>Test Execution directe avec CartesianMeshGenerator</titre>
    <description>Test de la generation de maillages cartesiens</description>
  </arcane>

 <meshes>
   <mesh>
     <generator name="Cartesian2D">
       <nb-part-x>1</nb-part-x> 
       <nb-part-y>1</nb-part-y>
       <origin>0.0 0.0</origin>
       <x><n>4</n><length>20.0</length><progression>1.0</progression></x>
       <y><n>3</n><length>30.0</length><progression>1.0</progression></y>
       <face-numbering-version>4</face-numbering-version>
     </generator>
   </mesh>
 </meshes>

</cas>
