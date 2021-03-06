from bs4 import BeautifulSoup
import urllib2
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import socket
import time
import imdb
import sys
import os
import re
'''
This script searches the box-office earning histories for each director

python package dependency:
bs4 (beautifulsoup), pandas, imdbpy
'''

limit = 11

def getMostRelevantSeach(movie_title, search_results):
    #TODO: use some heuristics to find the best match. Currently returns the first result
    return search_results[0]


# Download director imdb webpage based on director_id
# Return the path to the webpage
def wgetDirectorIMDBPage(dir_id):
    pwd = os.getcwd()
    dir_o_folder = os.path.join(pwd, 'director_pages')
    if not os.path.exists(dir_o_folder):
            os.makedirs(dir_o_folder)
    
    webpage_path = os.path.join(dir_o_folder, dir_id)
    if not os.path.exists(webpage_path):
        url = "http://www.imdb.com/name/nm"
        os.system('wget %s%s -O %s -q' %(url, dir_id, webpage_path))

    return webpage_path


# Parse director webpage
# Return a list of directed movie IDs
def getDirectedMovies(webpage_path):
    
    html_doc = open(webpage_path).read()
    soup = BeautifulSoup(html_doc)
    
    # find all div id starting with producer-*
    # get movie id <div class="filmo-row odd" id="producer-tt2179136">
    past_movieids = [] 
    for match in soup.find_all('div', id=re.compile('^producer-')):
        past_movieids += [match.get('id').split('-tt')[1]]

    return past_movieids

# Get the box-office earnings of a movie
# Return gross
def getMovieGrossWithMovieID(movie_id): 
    url = "http://www.imdb.com/title/tt%s" % (movie_id)
    gross = -1
    
    try:
        html_doc = urllib2.urlopen(url).readlines()
    except urllib2.URLError, e:
        # For Python 2.7
            print 'URLError %r' % e
            return -1
    except socket.timeout, e:
        # For Python 2.7
            print 'Timeout %r' % e
            return -1 
    for line in html_doc:
        if line.find('Gross') >= 0:
            #print line
            if line.find('$') >= 0:
                gross = line.split('$')[1].strip() 
            #elif line.find('pound;') >= 0:
            #    gross = line.split('pound;')[1].strip() 
            break
    
    return gross


def getDirectorBoxEarningHistories(movie_title):
    ia = imdb.IMDb()
    movie_title = re.sub(r"([\'])",    r'\\\1', movie_title)  
    search_results = ia.search_movie(movie_title)
    
    if (len(search_results) > 0):
        mov = getMostRelevantSeach(movie_title, search_results)
        ia.update(mov)
         
        movie_id = mov.getID()
        if not mov.has_key('director'):
            return (None, None)
        director = mov['director'][0]
        dir_id = director.getID()
        
        #print dir_id
        webpage_path = wgetDirectorIMDBPage(dir_id)     
        directed_movieids = getDirectedMovies(webpage_path)    
        
        earnings = {}
        for mid in directed_movieids:
            #print earnings           
            if len(earnings) == limit:
                break
            
            gross = getMovieGrossWithMovieID(mid)
            if gross != -1:
                earnings[mid] = gross
        
        return (director, earnings)
    else:
        return (None, None)

if __name__ == "__main__":


    if len(sys.argv) != 2:
        print 'Usage:', sys.argv[0], ' outputfile'
        exit(11)

    out_file = open(sys.argv[1],'w')
    movies_data = pd.read_excel("box_office2014.xlsx")
    for title in movies_data['Title'][178:]:
        print title
        (director, earnings) = getDirectorBoxEarningHistories(title)
        if director == None:
            out_str = '%s\n' % (title)
        else:    
            earnings_str = ';'.join([x + ':' + earnings[x] for x in earnings])
            out_str = '%s\t%s\t%s\n' % (title, director, earnings_str)
        out_file.write(out_str.encode('utf8'))
        out_file.flush()
    out_file.close()
