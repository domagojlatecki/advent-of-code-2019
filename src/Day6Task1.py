import sys

orbits = [x.strip().split(")") for x in sys.stdin]
direct_orbits = {}

for parent, child in orbits:
    if parent not in direct_orbits:
        direct_orbits[parent] = [child]
    else:
        direct_orbits[parent].append(child)

total_num_orbits = 0

for parent in direct_orbits:
    all_children = set(direct_orbits[parent])
    last_size = 0

    while last_size != len(all_children):
        last_size = len(all_children)
        
        for child in all_children:
            if child in direct_orbits:
                all_children = all_children | set(direct_orbits[child])

    total_num_orbits += len(all_children)

print(total_num_orbits)
