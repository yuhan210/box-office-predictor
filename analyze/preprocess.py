import pandas as pd 
import numpy as np

if __name__ == "__main__":

    df = pd.read_excel("Features.xlsx")
    ids = []
    for mid in df['IMDB ID']:
        ids += [mid]
    for index, row in df.iterrows():
        earnings = []
        if type(row['Director past ave box-office earnings']) is not float:
            chunks = row['Director past ave box-office earnings'].split(';')
            for chunk in chunks:
                if int(chunk.split(':')[0]) not in ids:
                    earnings += [int(''.join(chunk.split(':')[1].split(',')))]
        if len(earnings) == 0:
            print -1
        else:
            print np.mean(earnings)
            #print earnings
    #for history in df['Director past ave box-office earnings']:
