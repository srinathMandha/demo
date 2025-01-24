import json
import sys

def replace_values(appsettings_file, env_file, environment_value):
    with open(appsettings_file, 'r') as f1:
        data1 = json.load(f1)

    with open(env_file, 'r') as f2:
        data2 = json.load(f2)

    # Replace the connectionString from the environment-specific file
    data1['ConnectionStrings']['Eap.Reporting.ConnectionString']['connectionString'] = \
        data2['ConnectionStrings']['Eap.Reporting.ConnectionString']['connectionString']

    # Replace the Environment value from GitHub Actions input
    data1['AppSettings']['Environment'] = environment_value

    with open(appsettings_file, 'w') as f1:
        json.dump(data1, f1, indent=2)

if __name__ == "__main__":
    replace_values(sys.argv[1], sys.argv[2], sys.argv[3])
