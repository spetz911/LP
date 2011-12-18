#! /usr/bin/python3.1
# -*- coding: utf-8 -*-

from copy import copy, deepcopy
from functools import reduce

def permute(L):
	S = set(L)
	if (len(S) <= 1):
		return [list(S)]
	res = []
	T = copy(S)
	for xx in S:
		D = copy(T)
		D.discard(xx)
		zz = permute(D)
		for z in zz:
			#~ z.append(xx)
			z.append(xx)
			res.append( z )
	return res

def println(X):
	for xx in X: print(xx)

def test( pp, ww, rr, hh):
#	for i in range(len(pp)):
#		if (hh[i] == bb[i])or(bb[i] == rr[i])or(rr[i]==hh[i]):
#			return False
	#~ GSOM 1 lvl
	for i in range(len(pp)):
		#~ if( ww[i]=='proza')and(not(rr[i]=='poet')):return False
		if( ww[i]=='proza')and(not(rr[i]!='astronom')):return False
		if( ww[i]=='proza')and(not(hh[i]!='astronom')):return False
		if( ww[i]=='poet')and(not(rr[i]=='drama')):return False
	#~ GSOM 2 lvl
	index = dict( zip( pp, range(len(pp)) ) )
	if(not(rr[index['alexeev'] ]==hh[index['borisov'] ])): return False
	if(not(hh[index['alexeev'] ]==rr[index['borisov'] ])): return False
	if(not(hh[index['borisov'] ]==ww[index['dmitriev'] ])): return False
	if(ww[index['dmitriev']] == 'proza' ): return False

	return True

		
def main():
	
	people = ['alexeev', 'borisov', 'konstan', 'dmitriev']
	books  = ['astronom', 'poet', 'proza', 'drama']
	
	count = 0
	for ww in permute(books):
		if(ww[3]=='proza'): continue
		#~ Dmitriev not write proza
		for rr in permute(books):
			if(ww[0]==rr[0]): continue
			if(ww[1]==rr[1]): continue
			if(ww[2]==rr[2]): continue
			if(ww[3]==rr[3]): continue
			#~ optimize
			for hh in permute(books):
				if(hh[0]==ww[0]): continue
				if(hh[1]==ww[1]): continue
				if(hh[2]==ww[2]): continue
				if(hh[3]==ww[3]): continue
				#~ optimize
				count += 1
				t = test( people, ww, rr, hh)
				if(t): println( [people, ww, rr, hh] ); print()
				#~ if (count>9000):return 0
	print("FINISH in %d iterations."%count)
	print()
	print("1 is name")
	print("2 is who")
	print("3 is read")
	print("4 is have")
	
	return 0

main()