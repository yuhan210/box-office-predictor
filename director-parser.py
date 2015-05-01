from bs4 import BeautifulSoup
import urllib2
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import time
import imdb
import os
import re
'''
This script searches the box-office earning histories for each director

python package dependency:
bs4 (beautifulsoup), pandas, imdbpy
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
    os.system('wget %s%s -O %s -q' %(url, dir_id, webpage_path))

    d = getDirectedMovies(webpage_path)    
    

# Parse director webpage
def getDirectedMovies(webpage_path):
    
    html_doc = open(webpage_path).read()
    soup = BeautifulSoup(html_doc)
    
    # find all div id starting with producer-*
    # get movie id <div class="filmo-row odd" id="producer-tt2179136">
    past_movieids = [] 
    for match in soup.find_all('div', id=re.compile('^producer-')):
        past_movieids += [match.get('id').split('-tt')[1]]

    d = {}
    for movie_id in past_movieids:    
        d[movie_id] = getMovieGrossWithMovieID(movie_id) 

    return d

def getMovieGrossWithMovieID(movie_id): 
    url = "http://www.imdb.com/title/tt%s" % (movie_id)
    html_doc = urllib2.urlopen(url).readlines()
    gross = -1
    for line in html_doc:
        if line.find('Gross') >= 0:
            gross = line.split('</h4>')[1].strip()
    return gross

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
