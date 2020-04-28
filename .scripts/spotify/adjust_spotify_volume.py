import sys
import os
import json

os.chdir(os.path.dirname(os.path.abspath(__file__)))


def get_current_volume():
    with open('volume.json') as f:
        return json.load(f)['volume']


def write_volume(vol):
    with open('volume.json', 'w') as outfile:
        json.dump({"volume": vol}, outfile)

def get_api_secret():
     with open('secret.txt') as f:
        return f.readline()

def main():
    if not len(sys.argv) == 2 or sys.argv[1] not in ('+', '-'):
        exit()

    volume = get_current_volume()
    if sys.argv[1] == '+':
        volume = min(100, volume+10)
    else:
        volume = max(0, volume-10)

    write_volume(volume)
    os.system('curl -X "PUT" "https://api.spotify.com/v1/me/player/volume?volume_percent={}" -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer {}"'.format(volume, get_api_secret()))


if __name__ == '__main__':
    main()
