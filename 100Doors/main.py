import numpy as np

from os import system, name
from time import sleep

# define our clear function
def clear():
  
    # for windows
    if name == 'nt':
        _ = system('cls')
  
    # for mac and linux(here, os.name is 'posix')
    else:
        _ = system('clear')

door = np.repeat(False, 100)
num = np.repeat(0,10)
j = 0
for i in range(0,100): #visit
    for index in range(i,100): #doors
        if (index+1)%(i+1) == 0:
            door[index] = 1 - door[index]
    if door[i]:
        num[j] = i+1
        j = j+1
    # clear()
    # print(f"Door = {i+1}\n")
    # print(door)
    # sleep(1)

print(door)
print("Total = ",sum(door))
print(f"Doors = {num}")
input(str("="*10 + "Press any key to end." + "="*10))