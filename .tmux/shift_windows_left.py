import subprocess

# Define the tmux command to shift windows to the left
tmux_command = "tmux move-window -s {} -t {}"

# Get the total number of windows in your tmux session
raw_windows = subprocess.check_output("tmux list-windows", shell=True).decode('utf-8').splitlines()
windows = list(map(lambda x: int(x[:x.find(':')]), raw_windows))
filled_array = [False] * (windows[-1]+1)
for w in windows:
    filled_array[w] = True

i = j = 1;

while i < len(filled_array):
    while i < len(filled_array) and filled_array[i]:
        i += 1
    if i == len(filled_array):
        exit(0)

    j = i + 1
    while j < len(filled_array) and not filled_array[j]:
        j += 1

    if j == len(filled_array):
        exit(0)

    filled_array[i] = True
    filled_array[j] = False
    # print(f'Move {j} to {i}')

    subprocess.run(tmux_command.format(j, i), shell=True)

exit(0)
