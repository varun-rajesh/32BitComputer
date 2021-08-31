#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void read_r(int *instruction) {
  char *token;
  char* stripped_token;
  int op_1;
  int op_2;
  int op_3;

  token = strtok(NULL, " ");
  stripped_token = token + 1;
  stripped_token[strlen(stripped_token) - 1] = '\0';
  op_1 = atoi(stripped_token);
  *instruction |= op_1 << 11;

  token = strtok(NULL, " ");
  stripped_token = token + 1;
  stripped_token[strlen(stripped_token) - 1] = '\0';
  op_2 = atoi(stripped_token);
  *instruction |= op_2 << 21;

  token = strtok(NULL, " ");
  stripped_token = token + 1;
  op_3 = atoi(stripped_token);
  *instruction |= op_3 << 16;
}

void read_i(int *instruction) {
  char *token;
  char* stripped_token;
  int op_1;
  int op_2;
  int op_3;

  token = strtok(NULL, " ");
  stripped_token = token + 1;
  stripped_token[strlen(stripped_token) - 1] = '\0';
  op_1 = atoi(stripped_token);
  *instruction |= op_1 << 16;

  token = strtok(NULL, " ");
  stripped_token = token + 1;
  stripped_token[strlen(stripped_token) - 1] = '\0';
  op_2 = atoi(stripped_token);
  *instruction |= op_2 << 21;

  token = strtok(NULL, " ");
  op_3 = atoi(token);
  *instruction |= op_3;
}

void read_s(int *instruction) {
  char *token;
  char* stripped_token;
  int op_1;
  int op_2;
  int op_3;

  token = strtok(NULL, " ");
  stripped_token = token + 1;
  stripped_token[strlen(stripped_token) - 1] = '\0';
  op_1 = atoi(stripped_token);
  *instruction |= op_1 << 11;

  token = strtok(NULL, " ");
  stripped_token = token + 1;
  stripped_token[strlen(stripped_token) - 1] = '\0';
  op_2 = atoi(stripped_token);
  *instruction |= op_2 << 21;

  token = strtok(NULL, " ");
  op_3 = atoi(token);
  *instruction |= op_3 << 6;
}

void read_m(int *instruction) {
  char *token;
  char* stripped_token;
  int op_1;

  token = strtok(NULL, " ");
  stripped_token = token + 1;
  stripped_token[strlen(stripped_token) - 1] = '\0';
  op_1 = atoi(stripped_token);
  *instruction |= op_1 << 16;
}

void read_jr(int *instruction) {
  char *token;
  char* stripped_token;
  int op_1;

  token = strtok(NULL, " ");
  stripped_token = token + 1;
  stripped_token[strlen(stripped_token) - 1] = '\0';
  op_1 = atoi(stripped_token);
  *instruction |= op_1 << 21;
}

void read_j(int *instruction) {
  char *token;
  char* stripped_token;
  int op_1;

  token = strtok(NULL, " ");
  op_1 = atoi(token);
  *instruction |= op_1;
}

int main(int argc, char *args[]) {
  #define CHUNK 60
  FILE *file_read = fopen(args[1], "r");
  FILE *file_write = fopen(args[2]), "w+");
  unsigned int instruction;
  unsigned int temp_instruction;
  int* instructions;
  int size = 8;
  char current_line[CHUNK];

  char *token;
  char* stripped_token;
  int op_1;
  int op_2;
  int op_3;

  int i = 0;

  instructions = calloc(size, sizeof(int));
  printf("address: %d\n", instructions);

  if (file_read == NULL || file_write == NULL) {
    perror("");
    return (-1);
  }

  while(fgets(current_line, CHUNK, file_read) != NULL){
    printf("current line: %s", current_line);

    token = strtok(current_line, " ");
    instruction = 0;

    if (strcmp(token, "add") == 0) {
      read_r(&instruction);
      instruction |= 1;
    } else if (strcmp(token, "addi") == 0) {
      instruction |= 1 << 26;
      read_i(&instruction);
    } else if (strcmp(token, "sub") == 0) {
      read_r(&instruction);
      instruction |= 2;
    } else if (strcmp(token, "subi") == 0) {
      instruction |= 2 << 26;
      read_i(&instruction);
    } else if (strcmp(token, "mlt") == 0) {
      read_r(&instruction);
      instruction |= 3;
    } else if (strcmp(token, "mlti") == 0) {
      instruction |= 3 << 26;
      read_i(&instruction);
    } else if (strcmp(token, "div") == 0) {
      read_r(&instruction);
      instruction |= 4;
    } else if (strcmp(token, "divi") == 0) {
      instruction |= 4 << 26;
      read_i(&instruction);
    } else if (strcmp(token, "and") == 0) {
      read_r(&instruction);
      instruction |= 5;
    } else if (strcmp(token, "andi") == 0) {
      instruction |= 5 << 26;
      read_i(&instruction);
    } else if (strcmp(token, "or") == 0) {
      read_r(&instruction);
      instruction |= 6;
    } else if (strcmp(token, "ori") == 0) {
      instruction |= 6 << 26;
      read_i(&instruction);
    } else if (strcmp(token, "lsr") == 0) {
      read_s(&instruction);
      instruction |= 7;
    } else if (strcmp(token, "lsl") == 0) {
      read_s(&instruction);
      instruction |= 8;
    } else if (strcmp(token, "lw") == 0) {
      instruction |= 9 << 26;
      read_i(&instruction);
    } else if (strcmp(token, "sw") == 0) {
      instruction |= 10 << 26;
      read_i(&instruction);
    } else if (strcmp(token, "mvl") == 0) {
      instruction |= 11 << 26;
      read_m(&instruction);
    } else if (strcmp(token, "beq") == 0) {
      instruction |= 12 << 26;
      read_i(&instruction);
    } else if (strcmp(token, "bne") == 0) {
      instruction |= 13 << 26;
      read_i(&instruction);
    } else if (strcmp(token, "slt") == 0) {
      read_r(&instruction);
      instruction |= 14 << 26;
    } else if (strcmp(token, "slti") == 0) {
      instruction |= 14 << 26;
      read_r(&instruction);
    } else if (strcmp(token, "jr") == 0) {
      instruction |= 15 << 26;
      read_jr(&instruction);
    } else if (strcmp(token, "j") == 0) {
      instruction |= 16 << 26;
      read_j(&instruction);
    } else if (strcmp(token, "jal") == 0) {
      instruction |= 17 << 26;
      read_j(&instruction);
    } else {
      printf("ERROR: Operation not defined");
    }

    *(instructions + i) = instruction;

    i = i + 1;
    if (i == size) {
      size = size * 2;
      realloc(instructions, size);
    }
    printf("i: %d\n", i);
  }

  fputs("{", file_write);
  for(int j = i - 1; j >= 0; j = j - 1) {
    temp_instruction = *(instructions + j);
    printf("instruction to write: %d, %d\n", j, temp_instruction);
    if (j != 0) fprintf(file_write, "32'd%u, ", temp_instruction);
    else fprintf(file_write, "32'd%u", temp_instruction);
  }
  fputs("}", file_write);

  fclose(file_read);
  fclose(file_write);

  return(0);
}
