'''
Created on 10 déc. 2021

@author: meynardr
'''

class Quad:
    '''
    classdocs
    '''


    def __init__(self, id1, id2, id3, id4):
        '''
        Constructor
        '''
        self.__id1 = id1
        self.__id2 = id2
        self.__id3 = id3
        self.__id4 = id4
        
    def __str__(self):
        return [self.__id1, self.__id2, self.__id3, self.__id4]