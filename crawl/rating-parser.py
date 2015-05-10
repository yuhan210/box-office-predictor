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


def composeProBoxOfficeSearchURL(title):
    # http://pro.boxoffice.com/search?only=movies&q=Captain+America%3A+The+Winter+Soldier
    url = "http://pro.boxoffice.com/search?only=movies&q="
    url += '+'.join(title.split(' '))

    return url

def getPageURLFromSearchURL(url):
    try:
        html_doc = urllib2.urlopen(url).readlines()

    except urllib2.URLError, e:
        # For Python 2.7
            print 'URLError %r' % e
            return None
    except socket.timeout, e:
        # For Python 2.7
            print 'Timeout %r' % e
            return None
    return_url = ''
    for line in html_doc:
        if line.find("<a href='/statistics/movies/") >= 0:
#<a href='/statistics/movies/captain-america-2-2014?q=Captain America: The Winter Soldier'>Captain America: The Winter Soldier</a>
            
            return_url = "http://pro.boxoffice.com" + line.split("'")[1].split('?')[0]
    
    return return_url

def wgetStatPage(stat_url, title):
    print 'Downloading..', stat_url
    pwd = os.getcwd()
    dir_o_folder = os.path.join(pwd, "moviestat_page")
    if not os.path.exists(dir_o_folder):
        os.makedirs(dir_o_folder)
    title = re.sub(r"([\'])",    r'\\\1', title)  
    webpage_path = os.path.join(dir_o_folder, title)
    print webpage_path
    #if not os.path.exists(webpage_path):
    os.system('wget %s -O %s' %(stat_url, webpage_path))

    return webpage_path


def getRatings(title):

    pwd = os.getcwd()
    dir_o_folder = os.path.join(pwd, "moviestat_page")
    html_path = os.path.join(dir_o_folder, title)

    fb_likes = '-1' 
    tweet_count = -1 
    try:
        for line in open(html_path).readlines():
            if line.find('# Likes') >= 0:
                try:
                    fb_likes = line.split('# Likes')[1].split("number")[1].split('>')[1].split('<')[0]
                except IndexError:
                    pass
                    break
                break
    except IOError:
        pass
    
    try:
        for line in open(html_path).readlines():
            if line.find('# Tweets') >= 0:
                try:
                    segs = line.split('Website Comments')[0].split('# Tweets')[1].split('number')
                    for seg in segs:
                        if seg.find('</td><td ') >= 0 and seg.find('tr') < 0:
                            if tweet_count == -1:
                                tweet_count = 0
                            try:
                                
                               value = (seg.split('>')[1].split('<')[0])
                               tweet_count += int(''.join(value.split(',')))
                            except ValueError:
                                print seg
                except IndexError:
                    pass
                    break
                break
    except IOError:
        pass
    return fb_likes, tweet_count 

if __name__ == "__main__":



    movies_data = pd.read_excel("box_office2014.xlsx")
    for title in movies_data['Title']:
        #search_url = composeProBoxOfficeSearchURL(title)
        #stat_url = getPageURLFromSearchURL(search_url) 
        
        title_noblank = '-'.join(title.split('(')[0].split('&')[0].split(' '))
        (fb_likes, tweet_count) = getRatings(title_noblank)
        '''
        if fb_likes.find('-1') >= 0:
             stat_url = getPageURLFromSearchURL(search_url)
             webpage_path = wgetStatPage(stat_url, title_noblank)
             fb_likes = getRatings(title_noblank)
        '''
        print title + "\t" +  fb_likes + "\t" +  str(tweet_count)

