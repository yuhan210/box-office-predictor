import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import imdb
'''
This script searches the box-office earning histories for each director
'''

def getMostRelevantSeach(movie_title, search_results):
    #TODO: use some heuristics to find the best match. Currently returns the first result
    return search_results[0]


def getDirectorBoxEarningHistories(movie_title):
    ia = imdb.IMDb()
    search_results = ia.search_movie(movie_title)
    
    if (len(search_results) > 0):
        mov = getMostRelevantSeach(movie_title, search_results)
        ia.update(mov)
         
        movie_id = mov.getID()
        director = mov['director'][0]
        dir_id = director.getID()
        
        # wget director imdb page

        print dir_id
         
    else:
        return None

if __name__ == "__main__":


    movies_data = pd.read_excel("box_office2014.xlsx")
    title = movies_data['Title'][0]
    movies_data['Director'][0]
    getDirectorBoxEarningHistories(title)
    # for each director, search past movies he/she directed

        # for each directed movie, get the box-office earnings
