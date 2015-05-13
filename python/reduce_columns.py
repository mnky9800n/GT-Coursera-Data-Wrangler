# Version 2.0
# Now contains more better

def reduce_columns(question):
    """
    Coursera formats survey responses as columns per available responses
    for multiple choice questions. This function reduces the dimensionality
    of each question to a single column.

    Typically the input should look like:

    question = reduce_columns(survey[survey_questions['Which of the following descriptions best characterizes you?']])

    The output is a numpy array. This makes it easy to convert to an indexed pandas Series.
    """
    single_column = []

    for row in question.values:
        """
        row[0] will always be the session_user_id
        """
        #print 'row: ', row

        response_index = []

        for i, val in enumerate(row):
            

            if val == 1:
                #print 'i, val: ', i, val
                response_index.append(i)
                #print 'ri in loop: ', response_index
        
        #print 'ri after loop: ', response_index
        #print 'len: ', len(response_index)

        if len(response_index) == 0:
            single_column.append((row[0], 'No Response.'))
        
        else:
            single_column.append((row[0], question.columns[response_index[-1]]))

    return np.array(single_column)
