.stack 100h
.data
	zero	db "  ___  ", 10
				db " / _ \ ", 10
				db "| | | |", 10
				db "| | | |", 10
				db "| |_| |", 10
				db " \___/ ", 10, "$"

  one		db "  __  ", 10
    		db " /_ | ", 10
    		db "  | | ", 10
    		db "  | | ", 10
    		db "  | | ", 10
    		db "  |_| ", 10, "$"

  two		db " ___  ", 10
    		db "|__ \ ", 10
    		db "   ) |", 10
    		db "  / / ", 10
    		db " / /_ ", 10
    		db "|____|", 10, "$"

	three	db " ____  ", 10
			 	db "|___ \ ", 10
			 	db "  __) |", 10
			 	db " |__ < ", 10
			 	db " ___) |", 10
			 	db "|____/ ", 10, "$"

	four	db " _  _   ", 10
				db "| || |  ", 10
				db "| || |_ ", 10
				db "|__   _|", 10
				db "   | |  ", 10
				db "   |_|  ", 10, "$"

	five	db " _____ ", 10
				db "| ____|", 10
				db "| |__  ", 10
				db "|___ \ ", 10
				db " ___) |", 10
				db "|____/ ", 10, "$"

	six		db "   __  ", 10
				db "  / /  ", 10
				db " / /_  ", 10
				db "| '_ \ ", 10
				db "| (_) |", 10
				db " \___/ ", 10, "$"

	seven	db " ______ ", 10
				db "|____  |", 10
				db "    / / ", 10
				db "   / /  ", 10
				db "  / /   ", 10
				db " /_/    ", 10, "$"

	eight	db "  ___  ", 10
				db " / _ \ ", 10
				db "| (_) |", 10
				db " > _ < ", 10
				db "| (_) |", 10
				db " \___/ ", 10, "$"


	nine 	db "  ___  ", 10
				db " / _ \ ", 10
				db "| (_) |", 10
				db " \__, |", 10
				db "   / / ", 10
				db "  /_/  ", 10, "$"

	colon db "     ", 10
				db "   _ ", 10
				db "  (_)", 10
				db "     ", 10
				db "   _ ", 10
				db "  (_)", 10, "$"

  line db 0
  column db 6
  page_number db 0
  digit_unit db 0
  digit_ten db 0
  time db 0
	hour db 0
  minute db 0
  second db 0
	current_hour db 0
  current_minute db 0
  current_second db 0
  digit_pointer dw 11 dup(?)

.code
	init:
	  mov ax, data
	  mov ds, ax

	  mov digit_pointer[0], offset zero
	  mov digit_pointer[2], offset one
	  mov digit_pointer[4], offset two
	  mov digit_pointer[6], offset three
	  mov digit_pointer[8], offset four
	  mov digit_pointer[10], offset five
	  mov digit_pointer[12], offset six
	  mov digit_pointer[14], offset seven
	  mov digit_pointer[16], offset eight
	  mov digit_pointer[18], offset nine
		mov digit_pointer[20], offset colon


		;mov ah, 25h
		;mov al, 23h
		;mov dx, fim
		;int 21h

	main:
		main__read_keyboard_buffer:
			mov ah, 01h
			int 16h
			jnz exit

		main__load_time:
  		mov ah, 2Ch
  		int 21h

			mov	current_hour, ch
  		mov	current_minute, cl
  		mov	current_second, dh

		main__print_second:
  		mov al, current_second
  		cmp second, al
  		jne print

		main__print_minute:
  		mov al, current_minute
  		cmp minute, al
  		jne print

		main__print_hour:
			mov al, current_hour
  		cmp hour, al
  		jne print

  	jmp main

	print:
		print__update_hour:
			mov al, current_hour
			mov hour, al

		print__update_minute:
  		mov al, current_minute
  		mov minute, al

		print__update_second:
  		mov al, current_second
  		mov second, al

  	print__clear_screen:
  		call clear_screen

		print__hour:
			mov al, current_hour
  		mov time, al
  		call parse_time

  		call set_digit
  		mov column, 1
  		call print_digit

  		mov al, digit_unit
  		call set_digit
  		mov column, 11
  		call print_digit

		print__first_colon:
			mov al, 0Ah
			call set_digit
			mov column, 21
			call print_digit

  	print__minute:
  		mov al, current_minute
  		mov time, al
  		call parse_time

  		call set_digit
  		mov column, 31
  		call print_digit

  		mov al, digit_unit
  		call set_digit
  		mov column, 41
  		call print_digit

		print__second_colon:
			mov al, 0Ah
			call set_digit
			mov column, 51
			call print_digit

  	print__second:
  		mov al, current_second
			mov time, al
  		call parse_time

  		call set_digit
  		mov column, 61
  		call print_digit

  		mov al, digit_unit
  		call set_digit
  		mov column, 71
  		call print_digit

  	jmp main

	parse_time:
  	mov ah, 0
  	mov al, time
  	mov bl, 10
  	div bl
  	mov digit_ten, al
  	mov digit_unit, ah

  	ret

	set_digit:
  	mov bl, 2
  	mul bl
  	mov si, ax
  	mov si, digit_pointer[si]

  	ret

	print_digit:
		print_digit__reset:
  		mov line, 2
  		call set_cursor

		print_digit__digit:
  		mov dh, 0
  		mov dl, ds:[si]

  		cmp dx, "$"
  		je print_digit__end

  		cmp dx, 10
  		je print_digit__new_line

  		mov ah, 2
  		int 21h

  		inc si
  		jmp print_digit__digit

		print_digit__new_line:
  		inc line
  		call set_cursor
  		inc si
  		jmp print_digit__digit

		print_digit__end:
  		ret

	set_cursor:
		mov ah, 2
  	mov bh, page_number
  	mov dh, line
  	mov dl, column
  	int 10h

		ret

	clear_screen:
		mov ah, 0fh
  	int 10h
  	mov ah, 0
  	int 10h

		ret

	exit:
		exit__clear_screen:
			call clear_screen

		exit__flush_keyboard_buffer:
			mov ah, 0Ch
			mov al, 0
			int 21h

		exit__signal:
  		mov ax, 4C00h
  		int 21h

end init