import json
import sys

def replace_value(file1, file2):
    with open(file1, 'r') as f1:
        data1 = json.load(f1)

    with open(file2, 'r') as f2:
        data2 = json.load(f2)

    data1['ConnectionStrings']['Eap.Reporting.ConnectionString']['connectionString'] = \
        data2['ConnectionStrings']['Eap.Reporting.ConnectionString']['connectionString']

    with open(file1, 'w') as f1:
        json.dump(data1, f1, indent=2)

if __name__ == "__main__":
    replace_value(sys.argv[1], sys.argv[2])
