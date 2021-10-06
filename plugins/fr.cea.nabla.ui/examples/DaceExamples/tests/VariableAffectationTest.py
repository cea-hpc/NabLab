import pytest
import numpy as np
import os
import sys
sys.path.insert(0, '/home/meynardr/workspaces/NabLab/plugins/fr.cea.nabla.ui/examples/DaceExamples/src-gen-python/dace/variableaffectations')
from VariableAffectations import *
from numpy.testing import assert_array_equal


def test_valOutput_test1_using_pytest():
    assert valOutput_test1 == 24, "Resultant should be 24" 
    
def test_valOutput_test2_using_pytest():
    assert valOutput_test2 == 27, "Resultant should be 27"  
    
def test_valOutput_test3_using_pytest():
    assert valOutput_test3 == 20.0, "Resultant should be 20.0"   

def test_valOutput_test4_using_pytest():
    assert valOutput_test4 == 84.0, "Resultant should be 84.0"  
    
def test_valOutput_test5_using_pytest():
    assert np.array_equal(valOutput_test5, np.array([32., 32., 32., 32., 32.])), "Resultant should be [32., 32., 32., 32., 32.]" 
    
def test_valOutput_test6_using_pytest():
    assert np.array_equal(valOutput_test6, np.array([14., 14., 14., 14., 14.])), "Resultant should be [14., 14., 14., 14., 14.]" 

def test_valOutput_test7_using_pytest():
    assert np.array_equal(valOutput_test7, np.array([22, 22, 22, 22, 22])), "Resultant should be [22, 22, 22, 22, 22]" 

def test_valOutput_test8_using_pytest():
    assert np.array_equal(valOutput_test8, np.array([22, 22, 22, 22, 22])), "Resultant should be [22, 22, 22, 22, 22]" 
    
def test_valOutput_test9_using_pytest():
    assert np.array_equal(valOutput_test9, np.array([5.0, 7.0, 9.0, 11.0, 13.0])), "Resultant should be [5.0, 7.0, 9.0, 11.0, 13.0]" 
    
def test_valOutput_test10_using_pytest():
    assert np.array_equal(valOutput_test10, np.array([5.0, 7.0, 9.0, 11.0, 13.0])), "Resultant should be [5.0, 7.0, 9.0, 11.0, 13.0]" 
    
def test_valOutput_test11_using_pytest():
    assert np.array_equal(valOutput_test11, np.array([11, 17, 9, 19, 13])), "Resultant should be [11, 17, 9, 19, 13]" 

def test_valOutput_test12_using_pytest():
    assert np.array_equal(valOutput_test12, np.array([19, 28, 16, 31, 22])), "Resultant should be [19, 28, 16, 31, 22]" 
    

def test_valOutput_test13_using_pytest():
    assert np.array_equal(valOutput_test13, np.array([[15., 15., 15., 15., 15.],
                                                      [15., 15., 15., 15., 15.],
                                                      [15., 15., 15., 15., 15.],
                                                      [15., 15., 15., 15., 15.],
                                                      [15., 15., 15., 15., 15.],
                                                      [15., 15., 15., 15., 15.]])), '''Resultant should be [[15. 15. 15. 15. 15.]
                                                                                                     [15. 15. 15. 15. 15.]
                                                                                                     [15. 15. 15. 15. 15.]
                                                                                                     [15. 15. 15. 15. 15.]
                                                                                                     [15. 15. 15. 15. 15.]
                                                                                                     [15. 15. 15. 15. 15.]]'''
def test_valOutput_test14_using_pytest():
    assert np.array_equal(valOutput_test14, np.array([[21., 21., 21., 21., 21.],
                                                      [21., 21., 21., 21., 21.],
                                                      [21., 21., 21., 21., 21.],
                                                      [21., 21., 21., 21., 21.],
                                                      [21., 21., 21., 21., 21.],
                                                      [21., 21., 21., 21., 21.]])), '''Resultant should be [[21., 21., 21., 21., 21.]
                                                                                                            [21., 21., 21., 21., 21.]
                                                                                                            [21., 21., 21., 21., 21.]
                                                                                                            [21., 21., 21., 21., 21.]
                                                                                                            [21., 21., 21., 21., 21.]
                                                                                                            [21., 21., 21., 21., 21.]]'''
    
def test_valOutput_test15_using_pytest():
    assert np.array_equal(valOutput_test15, np.array([[21, 21, 21, 21, 21],
                                                      [21, 21, 21, 21, 21],
                                                      [21, 21, 21, 21, 21],
                                                      [21, 21, 21, 21, 21],
                                                      [21, 21, 21, 21, 21],
                                                      [21, 21, 21, 21, 21]])), '''Resultant should be [[21, 21, 21, 21, 21]
                                                                                                       [21, 21, 21, 21, 21]
                                                                                                       [21, 21, 21, 21, 21]
                                                                                                       [21, 21, 21, 21, 21]
                                                                                                       [21, 21, 21, 21, 21]
                                                                                                       [21, 21, 21, 21, 21]]'''
    
def test_valOutput_test16_using_pytest():
    assert np.array_equal(valOutput_test16, np.array([[11, 11, 11, 11, 11],
                                                      [11, 11, 11, 11, 11],
                                                      [11, 11, 11, 11, 11],
                                                      [11, 11, 11, 11, 11],
                                                      [11, 11, 11, 11, 11],
                                                      [11, 11, 11, 11, 11]])), '''Resultant should be [[11, 11, 11, 11, 11]
                                                                                                       [11, 11, 11, 11, 11]
                                                                                                       [11, 11, 11, 11, 11]
                                                                                                       [11, 11, 11, 11, 11]
                                                                                                       [11, 11, 11, 11, 11]
                                                                                                       [11, 11, 11, 11, 11]]'''

def test_valOutput_test17_using_pytest():
    assert np.array_equal(valOutput_test17, np.array([[5.0, 7.0],
                                                      [11.0, 13.0]])), '''Resultant should be [[5.0, 7.0]
                                                                                               [11.0, 13.0]]'''
    
def test_valOutput_test18_using_pytest():
    assert np.array_equal(valOutput_test18, np.array([[7.0, 10.0],
                                                      [16.0, 19.0]])), '''Resultant should be [[7.0, 10.0]
                                                                                               [16.0, 19.0]]'''

def test_valOutput_test19_using_pytest():
    assert np.array_equal(valOutput_test19, np.array([[9, 11],
                                                      [17, 13]])), '''Resultant should be [[9, 11]
                                                                                            [17, 13]]'''

def test_valOutput_test20_using_pytest():
    assert np.array_equal(valOutput_test20, np.array([[13, 16],
                                                      [25, 19]])), '''Resultant should be [[13, 16]]
                                                                                            [25, 19]]'''

# driver code
if __name__ == '__main__':
   
    test_valOutput_test1_using_pytest()
    test_valOutput_test2_using_pytest()
    test_valOutput_test3_using_pytest()
    test_valOutput_test4_using_pytest()
    test_valOutput_test5_using_pytest()
    test_valOutput_test6_using_pytest()
    test_valOutput_test7_using_pytest()
    test_valOutput_test8_using_pytest()
    test_valOutput_test9_using_pytest()
    test_valOutput_test10_using_pytest()
    test_valOutput_test11_using_pytest()
    test_valOutput_test12_using_pytest()
    test_valOutput_test13_using_pytest()
    test_valOutput_test14_using_pytest()
    test_valOutput_test15_using_pytest()
    test_valOutput_test16_using_pytest()
    test_valOutput_test17_using_pytest()
    test_valOutput_test18_using_pytest()
    test_valOutput_test19_using_pytest()
    test_valOutput_test20_using_pytest()