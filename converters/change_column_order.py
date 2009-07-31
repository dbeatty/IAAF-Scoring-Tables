#! /usr/bin/python

'''
This script converts the file "2008_iaaf_scoring_tables.txt" in revision a85e85a19898d278320081c89b5017f5407679ea
to the following revision
'''


#****************************************************************************
# Global constants
#****************************************************************************

kInputFile = '2008_iaaf_scoring_tables.txt'
kOutputFile = 'mod_' + kInputFile
kEndl = '\n'
kDelimiter = '\t'
kPointsColumnName = "Points"
kMen = "MEN"
kWomen = "WOMEN"

'''
Open the file of interest
Split into sections based on headers
Remove page number
Move "points" columns to the front of the section
Further split into sections of headers
Write the new results
'''
    

####################################################
def writeFile(filename, contents):
    '''
    '''

    # Open the file, write the contents, and close
    f = open(filename, 'w')
    
    f.write(contents)
    
    f.close()


####################################################
def parseFile(filename):
    '''
    Parse the file and change the format slightly
    '''

    f = open(filename, 'r')
    
    newContents = ""
    headers = {}
    section = []
    for line in f.readlines():
        
        # At the end of a section, parse its contents
        if line.startswith(kMen) or line.startswith(kWomen):
            
            if (section != []):
                newContents += parseSection(section, headers)
                section = []

        # Add this line to the list
        section.append(line)
        
    f.close()
    
    # Finish processing any remaining data
    newContents += parseSection(section, headers)

    return newContents

####################################################
def parseSection(section, headers):
    '''
    '''

    newSection = ""
    pointsFirst = True
    
    # Get the group name
    group = section[0].strip()

    # Get the page number (and discard)
    pageNumber = section[1].strip()
    
    # Get the column headings
    header = section[2].strip()
    
    # See if the columns header starts with "Points" or ends with "Points"
    pointsFirst = header.startswith(kPointsColumnName)
    
    if not pointsFirst:
        header = switchLine(header)
    
    # Add the group name and column headers if they don't exist
    if not group in headers:
        
        newSection += kEndl + group + kEndl
        newSection += header + kEndl
        
        # Add it to the list of group names we've already seen
        headers[group] = True
    
    for line in section[3:]:

        # Move the points column to the front of the list if it isn't already
        if not pointsFirst:
            line = switchLine(line.strip()) + kEndl
            
        newSection += line
            
        pass
        
    return newSection
    
    
####################################################
def switchLine(delimitedText):
    '''
    Take the last item in the list and make it the first
    '''
    
    # Split up the delimited text
    textList = delimitedText.strip().split(kDelimiter)
    
    # Remove the last item from the list
    lastIndex = len(textList) - 1
    lastItem = textList.pop(lastIndex)
    
    # Add the last item to the front of the list
    textList.insert(0, lastItem)
    
    return kDelimiter.join(textList)


####################################################
def main():
    '''
    '''

    contents = parseFile(kInputFile)
    writeFile(kOutputFile, contents)


####################################################
if '__main__' == __name__:
    
    main()

    

#
# EOF
