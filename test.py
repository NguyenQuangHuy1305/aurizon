import pandas as pd

# # Load the CSV file into a pandas DataFrame
# df = pd.read_csv('Book3.csv')

# # Save the DataFrame as a PKL file
# df.to_pickle('all_possible_activities.pkl')

df = pd.read_pickle('all_possible_activities.pkl')

# Display the first 10 rows of the DataFrame
print(df.head(10))