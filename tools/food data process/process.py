import pandas as pd

custom = pd.read_csv('assets/custom.csv', header=0)
original = pd.read_csv('assets/original.csv', header=0)

# print(custom.head())
# print(original.head())

custom_ = custom[['calories', 'fat', 'carbohydrate', 'protein']]
original_ = original[['calories', 'fat', 'carbohydrate', 'protein']]

custom_row = custom.shape[0]
original_row = original.shape[0]

for i in range(custom_row):
    source = custom_.iloc[i:i + 1, :].values.tolist()[0]
    for j in range(original_row):
        target = original_.iloc[j:j + 1, :].values.tolist()[0]
        if source == target:
            print(original[['food_url']].iloc[j:j + 1, :].values.tolist()[0])

    # print(source)

# print(custom_)
# print(custom_.iloc[0:1,:].values.tolist()[0] == [116.0, '0.3', 25.9, '2.6'])
