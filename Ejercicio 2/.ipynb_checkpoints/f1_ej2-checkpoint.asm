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

	include 'ioequ.asm'   ;Hardware definitions


	include 'coef.txt'    ;


START   EQU     $40

ENA_SSI EQU     %111111000
SSI_CRB	EQU	$200|(1<<M_SRE)|(1<<M_STE)|(1<<M_SRIE)

;=======================================
; Constants for IIR
;=======================================
	org	x:0

	baddr	M,5	  ;set circular buffer base addr (mem is not reserved)
	
coef   
	dc	-2*alpha*cos_theta_0
	dc	alpha
	dc	gama
	dc	-beta	
    dc	alpha

	org 	y:0

xstates	dsm	2
ystates	dsm	2


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

   MOVE	#coef,R0
	MOVE	#xstates,R4
	MOVE	#ystates,R5
	MOVE	#5-1,m0
	MOVE	#2-1,m4
	MOVE	#2-1,m5
	MOVE	#alpha,X0

	MOVEP	#ENA_SSI,X:M_PCC     ;ENABLE SCI,SSI
   ANDI	#$FC,MR		     	   ;Unmask interrupts 0,1,2,3


WAIAD	EQU	*

	JMP	WAIAD




;===================================
;  interrupt routine
;===================================
RCV	EQU	*

	ORI	#$08,MR

	MOVE	X:M_RX,Y1
   
	MPY	X0,Y1,A		X:(R0)+,X0	Y:(R4)+,Y0   ;A=ax(n) 
	MAC	X0,Y0,A		X:(R0)+,X0	Y:(R4),Y0    ;A=A-2acosq0x(n-1)
	MAC	X0,Y0,A		X:(R0)+,X0	Y:(R5)+,Y0   ;A=A+alpha*x(n-2)
	MAC	X0,Y0,A		X:(R0)+,X0	Y:(R5),Y0    ;A=A+gama*y(n-1)
	MAC	X0,Y0,A		X:(R0)+,X0	Y1,Y:(R4)    ;A=A-beta*y(n-2)
	MOVE	A,X1 			A,Y:(R5)         ;y(n)=2A
   
	MOVEP	X1,X:M_TX
	

	RTI


	end begin
