# Solucion Challenge 2: Euro 2012

## Importando Datos
```python
import pandas as pd

# Definimos origen y los nombres de la tabla y la base de datos
url = 'https://raw.githubusercontent.com/guipsamora/pandas_exercises/master/02_Filtering_%26_Sorting/Euro12/Euro_2012_stats_TEAM.csv'
# cargamos los datos en un dataframe
datos_df = pd.read_csv(url, sep=',')
```

## Limpieza de datos
```python
# Contamos la cantidad de datos nulos por atributos
print(datos_df.isna().sum())

# visualizamos el registro que le falta un dato
print(datos_df[['Team','Clearances off line']])

# como son pocos registros y la moda vendria siendo 0.0 para este atributo, le asignamos ese valor a Croatia
datos_df.loc[datos_df['Team'] == 'Croatia', 'Clearances off line'] = 0.0
```

## Preguntas del Stakeholder
### Question 1: How many teams participated in the Euro2012?

```python
print('Hay ',datos_df.shape[0],' equipos participaron en el Euro2012')
```

### Question 2: What is the number of columns in the dataset?

```python
print('hay ',datos_df.shape[1],' columnas en el dataset')
```

### Question 3: View only the columns Team, Yellow Cards and Red Cards and assign them to a dataframe called discipline.

```python
print(datos_df[['Team','Yellow Cards','Red Cards']])
```

### Question 4: Sort the teams by Red Cards, then to Yellow Cards.

```python
datos_df = datos_df.sort_values(by=['Red Cards', 'Yellow Cards'],ascending=[False,False])
```

### Question 5: Calculate the mean Yellow Cards given per Team.

```python
media_tarjetas_amarillas=datos_df.groupby('Team')['Yellow Cards'].mean()
```

### Question 6: Filter teams that scored more than 6 goals.

```python
teams_more_6_goals= datos_df[datos_df['Goals']>6]
print(teams_more_6_goals[['Team','Goals']])
```

### Question 7: Select the teams that start with the letter G.

```python
teams_letter_g = datos_df[datos_df['Team'].str.startswith('G')]
print(teams_letter_g['Team'])
```

### Question 8: Select the first 7 columns.

```python
print(datos_df.iloc[:,0:7])
```

### Question 9: Select all columns except the last 3.

```python
print(datos_df.iloc[:,:-3])
```

### Question 10: Present only the Shooting Accuracy from England, Italy and Russia.

```python
filtro = datos_df['Team'].isin(['England', 'Italy', 'Russia'])
print(datos_df.loc[filtro, ['Team', 'Shooting Accuracy']])
```

