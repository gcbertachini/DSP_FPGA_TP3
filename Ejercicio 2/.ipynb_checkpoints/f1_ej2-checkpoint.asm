;==============================================================
;          Rutina de prueba del D/A de Burr Brown	 
;	   por Interrupciones TEST4
;==============================================================



ad56k    ident   1,0

	page    132,60

;==============================================
;            Compiler options
;==============================================
	opt     nomd,loc   ;No macro def., local labels on listing
;       opt     nomex	   ;
        opt     mex	   ;
        opt     cex	   ;muestra fcc
        opt     mu	   ;memory usage

;==============================================

	include 'INTEQU_ej2.asm'   ;Hardware definitions
    include 'IOEQU_ej2.asm'   ;Hardware definitions


	include 'coef_ej2.txt'    ;


START   EQU     $40

ENA_SSI EQU     %111111000
SSI_CRB	EQU	$200|(1<<M_SRE)|(1<<M_STE)|(1<<M_SRIE)

;=======================================
; Constants for IIR
;=======================================
	org	x:0

	baddr	M,15	  ;set circular buffer base addr (mem is not reserved)
	
coef_ej2   
	dc	-2*alpha1*costheta0_1
	dc	alpha1
	dc	gamma1
	dc	-beta1	
    dc	alpha1
	dc	-2*alpha2*costheta0_2
	dc	alpha2
	dc	gamma2
	dc	-beta2	
    dc	alpha2
    dc	-2*alpha3*costheta0_3
	dc	alpha3
	dc	gamma3
	dc	-beta3	
    dc	alpha3
    
    
	org 	y:0

xbuf	dsm	8



;=====================================
; Interrupt Vector for SSI RCV
;=====================================

	ORG   P:I_SSIRD
	JSR	RCV
  
;=====================================


   ORG     P:START
		
;=====================================
;      Inicializo la SSI
;=====================================

begin MOVEP	#$3000,X:M_IPR    ;Interrupt level for SSI
	MOVEP	#$4000,X:M_CRA       ;16 bit frame
	MOVEP	#SSI_CRB,X:M_CRB     ;Program SSI CRB 

    MOVE	#coef_ej2,R0            ; Pointer to coefficients
	MOVE	#xbuf,R4               ; Pointer to states
	MOVE	#15-1,m0               ; R0 circular pointer modulo 15
    MOVE #1, M4                     ; Modulo 2 for xbuf pointer
    MOVE X:(R0)+, X1 ; β1
    MOVE X:(R0)+, X0 ; 1
    MOVE #2, N4
NEXT_SAMPLE
    MOVE (R4)+ ; Point to next xbuf entry
    MOVE Y:ADC,Y1 ; Assume Y1 = x(n) (input samples)

	MOVEP	#ENA_SSI,X:M_PCC     ;ENABLE SCI,SSI
    ANDI	#$FC,MR		     	   ;Unmask interrupts 0,1,2,3


WAIAD	EQU	*

	JMP	WAIAD




;===================================
;  interrupt routine
;===================================
RCV	EQU	*

	ORI	#$08,MR

    DO X: nsec, Sectn
    MPY X0, Y1, A X:(R0)+, X0 Y:(R4)+, Y0 ; A = i xi(n)
    MAC X0, Y0, A X:(R0)+, X0 Y:(R4)+N4, Y0 ; A = A + i σi xi(n-2)
    MAC X0, Y0, A X:(R0)+, X0 Y:(R4)+, Y0 ; A = A + i μi xi(n-1)
    MAC X0, Y0, A Y:(R4)-N4, Y0 ; A = A + i yi(n-1)
    MAC -X1, Y0, A X:(R0)+, X1 Y1, Y:(R4)+N4 ; A = A - βi yi(n-2) save x(n)
    MOVE A, Y1 X:(R0)+, X0 ; yi(n) = 2 A (scalling mode is set)
    Sectn ; X1= βi+1 X0= i+1
    ; Output: y(n) = Y1
    MOVE xbuf_len-1, M4 ; Filter order + 1
    NOP
    MOVE Y1, Y:(R4)+N4 ; Save y(n)
    MOVE #1,M4
    JMP NEXT_SAMPLE
	

	RTI


	end begin
