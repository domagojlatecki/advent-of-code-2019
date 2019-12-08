import sys

orbits = [x.strip().split(")") for x in sys.stdin]
connections = {}

for parent, child in orbits:
    if parent not in connections:
        connections[parent] = [child]
    else:
        connections[parent].append(child)

    if child not in connections:
        connections[child] = [parent]
    else:
        connections[child].append(parent)

current_reachable = set(connections['YOU'])
visited = set(['YOU'])
num_transfers = 0

while 'SAN' not in current_reachable:
    next_items = []

    for curr in (current_reachable - visited):
        next_items += connections[curr]

    next_items = set(next_items)
    visited |= current_reachable
    current_reachable = current_reachable | next_items
    num_transfers += 1

print(num_transfers - 1)
