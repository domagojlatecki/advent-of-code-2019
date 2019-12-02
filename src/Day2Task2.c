#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_INPUT_SIZE 1024
#define TARGET 19690720

int *parse_input(char *input) {
    int len = strlen(input) + 1;

    input[len - 1] = ',';
    input[len] = '\0';

    int *items = (int*) malloc(MAX_INPUT_SIZE * sizeof(int));
    int current_item = 0;

    char item[MAX_INPUT_SIZE];
    int current_index = 0;
    int i;
    for (i = 0; i < len; i++) {
        if (input[i] == ',') {
            item[current_index] = '\0';
            items[current_item] = atoi(item);
            current_item += 1;
            current_index = 0;
        } else {
            item[current_index] = input[i];
            current_index += 1;
        }
    }

    return items;
}

int calc_output(int noun, int verb, int *orig_items) {
    int items[MAX_INPUT_SIZE]; 
    int i;

    for (i = 0; i < MAX_INPUT_SIZE; i++) {
        items[i] = orig_items[i];
    }

    items[1] = noun;
    items[2] = verb;
    i = 0;

    int pos1, pos2, pos3;
    while (1) {
        int op = items[i];

        if (op == 1) {
            pos1 = items[i + 1];
            pos2 = items[i + 2];
            pos3 = items[i + 3];
            items[pos3] = items[pos1] + items[pos2];
        } else if (op == 2) {
            pos1 = items[i + 1];
            pos2 = items[i + 2];
            pos3 = items[i + 3];
            items[pos3] = items[pos1] * items[pos2];
        } else if (op == 99) {
            break;
        } else {
            printf("Unknown op code: %d\n", op);
            exit(1);
        }

        i += 4;
    }

    return items[0];
}

int main(int argc, char *argv[]) {
    char input[MAX_INPUT_SIZE];
    scanf("%s", input);
    int *items = parse_input(input);

    int noun, verb;
    for (noun = 0; noun < 99; noun++) {
        for (verb = 0; verb < 99; verb++) {
            int output = calc_output(noun, verb, items);

            if (output == TARGET) {
                printf("%d\n", 100 * noun + verb);
                exit(0);
            }
        }
    }

    printf("Nothing found.\n");
    exit(1);
}
