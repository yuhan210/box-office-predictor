import pandas as pd 
import numpy as np
import math
import sys


all_mpaa = [u'R', u'PG-13', u'PG', 'Unrated']
all_genres = [u'Action', u'Biography', u'Thriller', u'War', u'Adventure', u'Sci-Fi', u'Animation', u'Comedy', u'Family', u'Fantasy', u'Romance', u'Drama', u'Crime', u'Mystery', u'Musical', u'Sport', u'Horror', u'History', u'Music', u'Western', u'Documentary', u'Short', u'Talk-Show', u'News']

def getDummyVar(all_types, p, mutually_exclusive=True):
    if mutually_exclusive:
        dummy_var = [0 for x in all_types[0:len(all_types)-1]]
        ind = all_types.index(p)
        if ind > 0:
            dummy_var[ind-1] = 1
    else:
        dummy_var = [0 for x in all_types[0:len(all_types)]]
        for g in p.split(', '):
        
            ind = all_types.index(g)
            dummy_var[ind] = 1
    
    return dummy_var    

def createFeatureVec(row):
    features = [row['IMDB ID']]
    features += [row['Gross']]
    features += [row['Total Theaters']]
    features += [row['Opening']]
    features += [row['Opening Theaters']]
    features += [row['runtime']]
    if type(row['MPAA']) == float and math.isnan(row['MPAA']):
        features.extend(getDummyVar(all_mpaa, 'Unrated'))
    else:
        features.extend(getDummyVar(all_mpaa, row['MPAA']))

    features.extend(getDummyVar(all_genres, row['Genre'], False))
    features += [row['Director past ave box-office earnings']]

    if type(row['budget']) == float and math.isnan(row['budget']):
        features += [-1]
    else:
        features += [row['budget']]
    
    return ' '.join([str(x) for x in features])

if __name__ == "__main__":

    if len(sys.argv) != 4:
        print 'Usage:', sys.argv[0], ' feature.xlsx_file train_path test_path'
        exit(11)

    
    df = pd.read_excel(sys.argv[1])
    train_fh = open(sys.argv[2], 'w')
    test_fh = open(sys.argv[3], 'w')
    for index, row in df.iterrows():
        if np.random.uniform() > 0.4:    
            train_fh.write(createFeatureVec(row) + '\n')
        else:
            test_fh.write(createFeatureVec(row) + '\n')


    train_fh.close()
    test_fh.close()
