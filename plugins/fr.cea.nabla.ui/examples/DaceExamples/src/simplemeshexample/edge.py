'''
Created on 9 déc. 2021

@author: meynardr
'''

class Edge:
    '''
    classdocs
    '''


    def __init__(self, id1, id2):
        '''
        Constructor
        '''
        self.__id1 = id1
        self.__id2 = id2
        
    def __str__(self):
        return [self.__id1, self.__id2]