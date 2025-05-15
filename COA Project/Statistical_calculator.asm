.MODEL SMALL
.STACK 100H

.DATA
DATASET DW 0080H, 0040H, 0030H, 0030H, 0030H, 0070H  ; Example dataset
TEMP_DATASET DW 100H DUP(0)       ; Temporary dataset for sorting and frequency counts
COUNT   DW 6                      ; Number of elements in the dataset
MEAN    DW 0                      ; Variable to store the mean
MEDIAN  DW 0                      ; Variable to store the median
MODE    DW 0                      ; Variable to store the mode
RANGE   DW 0                      ; Variable to store the range
SUM     DW 0                      ; Variable to store the sum of elements
TEMP    DW 0                      ; Temporary variable for swapping
MODE_FREQUENCY DW 0               ; Variable to store the mode frequency
MIN_VALUE DW 0                    ; Variable to store the minimum value
MAX_VALUE DW 0                    ; Variable to store the maximum value

.CODE
MAIN:
    MOV AX, @DATA
    MOV DS, AX

    ; Calculate Mean
    MOV CX, COUNT           ; Load count of elements
    XOR BX, BX              ; Clear BX to use as index
    XOR AX, AX              ; Clear AX to use as sum accumulator

CALCULATE_SUM:
    MOV SI, BX              ; Copy BX to SI for indexing
    MOV AX, DATASET[SI]     ; Load the next element
    ADD SUM, AX             ; Add to sum
    INC BX
    INC BX                  ; Move to the next element
    LOOP CALCULATE_SUM      ; Repeat until all elements are processed

    MOV AX, SUM             ; Load sum into AX
    MOV CX, COUNT           ; Load count of elements
    XOR DX, DX              ; Clear DX before division
    DIV CX                  ; Divide sum by count to get mean
    MOV MEAN, AX            ; Store mean

    ; Calculate Median
    ; Copy dataset to temp_dataset
    MOV CX, COUNT
    MOV SI, 0
    MOV DI, 0
COPY_LOOP:
    MOV AX, DATASET[SI]
    MOV TEMP_DATASET[DI], AX
    ADD SI, 2
    ADD DI, 2
    LOOP COPY_LOOP

    ; Bubble Sort on temp_dataset
    MOV CX, COUNT
    DEC CX
OUTER_LOOP:
    MOV SI, 0
    MOV DX, CX
INNER_LOOP:
    MOV AX, TEMP_DATASET[SI]       ; Load current element into AX
    MOV BX, TEMP_DATASET[SI+2]     ; Load next element into BX
    CMP AX, BX                     ; Compare current and next elements
    JBE NO_SWAP                    ; If current <= next, no swap

    ; Swap the elements
    MOV TEMP, AX                   ; Store current element in temp
    MOV TEMP_DATASET[SI], BX       ; Move next element to current position
    MOV AX, TEMP
    MOV BX, SI
    ADD BX, 2
    MOV [TEMP_DATASET+BX], AX      ; Move current element to next position

NO_SWAP:
    ADD SI, 2                      ; Move SI to the next element
    DEC DX                         ; Decrement DX
    JNZ INNER_LOOP                 ; Loop if DX != 0
    DEC CX                         ; Decrement CX for outer loop
    JNZ OUTER_LOOP                 ; Repeat outer loop if CX != 0

    ; Calculate Median
    MOV CX, COUNT                  ; Reload count of elements into CX
    SHR CX, 1                      ; Divide count by 2 to get the middle index
    MOV SI, CX
    SHL SI, 1                      ; Multiply by 2 to get the byte offset

    ; Check if count is even
    TEST COUNT, 1
    JZ EVEN_COUNT
    ; If odd, take the middle element
    MOV AX, TEMP_DATASET[SI]
    JMP MEDIAN_DONE

EVEN_COUNT:
    ; If even, average the two middle elements
    MOV BX, SI
    SUB BX, 2
    MOV AX, TEMP_DATASET[BX]       ; Load the lower middle element
    ADD AX, TEMP_DATASET[SI]       ; Add the upper middle element
    SHR AX, 1                      ; Divide by 2 to get the average

MEDIAN_DONE:
    MOV MEDIAN, AX                 ; Store it in the median variable

   ; Calculate Mode
    MOV CX, COUNT           ; Load count of elements
    XOR BX, BX              ; Clear BX
    MOV MODE_FREQUENCY, 0   ; Initialize the mode frequency to 0

INITIALIZE_FREQ:
    MOV DI, 0               ; Initialize DI to 0

    ; Clear the frequency array
CLEAR_FREQUENCY:
    MOV [TEMP_DATASET+DI], 0
    ADD DI, 2
    CMP DI, COUNT * 2            ; Check if all slots are initialized (6 elements * 2 bytes)
    JB CLEAR_FREQUENCY

FIND_MODE:
    CMP BX, COUNT           ; Check if all elements are processed
    JAE MODE_DONE
    MOV SI, BX              ; Use BX as an index
    SHL SI, 1               ; Convert to byte offset
    MOV AX, DATASET[SI]     ; Load the next element
    MOV DI, AX              ; DI will store the index in temp_dataset
    SHR DI, 1               ; Divide by 2 to get the word offset
    INC WORD PTR [TEMP_DATASET+DI*2] ; Increment frequency

    ; Check if the current frequency is greater than the mode frequency
    MOV AX, [TEMP_DATASET+DI*2]
    CMP AX, MODE_FREQUENCY
    JLE NEXT_ELEMENT_MODE

    MOV MODE_FREQUENCY, AX  ; Update the mode frequency
    ; Update the mode value from dataset
    MOV SI, BX              ; Save the index of the current mode candidate
    SHL SI, 1               ; Multiply by 2 to convert word index to byte offset
    MOV AX, DATASET[SI]     ; Load the mode value from dataset
    MOV MODE, AX            ; Store the mode value

NEXT_ELEMENT_MODE:
    INC BX                  ; Move to the next element
    JMP FIND_MODE

MODE_DONE:
    ; Mode is now stored in the 'mode' variable
    

    ; Calculate Range
    MOV CX, COUNT           ; Load count of elements
    MOV SI, 0               ; Initialize SI to 0
    MOV AX, DATASET[SI]     ; Load the first element into AX
    MOV MIN_VALUE, AX       ; Initialize MIN_VALUE with the first element
    MOV MAX_VALUE, AX       ; Initialize MAX_VALUE with the first element

FIND_MIN_MAX:
    MOV AX, DATASET[SI]     ; Load the current element into AX
    CMP AX, MIN_VALUE       ; Compare current element with MIN_VALUE
    JGE CHECK_MAX           ; If current element >= MIN_VALUE, check for MAX
    MOV MIN_VALUE, AX       ; Update MIN_VALUE with current element

CHECK_MAX:
    CMP AX, MAX_VALUE       ; Compare current element with MAX_VALUE
    JLE NEXT_ELEMENT ; If current element <= MAX_VALUE, go to NEXT_ELEMENT
    MOV MAX_VALUE, AX ; Update MAX_VALUE with current element

NEXT_ELEMENT:
    ADD SI, 2 ; Move to the next element
    LOOP FIND_MIN_MAX ; Repeat until all elements are processed
    MOV AX, MAX_VALUE       ; Load MAX_VALUE into AX
    SUB AX, MIN_VALUE       ; Calculate RANGE (MAX_VALUE - MIN_VALUE)
    MOV RANGE, AX           ; Store the RANGE


; End of program
MOV AX, 4C00H           ; Terminate program
INT 21H