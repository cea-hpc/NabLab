package fr.cea.nabla.javalib.mesh.test;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

@RunWith(Suite.class)

@Suite.SuiteClasses({
   CartesianMesh2DGeneratorTest.class,
   EdgeTest.class,
   QuadTest.class
})

public class JavalibTestSuite {
}