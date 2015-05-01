import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import imdb
import os

'''
This script searches the box-office earning histories for each director
'''

def getMostRelevantSeach(movie_title, search_results):
    #TODO: use some heuristics to find the best match. Currently returns the first result
    return search_results[0]

# Download director imdb webpage based on director_id
def wgetDirectorIMDBPage(dir_id):
    pwd = os.getcwd()
    dir_o_folder = os.path.join(pwd, 'director_pages')
    if not os.path.exists(dir_o_folder):
            os.makedirs(dir_o_folder)

    url = "http://www.imdb.com/name/nm"
    webpage_path = os.path.join(dir_o_folder, dir_id)
    print webpage_path
    os.system('wget %s%s -O %s -q' %(url, dir_id, webpage_path))
   # parseDirectorPage(os.path.join(dir_o_folder, dir_id))    

# Parse director webpage
#def parseDirectorPage(webpage_path):


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
        #http://www.imdb.com/name/nm0000142/
        print dir_id
        wgetDirectorIMDBPage(dir_id)     
    else:
        return None

if __name__ == "__main__":


    movies_data = pd.read_excel("box_office2014.xlsx")
    title = movies_data['Title'][0]
    movies_data['Director'][0]
    getDirectorBoxEarningHistories(title)
    # for each director, search past movies he/she directed

        # for each directed movie, get the box-office earnings
