import subprocess

# Define the tmux command to shift windows to the left
move_window_cmd = "tmux move-window -s {} -t {}"
select_window_cmd = "tmux select-window -t :{}"

cur_window = int(subprocess.check_output('tmux display-message -p "#{window_index}"', shell=True).decode('utf-8'))

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
        break

    j = i + 1
    while j < len(filled_array) and not filled_array[j]:
        j += 1

    if j == len(filled_array):
        break

    filled_array[i] = True
    filled_array[j] = False
    if j == cur_window:
        print(f"Set cur_window from {cur_window} to {i}")
        cur_window = i

    subprocess.run(move_window_cmd.format(j, i), shell=True)

subprocess.run(select_window_cmd.format(cur_window), shell=True)
exit(0)
