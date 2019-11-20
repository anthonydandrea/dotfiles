import os
import json
import sys

with open(sys.path[0]+"/"+"current_setting.json", "r+") as f:
    data = json.load(f)

    if len(sys.argv) < 2:
        exit("Must provide an operation (+, -, -s) and optionally a value (1000 <= i <= 25000)")

    operation = sys.argv[1]

    if operation == '-r':
        os.system('redshift '+' '.join([k + ' ' + str(val) for k,val in data.items()]))
        exit(0)

    if len(sys.argv) > 2:
        change = sys.argv[2]
    else:
        change = 400

    newVal = data['-O']

    try:
        int(change)
    except:
        exit("Bad change value, should be number: "+change)

    if operation == '+':
        newVal += int(change)
    elif operation == '-':
        newVal -= int(change)
    elif operation == '-s':
        newVal = int(change)
    else:
        exit('Bad operation: '+operation)

    newVal = max(min(25000,newVal), 1000)

    data['-O'] = newVal

    f.seek(0)
    json.dump(data,f)
    f.truncate()

    os.system('redshift '+' '.join([k + ' ' + str(val) for k,val in data.items()]))
