.data
seed: .word 0
gridsize:   .byte 8,8
character:  .byte 0,0
box:        .byte 0,0
target:     .byte 0,0
resetCharacter: .byte 0,0
resetBox: .byte 0,0
resetTarget: .byte 0,0

players:    .byte 0

empty_spot: .string "[ ]"
box_spot: .string "[O]"
target_spot: .string "[X]"
character_spot: .string "[P]"
wall_spot: .string "[#]"
blankspace: .string " "
blanktab: .string "  "
blankspot: .string "   "
cornerUpdateable: .byte 0,0

promptPlayerNum: .string "Now Playing Game for Player "
promptMenu: .string "Please select how you would like to proceed.\n'w': Move up.\n'a': Move left\n's': Move down\n'd': Move right\n'r': Reset Game\nYour Choice: "
promptInvalidPlayer: .string "Please enter a number between 1 and 255.\n"
promptRow: .string "Row: "
promptCol: .string "Col: "
promptPlayers: .string "This game is a multiplayer game, where each player will play the same game\nto see who can complete in the least number of moves.\nPlease enter the number of players: "
promptMovePlayer: .string "Player "
promptMoveSeperator: .string ": "
promptMoveMove: .string " moves\n"
promptSettingUp: .string "To set up the board, please enter the number rows and columns you would like. \n"
promptInvalid: .string "Something went wrong ... \n"
promptInsolvable: .string "Oh no, you made the game unsolvable.\n"
promptInvalidInput: .string "You have entered an invalid input, please try again.\n"
promptInvalidRowCol: .string "Both row and column have to be greater than 2, please reenter.\n"
promptInvalidMove: .string "Oh no, you entered an invalid move.\n"
promptWin: .string "Congrats, You Won!\n"
promptMenu2: .string "Please select how you would like to proceed.\n'n': Start a new game.\n'r': Replay a player's moves\n'p': Start a new game with a different number of players.\n'e': Exit Game\n Your Choice: "
promptReplay: .string "Please enter the Player Number to replay their moves.\n"
promptLeaderboard: .string "Leaderboard: \n"
newline: .string "\n"

.text
.globl _start

_start:
    # For the enhancements, there is Multiplayer and Replay Mode

    # For the multiplayer enhancement, there are parts of it throughout the entire 
    # code, but main areas are lines 58-69, 130-145, 873-950
    # For replay mode, moves are stored in line 216-217, the replay function is 
    # called in line 295, and the replay function is stored at line 954-1004.

    li sp, 0x80000000
    li a6, 0x10000000

    PLAYERS:
    li a7, 4
    la a0, promptPlayers
    ecall
    la t0, players
    li a7, 5
    ecall
    li t2, 255
    bgt a0, t2, INVALIDPLAYER
    ble a0, x0, INVALIDPLAYER

    sb a0, 0(t0)

    
    newGame:
        li sp, 0x80000000
        li a6, 0x10000000
        li a7, 30
        ecall 
        li t0, 9315
        remu a0, a0, t0
        la t0, seed
        sw a0, 0(t0)
        li a7, 4
        la a0, promptSettingUp
        ecall
    SetUpBoard:
        li t1, 2

        la t0, gridsize

        li a7, 4
        la a0, promptRow
        ecall
        
        li a7, 5
        ecall
        ble a0, t1, INVALIDROWCOL
        sb a0, 0(t0)

        li a7, 4
        la a0, promptCol
        ecall

        li a7, 5
        ecall
        ble a0, t1, INVALIDROWCOL
        sb a0, 1(t0)


        jal setMap
        la a0, character
        la a1, resetCharacter
        lb s1, 0(a0)
        lb s2, 1(a0)
        sb s1, 0(a1)
        sb s2, 1(a1)
        la a0, box
        la a1, resetBox
        lb s1, 0(a0)
        lb s2, 1(a0)
        sb s1, 0(a1)
        sb s2, 1(a1)
        la a0, target
        la a1, resetTarget
        lb s1, 0(a0)
        lb s2, 1(a0)
        sb s1, 0(a1)
        sb s2, 1(a1)
        li s7, 0
        li s8, 0

    SetUpPlayer:
        la a0, players
        lb a0, 0(a0)
        beq s8, a0, LEADERBOARD
        jal reset
        li s7, 0
        li a7, 4
        la a0, promptPlayerNum
        ecall
        li a7, 1
        mv a0, s8
        addi a0, a0, 1
        ecall
        li a7, 4
        la a0, newline
        ecall

    MENU:
        jal printBoard

        li a7, 4
        la a0, promptMenu
        ecall

        li a7, 12
        ecall

        li t0, 119
        beq a0, t0, w
        li t0, 97
        beq a0, t0, a
        li t0, 115
        beq a0, t0, s
        li t0, 100
        beq a0, t0, d
        li t0, 114
        beq a0, t0, r

        li a7, 4
        la a0, newline
        ecall
        li a7, 4
        la a0, promptInvalidInput
        ecall
        j MENU

        w: #119
            li a7, 4
            la a0, newline
            ecall
            li a0, 1
            j MOVE

        a: #97
            li a7, 4
            la a0, newline
            ecall
            li a0, 4
            j MOVE

        s: #115
            li a7, 4
            la a0, newline
            ecall
            li a0, 3
            j MOVE

        d: #100
            li a7, 4
            la a0, newline
            ecall
            li a0, 2
            j MOVE

        r: #114
            li a7, 4
            la a0, newline
            ecall
            j resetGame

    MOVE:
        mv s10, a0

        jal move
        beq a0, x0, MENU

        sw s10, 0(a6)
        addi a6, a6, 4

        addi s7, s7, 1

        la a0, box
        la a1, target
        jal checkOverlap

        bne a0, x0, WIN

        jal checkSolvable
        beq a0, x0, INSOLVABLE

        j MENU


    INSOLVABLE:
        li a7, 4
        la a0, promptInsolvable
        ecall

    resetGame:
        jal reset
        
        li a0, 5
        sw a0, 0(a6)
        addi a6, a6, 4

        addi s7, s7, 1
        j MENU

    WIN:
        li a7, 4
        la a0, promptWin
        ecall

        addi sp, sp, -4
        sw s7, 0(sp)
        li s7, 0
        addi s8, s8, 1
        j SetUpPlayer
    
    INVALIDROWCOL:
        li a7, 4
        la a0, promptInvalidRowCol
        ecall

        j SetUpBoard
    
    INVALIDPLAYER:
        li a7, 4
        la a0, promptInvalidPlayer
        ecall
        j PLAYERS

    LEADERBOARD:
        li a7, 4
        la a0, promptLeaderboard
        ecall
        jal leaderboard

    FINISHGAME:
        li a7, 4
        la a0, promptMenu2
        ecall

        li a7, 12
        ecall

        mv t0, a0
        li a7, 4
        la a0, newline
        ecall
        mv a0, t0

        li t0, 110
        beq a0, t0, newGame
        li t0, 114
        beq a0, t0, REPLAY
        li t0, 112
        beq a0, t0, PLAYERS
        li t0, 101
        beq a0, t0, exit
        la a0, promptInvalidInput
        ecall
        j FINISHGAME

    REPLAY:
        mv a3, sp
        li sp, 0x80000000
        jal replay
        mv sp, a3
        j FINISHGAME

    exit:
        li a7, 10
        ecall
    
    
# --- HELPER FUNCTIONS ---
move:
    addi sp, sp, -4
    sw ra, 0(sp)
    addi sp, sp, -4
    sw a0, 0(sp)

    la t6, character
    lb t5, 0(t6)
    lb t6, 1(t6)

    mv a1, a0
    la a0, character
    jal movePiece
    jal checkBounds
    bne a0, x0, INVALID

    la a0, character
    la a1, box
    jal checkOverlap
    beq a0, x0, VALIDMOVE

    la a0, box
    lw a1, 0(sp)
    jal movePiece
    jal checkBounds
    beq a0, x0, VALIDMOVE

    INVALIDBOX:
        la a0, box
        sb t3, 0(a0)
        sb t4, 1(a0)

    INVALID:
        la a0, character
        sb t5, 0(a0)
        sb t6, 1(a0)
        li a7, 4
        la a0, promptInvalidInput
        ecall
        li a0, 0
        j ENDMOVE

    VALIDMOVE:
        li a0, 1

    ENDMOVE:
        addi sp, sp, 4
        lw ra, 0(sp)
        addi sp, sp, 4
        jr ra

movePiece:
    lb t1, 0(a0)
    lb t2, 1(a0)

    li t0, 1
    beq a1, t0, up
    addi t0, t0, 1
    beq a1, t0, right
    addi t0, t0, 1
    beq a1, t0, down
    addi t0, t0, 1
    beq a1, t0, left
    j INVALID

    up:
        addi t1, t1, -1
        mv t2, t2
        j ENDMOVECHAR
    right:
        mv t1, t1
        addi t2, t2, 1
        j ENDMOVECHAR
    down:
        addi t1, t1, 1
        mv t2, t2
        j ENDMOVECHAR
    left:
        mv t1, t1
        addi t2, t2, -1

    ENDMOVECHAR:
    sb t1, 0(a0)
    sb t2, 1(a0)
    jr ra

checkBounds:
    la t2, gridsize
    lb t1, 0(t2)
    lb t2, 1(t2)

    li t0, -1

    lb a1, 1(a0)
    lb a0, 0(a0)

    beq a0, t1, OUTOFBOUNDS
    beq a1, t2, OUTOFBOUNDS
    beq a0, t0, OUTOFBOUNDS
    beq a1, t0, OUTOFBOUNDS

    li a0, 0
    j END
    OUTOFBOUNDS:
        la a0, promptInvalidMove
        li a7, 4
        ecall

        li a0, 1
    END:
        jr ra

# W. E. Thomson, A Modified Congruence Method of Generating Pseudo-random Numbers, The Computer Journal, Volume 1, Issue 2, 1958, Page 83, https://doi.org/10.1093/comjnl/1.2.83
randomNumber:
    mv a1, a0
    la t0, seed
    lw t0, 0(t0)

    li a0, 1572            # a
    mul t0, t0, a0               # x a

    li a0, 1                 # c
    add t0, t0, a0               # +c

    li a0, 3325          # m
    rem t0, t0, a0               # % m

    la a0, seed
    sw t0, 0(a0)
    
    remu a0, t0, a1               #seed % N

    jr ra




printBoard:
    la t6, gridsize
    lb t5, 0(t6) #row
    lb t6, 1(t6) #col

    li a7, 4

    addi sp, sp, -4
    sw ra, 0(sp)
    jal printTOPBOTTOM

    jal walls

    li t0, 0
    LOOPROW:
        beq t0, t5, ENDROW

        li a7, 4
        la a0, blankspace
        ecall

        li a7, 1
        mv a0, t0
        ecall

        li a0, 10
        blt t0, a0, EXTRATABBING
        la a0, blankspace
        j ENDTABBING


        EXTRATABBING:
        la a0, blanktab

        ENDTABBING:
        li a7, 4
        ecall

        li a7, 4
        la a0, wall_spot
        ecall


        li t1, 0
        LOOPCOL:
            beq t1, t6, ENDCOL

            CHARACTER:
                la t3, character
                lb t2, 0(t3)
                lb t3, 1(t3)

                bne t0, t2, BOX
                bne t1, t3, BOX

                la a0, character_spot

                j ENDSELECTION
            BOX:
                la t3, box
                lb t2, 0(t3)
                lb t3, 1(t3)

                bne t0, t2, TARGET
                bne t1, t3, TARGET

                la a0, box_spot

                j ENDSELECTION
            TARGET:
                la t3, target
                lb t2, 0(t3)
                lb t3, 1(t3)

                bne t0, t2, EMPTY
                bne t1, t3, EMPTY

                la a0, target_spot

                j ENDSELECTION

            EMPTY:
                la a0, empty_spot
            ENDSELECTION:

            ecall
            addi t1, t1, 1
            j LOOPCOL
        ENDCOL:

        li a7, 4
        la a0, wall_spot
        ecall

        li a7, 4
        la a0, blanktab
        ecall

        li a7, 1
        mv a0, t0
        ecall

        li a7, 4
        la a0, blankspace
        ecall

        la a0, newline
        ecall  #move to next row
        
        addi t0, t0, 1 #increment row

        j LOOPROW
    ENDROW:
    jal walls
    jal printTOPBOTTOM
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

printTOPBOTTOM:
    li a7, 4
    la a0, blankspace
    ecall
    la a0, blankspot
    ecall
    ecall

    la t2, gridsize
    lb t2, 1(t2)
    li t3, 0
    LOOPTOPBOTTOM:
        beq t2, t3, ENDTOPBOTTOM
        
        li a0, 10
        bge t3, a0, NOSPACE
        li a7, 4
        la a0, blankspace
        ecall

        NOSPACE:
        li a7, 1
        mv a0, t3
        ecall

        li a7, 4
        la a0, blankspace
        ecall

        addi t3, t3, 1
        j LOOPTOPBOTTOM

    ENDTOPBOTTOM:
    la a0, newline
    ecall
    jr ra

walls:
    li a7, 4
    la a0, blanktab
    ecall
    ecall

    la a0, gridsize
    lb t2, 1(a0)

    addi t2, t2, 2

    li a7, 4
    la a0, wall_spot

    li t1, 0
    LOOPWALLS:
        beq t1, t2, ENDWALLS
        ecall
        addi t1, t1, 1
        j LOOPWALLS
    ENDWALLS:
        la a0, newline
        ecall
        jr ra

setMap:
    addi sp, sp, -4
    sw ra, 0(sp)

    la t1, gridsize
    lb t2, 0(t1)
    lb t3, 1(t1)

    la a0, character
    jal setCords
    
    la a0, target
    jal setCords

    la a0, box
    jal setCords
    jal setBox

    LOOPCHECK:
        jal setCords
        jal setBox

        la a0, character
        la a1, box

        jal checkOverlap

        beq a0, x0, CONTINUEcharbox

        la a0, character
        j LOOPCHECK

    CONTINUEcharbox:
        la a0, target
        la a1, box

        jal checkOverlap

        beq a0, x0, CONTINUEtargbox

        la a0, target
        j LOOPCHECK

    CONTINUEtargbox:
        la a0, character
        la a1, target

        jal checkOverlap

        beq a0, x0, ENDMAP

        la a0, character
        j LOOPCHECK

    ENDMAP:
        lw ra, 0(sp)
        addi sp, sp, 4
        jr ra
setBox:
    addi sp, sp, -4
    sw ra, 0(sp)

    LOOPBOX:
        jal checkSolvable
        bne a0, x0, RETURN
        la a0, box
        jal setCords
        j LOOPBOX
    RETURN:
        lw ra, 0(sp)
        addi sp, sp, 4
        jr ra


checkSolvable:
    addi sp, sp, -4
    sw ra, 0(sp)

    la t2, gridsize
    lb t1, 0(t2)
    lb t2, 1(t2)

    addi t1, t1, -1
    addi t2, t2, -1

    CORNER1:
    la a0, cornerUpdateable
    sb x0, 0(a0)
    sb x0, 1(a0)
    
    la a1, box

    jal checkOverlap
    beq a0, x0, CORNER2

    j NOTSOLVABLE
    CORNER2:
    la a0, cornerUpdateable
    sb t1, 0(a0)
    sb x0, 1(a0)
    
    la a1, box

    jal checkOverlap
    beq a0, x0, CORNER3

    j NOTSOLVABLE
    CORNER3:
    la a0, cornerUpdateable
    sb t1, 0(a0)
    sb t2, 1(a0)
    
    la a1, box

    jal checkOverlap
    beq a0, x0, CORNER4

    j NOTSOLVABLE
    CORNER4:
    la a0, cornerUpdateable
    sb x0, 0(a0)
    sb t2, 1(a0)
    
    la a1, box

    jal checkOverlap
    beq a0, x0, EDGES

    j NOTSOLVABLE
    EDGES:

    la t2, gridsize
    lb t1, 0(t2)
    lb t2, 1(t2)

    addi t1, t1, -1
    addi t2, t2, -1

    la t4, box
    lb t3, 0(t4)
    lb t4, 1(t4)

    la t5, target
    lb t6, 1(t5)
    lb t5, 0(t5)
    
    bne t3, x0, BOTTOM
    beq t5, x0, SOLVABLE
    j NOTSOLVABLE

    BOTTOM:
    bne t3, t1, LEFT 
    beq t5, t1, SOLVABLE
    j NOTSOLVABLE

    LEFT:
    bne t4, x0, RIGHT
    beq t6, x0, SOLVABLE
    j NOTSOLVABLE

    RIGHT:
    bne t4, t2, SOLVABLE
    beq t6, t2, SOLVABLE
    j NOTSOLVABLE

    SOLVABLE:
    li a0, 1
    j RETURNSOLVABLE

    NOTSOLVABLE:
    li a0, 0

    RETURNSOLVABLE:
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

setCords:
    addi sp, sp, -4
    sw ra, 0(sp)

    mv t4, a0

    la t1, gridsize
    lb t2, 0(t1)
    lb t3, 1(t1)

    mv a0, t2
    jal randomNumber
    sb a0, 0(t4)

    mv a0, t3
    jal randomNumber
    sb a0, 1(t4)

    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra


checkOverlap:
    lb t1, 0(a0)
    lb t2, 1(a0)
    lb t3, 0(a1)
    lb t4, 1(a1)

    bne t1, t3, ELSE
    bne t2, t4, ELSE

    li a0, 1
    j ENDOVERLAP

    ELSE:
        li a0, 0
    ENDOVERLAP:
        jr ra

reset:
    la a1, character
    la a0, resetCharacter
    lb s1, 0(a0)
    lb s2, 1(a0)
    sb s1, 0(a1)
    sb s2, 1(a1)
    la a1, box
    la a0, resetBox
    lb s1, 0(a0)
    lb s2, 1(a0)
    sb s1, 0(a1)
    sb s2, 1(a1)
    la a1, target
    la a0, resetTarget
    lb s1, 0(a0)
    lb s2, 1(a0)
    sb s1, 0(a1)
    sb s2, 1(a1)
	jr ra

leaderboard:

    li t0, 0
    la t6, players
    lb t6, 0(t6)

    LOOPALLPLAYERS:
        beq t0, t6, ENDLEADERBOARD
        li t1, 0 
        li a5, 0x7FFFFFFF
        li a4, 0x7FFFFFFF
        ITERATEALLMOVES:
            beq t1, t6, ENDALLMOVES
            li a0, 0x80000000
            slli t4, t1, 2
            sub a0, a0, t4
            addi a0, a0, -4
            lw a0, 0(a0)
            mv a6, a0

            blt a0, a4, SEEN
            j ALREADYSEEN
            NOTSEEN:
                mv a5, t1
                mv a4, a6
            ALREADYSEEN:
                addi t1, t1, 1
            j ITERATEALLMOVES
        SEEN:
            li t2, 0
            mv a0, sp
            LOOPSEEN:
                beq t0, t2, SEENNOT
                addi sp, sp, -4
                lw t3, 0(sp)
                beq t1, t3, SEENALREADY
                addi t2, t2, 1
                j LOOPSEEN
            SEENALREADY:
                mv sp, a0
                j ALREADYSEEN
            SEENNOT:
                mv sp, a0
                j NOTSEEN

        ENDALLMOVES:
            li a7, 4
            la a0, promptMovePlayer
            ecall
            li a7, 1
            mv a0, a5
            addi a0, a0, 1
            ecall
            li a7, 4
            la a0, promptMoveSeperator
            ecall
            li a7, 1
            mv a0, a4
            ecall
            li a7, 4
            la a0, promptMoveMove
            ecall

            li t2, 0
            mv a0, sp
            LOOPSTORE:
                addi sp, sp, -4
                beq t0, t2, STOREPLAYER
                addi t2, t2, 1
                j LOOPSTORE
            
            STOREPLAYER:
                sw a5, 0(sp)
            mv sp, a0
        addi t0, t0, 1
        j LOOPALLPLAYERS
    ENDLEADERBOARD:
        jr ra



replay:
    mv sp, a3
    addi sp, sp, -4
    sw ra, 0(sp)
    mv a3, sp
    li a2, 0x10000000
    mv t6, sp
    li t1, 1
    li sp, 0x80000000
    li a7, 4
    la a0, promptReplay
    ecall
    li a7, 5
    ecall
    LOOPREPLAY:
        addi sp, sp, -4
        beq t1, a0, GETMOVE
        lw t0, 0(sp)
        slli t0, t0, 2
        add a2, a2, t0
        addi t1, t1, 1
        j LOOPREPLAY

    GETMOVE:
        lw a5, 0(sp)
        mv sp, t6
        jal reset
        jal printBoard
        li a4, 0
        LOOPMOVES:
            beq a4, a5, BREAKMOVE
            addi a4, a4, 1
            lw a0, 0(a2)
            addi a2, a2, 4
            li t6, 5
            beq a0, t6, RESETBOARD
            jal move
            jal printBoard
            j LOOPMOVES

        RESETBOARD:
            jal reset
            jal printBoard
            j LOOPMOVES
        BREAKMOVE:
            mv sp, a3
            lw ra, 0(sp)
            addi sp, sp, 4
            mv a3, sp
            li sp, 0x80000000
            jr ra