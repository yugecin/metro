%macro export_func 1
   global _%1
   _%1:
%endmacro
%define USE_SECTIONS
%define SAMPLE_RATE	44100
%define MAX_INSTRUMENTS	6
%define MAX_VOICES 2
%define HLD 1
%define BPM 120.000000
%define MAX_PATTERNS 50
%define PATTERN_SIZE_SHIFT 4
%define PATTERN_SIZE (1 << PATTERN_SIZE_SHIFT)
%define	MAX_TICKS (MAX_PATTERNS*PATTERN_SIZE)
%define	SAMPLES_PER_TICK 5512
%define DEF_LFO_NORMALIZE 0.0000453515
%define	MAX_SAMPLES	(SAMPLES_PER_TICK*MAX_TICKS)
;%define 	GO4K_USE_16BIT_OUTPUT
;%define 	GO4K_USE_GROOVE_PATTERN
;%define 	GO4K_USE_ENVELOPE_RECORDINGS
;%define 	GO4K_USE_NOTE_RECORDINGS
%define 	GO4K_CLIP_OUTPUT
%define 	GO4K_USE_DST
%define 	GO4K_USE_DLL
%define 	GO4K_USE_GLOBAL_DLL
%define 	GO4K_USE_ENV_CHECK
%define 	GO4K_USE_ENV_MOD_GM
%define 	GO4K_USE_VCO_CHECK
%define 	GO4K_USE_VCO_PHASE_OFFSET
%define 	GO4K_USE_VCO_SHAPE
%define 	GO4K_USE_VCO_MOD_TM
%define 	GO4K_USE_VCO_MOD_DM
%define 	GO4K_USE_VCO_MOD_CM
%define 	GO4K_USE_VCF_CHECK
%define 	GO4K_USE_VCF_HIGH
%define 	GO4K_USE_VCF_BAND
%define 	GO4K_USE_VCF_PEAK
%define 	GO4K_USE_DST_CHECK
%define		GO4K_USE_DLL_CHORUS_CLAMP
%define 	GO4K_USE_DLL_DAMP
%define 	GO4K_USE_DLL_DC_FILTER
%define 	GO4K_USE_FSTG_CHECK
%define		GO4K_USE_WAVESHAPER_CLIP
%define	MAX_DELAY			65536
%define MAX_WORKSPACE_SLOTS	8
%define GO4K_BEGIN_CMDDEF(def_name)
%define GO4K_END_CMDDEF db 0
%define GO4K_BEGIN_PARAMDEF(def_name)
%define GO4K_END_PARAMDEF
GO4K_ENV_ID		equ		1
%macro	GO4K_ENV 5
	db	%1
	db	%2
	db	%3
	db	%4
	db	%5
%endmacro
%define	ATTAC(val)		val	
%define	DECAY(val)		val	
%define	SUSTAIN(val)	val	
%define	RELEASE(val)	val	
%define	GAIN(val)		val	
struc	go4kENV_val
	.attac		resd	1
	.decay		resd	1
	.sustain	resd	1
	.release	resd	1
	.gain		resd	1
	.size
endstruc
struc	go4kENV_wrk
	.state		resd	1
	.level		resd	1
	.gm			resd	1
	.am			resd	1
	.dm			resd	1
	.sm			resd	1
	.rm			resd	1
	.size
endstruc
%define ENV_STATE_ATTAC		0
%define ENV_STATE_DECAY		1
%define ENV_STATE_SUSTAIN	2
%define ENV_STATE_RELEASE	3
%define ENV_STATE_OFF		4
GO4K_VCO_ID		equ		2
%macro	GO4K_VCO 8
	db	%1
	db	%2
%ifdef GO4K_USE_VCO_PHASE_OFFSET	
	db	%3
%endif	
%ifdef GO4K_USE_VCO_GATE	
	db	%4
%endif	
	db	%5
%ifdef GO4K_USE_VCO_SHAPE	
	db	%6
%endif	
	db	%7
	db	%8
%endmacro
%define	TRANSPOSE(val)	val	
%define	DETUNE(val)		val	
%define	PHASE(val)		val	
%define	GATES(val)		val	
%define	COLOR(val)		val	
%define	SHAPE(val)		val 
%define	FLAGS(val)		val	
%define SINE		0x01
%define TRISAW		0x02
%define PULSE		0x04
%define NOISE		0x08
%define LFO			0x10
%define GATE		0x20
struc	go4kVCO_val
	.transpose	resd	1
	.detune		resd	1
%ifdef GO4K_USE_VCO_PHASE_OFFSET	
	.phaseofs	resd	1
%endif	
%ifdef GO4K_USE_VCO_GATE	
	.gate		resd	1
%endif	
	.color		resd	1
%ifdef GO4K_USE_VCO_SHAPE	
	.shape		resd	1
%endif	
	.gain		resd	1
	.flags		resd	1	
	.size
endstruc
struc	go4kVCO_wrk
	.phase		resd	1
	.tm			resd	1
	.dm			resd	1
	.fm			resd	1
	.pm			resd	1
	.cm			resd	1
	.sm			resd	1
	.gm			resd	1
	.size
endstruc
GO4K_VCF_ID		equ		3
%macro	GO4K_VCF 3
	db	%1
	db	%2
	db	%3
%endmacro
%define LOWPASS		0x1
%define HIGHPASS	0x2
%define BANDPASS	0x4
%define	BANDSTOP	0x3
%define ALLPASS		0x7
%define	PEAK		0x8
%define	FREQUENCY(val)	val
%define	RESONANCE(val)	val
%define	VCFTYPE(val)	val
struc	go4kVCF_val
	.freq		resd	1
	.res		resd	1
	.type		resd	1
	.size
endstruc
struc	go4kVCF_wrk
	.low		resd	1
	.high		resd	1
	.band		resd	1
	.freq		resd	1
	.fm			resd	1
	.rm			resd	1	
	.size
endstruc
GO4K_DST_ID		equ		4
%macro	GO4K_DST 2
	db	%1
%ifdef GO4K_USE_DST_SH	
	db	%2
%endif	
%endmacro
%define	DRIVE(val)		val
%define	SNHFREQ(val)	val
struc	go4kDST_val
	.drive		resd	1
%ifdef GO4K_USE_DST_SH	
	.snhfreq	resd	1
%endif	
	.size
endstruc
struc	go4kDST_wrk
%ifdef GO4K_USE_DST_SH	
	.out		resd	1
	.snhphase	resd	1
%endif	
	.dm			resd	1
	.sm			resd	1
	.size
endstruc
GO4K_DLL_ID		equ		5
%macro	GO4K_DLL 8
	db	%1
	db	%2
	db	%3
%ifdef GO4K_USE_DLL_DAMP	
	db	%4
%endif		
%ifdef GO4K_USE_DLL_CHORUS	
	db	%5
	db	%6
%endif
	db	%7
	db	%8
%endmacro
%define PREGAIN(val)	val
%define	DRY(val)		val
%define	FEEDBACK(val)	val
%define	DEPTH(val)		val
%define DAMP(val)		val
%define	DELAY(val)		val
%define	COUNT(val)		val
struc	go4kDLL_val
	.pregain	resd	1
	.dry		resd	1
	.feedback	resd	1
%ifdef GO4K_USE_DLL_DAMP	
	.damp		resd	1	
%endif
%ifdef GO4K_USE_DLL_CHORUS
	.freq		resd	1
	.depth
%endif
	.delay		resd	1
	.count		resd	1
	.size
endstruc
struc	go4kDLL_wrk
	.index		resd	1
	.store		resd	1
	.dcin		resd	1
	.dcout		resd	1
%ifdef GO4K_USE_DLL_CHORUS
	.phase		resd	1
%endif
	.buffer		resd	MAX_DELAY
	.size
endstruc
struc	go4kDLL_wrk2
 .pm			resd	1
 .fm			resd	1
 .im			resd	1
 .dm			resd	1
 .sm			resd	1
 .am			resd	1
 .size
endstruc
GO4K_FOP_ID	equ			6
%macro	GO4K_FOP 1
	db	%1
%endmacro
%define	OP(val)			val
%define FOP_POP			0x1
%define FOP_ADDP		0x2
%define FOP_MULP		0x3
%define FOP_PUSH		0x4
%define FOP_XCH			0x5
%define FOP_ADD			0x6
%define FOP_MUL			0x7
%define FOP_ADDP2		0x8
%define FOP_LOADNOTE	0x9
struc	go4kFOP_val
	.flags		resd	1
	.size
endstruc
struc	go4kFOP_wrk
	.size
endstruc
GO4K_FST_ID		equ		7
%macro	GO4K_FST 2
	db	%1
	db	%2
%endmacro
%define	AMOUNT(val)		val
%define	DEST(val)		val
struc	go4kFST_val
	.amount		resd	1
	.op1		resd	1
	.size
endstruc
struc	go4kFST_wrk
	.size
endstruc
GO4K_PAN_ID		equ		8
%macro	GO4K_PAN 1
%ifdef GO4K_USE_PAN
	db	%1
%endif
%endmacro
%define	PANNING(val)	val
struc	go4kPAN_val
%ifdef GO4K_USE_PAN
	.panning	resd	1
%endif
	.size
endstruc
struc	go4kPAN_wrk
	.pm			resd	1
	.size
endstruc
GO4K_OUT_ID		equ		9
%macro	GO4K_OUT 2
	db	%1
%ifdef GO4K_USE_GLOBAL_DLL	
	db	%2
%endif	
%endmacro
%define	AUXSEND(val)	val
struc	go4kOUT_val
	.gain		resd	1
%ifdef GO4K_USE_GLOBAL_DLL	
	.auxsend	resd	1
%endif
	.size
endstruc
struc	go4kOUT_wrk
	.am			resd	1
	.gm			resd	1
	.size
endstruc
GO4K_ACC_ID		equ		10
%macro	GO4K_ACC 1
	db	%1
%endmacro
%define OUTPUT			0
%define	AUX				8
%define ACCTYPE(val)	val
struc	go4kACC_val
	.acctype	resd	1
	.size
endstruc
struc	go4kACC_wrk
	.size
endstruc
%ifdef GO4K_USE_FLD
GO4K_FLD_ID	equ		11
%macro	GO4K_FLD 1
	db	
%endmacro
%define	VALUE(val)	val
struc	go4kFLD_val
	.value		resd	1
	.size
endstruc
struc	go4kFLD_wrk
	.vm			resd	1
	.size
endstruc
%endif
%ifdef GO4K_USE_FSTG
GO4K_FSTG_ID	equ		12
%macro	GO4K_FSTG 2
	db	%1
	dd	%2
%endmacro
struc	go4kFSTG_val
	.amount		resd	1
	.op1		resd	1
	.size
endstruc
struc	go4kFSTG_wrk
	.size
endstruc
%endif
struc	go4k_instrument
	.release	resd	1
	.note		resd	1
	.workspace	resd	256
	.dlloutl	resd	1
	.dlloutr	resd	1
	.outl		resd	1
	.outr		resd	1
	.size
endstruc
struc	go4k_synth
	.instruments	resb	go4k_instrument.size * MAX_INSTRUMENTS * MAX_VOICES
	.global			resb	go4k_instrument.size * MAX_VOICES
	.size
endstruc
%ifdef USE_SECTIONS
section .g4kmuc1 data align=1
%else
section .data align=1
%endif
go4k_patterns
	db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
	db	83, 0, 0, 0, 79, 0, 0, 0, 83, 0, 0, 0, 79, 0, 0, 0, 
	db	83, 0, 0, 0, 76, 0, 0, 0, 83, 0, 0, 0, 76, 0, 0, 0, 
	db	81, 0, 0, 0, 72, 0, 0, 0, 81, 0, 0, 0, 72, 0, 0, 0, 
	db	79, 0, 0, 0, 74, 0, 0, 0, 79, 0, 0, 0, 74, 0, 0, 0, 
	db	60, HLD, 0, 0, 0, 0, 0, 0, 60, HLD, 0, 0, 0, 0, 0, 0, 
	db	60, 0, 0, 0, 60, 0, 0, 0, 60, 0, 0, 0, 60, 0, 0, 0, 
	db	50, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, 
	db	55, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, 
	db	57, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, 
	db	59, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, 
	db	60, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, 
	db	59, HLD, HLD, HLD, 60, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, 
	db	HLD, HLD, HLD, HLD, 55, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, 
	db	HLD, HLD, HLD, HLD, 57, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, 
	db	HLD, HLD, HLD, HLD, 59, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, 
	db	HLD, HLD, HLD, HLD, 60, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, 
	db	HLD, HLD, HLD, HLD, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
	db	0, 0, 0, 0, 60, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, HLD, 
go4k_patterns_end
%ifdef USE_SECTIONS
section .g4kmuc2 data align=1
%else
section .data
%endif
go4k_pattern_lists
Instrument0List		db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
Instrument2List		db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
Instrument4List		db	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
Instrument5List		db	0, 0, 0, 0, 0, 0, 0, 0, 7, 8, 9, 10, 11, 8, 9, 10, 11, 8, 9, 10, 0, 0, 11, 8, 9, 10, 11, 8, 9, 10, 11, 8, 9, 10, 11, 8, 9, 10, 11, 8, 9, 10, 11, 8, 9, 10, 0, 0, 0, 0, 
Instrument6List		db	11, 8, 9, 10, 11, 8, 9, 10, 11, 8, 9, 10, 11, 8, 9, 10, 11, 8, 9, 10, 0, 0, 11, 8, 9, 10, 11, 8, 9, 10, 11, 8, 9, 10, 11, 8, 9, 10, 11, 8, 9, 10, 11, 8, 9, 10, 0, 0, 0, 0, 
Instrument7List		db	12, 13, 14, 15, 16, 13, 14, 15, 16, 13, 14, 15, 16, 13, 14, 15, 16, 13, 14, 15, 17, 0, 18, 13, 14, 15, 16, 13, 14, 15, 16, 13, 14, 15, 16, 13, 14, 15, 16, 13, 14, 15, 16, 13, 14, 15, 17, 0, 0, 0, 
go4k_pattern_lists_end
%ifdef USE_SECTIONS
section .g4kmuc3 data align=1
%else
section .data
%endif
go4k_synth_instructions
GO4K_BEGIN_CMDDEF(Instrument0)
	db GO4K_ENV_ID
	db GO4K_VCO_ID
	db GO4K_FOP_ID
	db GO4K_VCO_ID
	db GO4K_FST_ID
	db GO4K_FOP_ID
	db GO4K_VCF_ID
	db GO4K_PAN_ID
	db GO4K_DLL_ID
	db GO4K_FOP_ID
	db GO4K_DLL_ID
	db GO4K_FOP_ID
	db GO4K_OUT_ID
GO4K_END_CMDDEF
GO4K_BEGIN_CMDDEF(Instrument2)
	db GO4K_ENV_ID
	db GO4K_FST_ID
	db GO4K_ENV_ID
	db GO4K_DST_ID
	db GO4K_FST_ID
	db GO4K_FOP_ID
	db GO4K_VCO_ID
	db GO4K_FOP_ID
	db GO4K_PAN_ID
	db GO4K_OUT_ID
GO4K_END_CMDDEF
GO4K_BEGIN_CMDDEF(Instrument4)
	db GO4K_ENV_ID
	db GO4K_VCO_ID
	db GO4K_FOP_ID
	db GO4K_VCF_ID
	db GO4K_PAN_ID
	db GO4K_OUT_ID
GO4K_END_CMDDEF
GO4K_BEGIN_CMDDEF(Instrument5)
	db GO4K_ENV_ID
	db GO4K_VCO_ID
	db GO4K_FOP_ID
	db GO4K_PAN_ID
	db GO4K_OUT_ID
GO4K_END_CMDDEF
GO4K_BEGIN_CMDDEF(Instrument6)
	db GO4K_ENV_ID
	db GO4K_VCO_ID
	db GO4K_FST_ID
	db GO4K_FST_ID
	db GO4K_FOP_ID
	db GO4K_VCO_ID
	db GO4K_VCO_ID
	db GO4K_FOP_ID
	db GO4K_FOP_ID
	db GO4K_PAN_ID
	db GO4K_OUT_ID
GO4K_END_CMDDEF
GO4K_BEGIN_CMDDEF(Instrument7)
	db GO4K_ENV_ID
	db GO4K_VCO_ID
	db GO4K_FOP_ID
	db GO4K_PAN_ID
	db GO4K_DLL_ID
	db GO4K_FOP_ID
	db GO4K_DLL_ID
	db GO4K_FOP_ID
	db GO4K_OUT_ID
GO4K_END_CMDDEF
GO4K_BEGIN_CMDDEF(Global)
	db GO4K_ACC_ID
	db GO4K_DLL_ID
	db GO4K_FOP_ID
	db GO4K_DLL_ID
	db GO4K_FOP_ID
	db GO4K_ACC_ID
	db GO4K_FOP_ID
	db GO4K_OUT_ID
GO4K_END_CMDDEF
go4k_synth_instructions_end
%ifdef USE_SECTIONS
section .g4kmuc4 data align=1
%else
section .data
%endif
go4k_synth_parameter_values
GO4K_BEGIN_PARAMDEF(Instrument0)
	GO4K_ENV	ATTAC(52),DECAY(64),SUSTAIN(64),RELEASE(64),GAIN(100)
	GO4K_VCO	TRANSPOSE(64),DETUNE(64),PHASE(64),GATES(85),COLOR(64),SHAPE(64),GAIN(128),FLAGS(PULSE)
	GO4K_FOP	OP(FOP_MULP)
	GO4K_VCO	TRANSPOSE(52),DETUNE(64),PHASE(0),GATES(85),COLOR(64),SHAPE(64),GAIN(128),FLAGS(TRISAW|LFO)
	GO4K_FST	AMOUNT(96),DEST(1*MAX_WORKSPACE_SLOTS+5)
	GO4K_FOP	OP(FOP_POP)
	GO4K_VCF	FREQUENCY(56),RESONANCE(19),VCFTYPE(LOWPASS)
	GO4K_PAN	PANNING(64)
	GO4K_DLL	PREGAIN(96),DRY(128),FEEDBACK(96),DAMP(64),FREQUENCY(0),DEPTH(0),DELAY(16),COUNT(1)
	GO4K_FOP	OP(FOP_XCH)
	GO4K_DLL	PREGAIN(64),DRY(128),FEEDBACK(64),DAMP(64),FREQUENCY(0),DEPTH(0),DELAY(17),COUNT(1)
	GO4K_FOP	OP(FOP_XCH)
	GO4K_OUT	GAIN(0), AUXSEND(48)
GO4K_END_PARAMDEF
GO4K_BEGIN_PARAMDEF(Instrument2)
	GO4K_ENV	ATTAC(0),DECAY(32),SUSTAIN(96),RELEASE(64),GAIN(128)
	GO4K_FST	AMOUNT(128),DEST(0*MAX_WORKSPACE_SLOTS+2)
	GO4K_ENV	ATTAC(0),DECAY(70),SUSTAIN(0),RELEASE(0),GAIN(128)
	GO4K_DST	DRIVE(32), SNHFREQ(128)
	GO4K_FST	AMOUNT(80),DEST(6*MAX_WORKSPACE_SLOTS+1)
	GO4K_FOP	OP(FOP_POP)
	GO4K_VCO	TRANSPOSE(43),DETUNE(64),PHASE(0),GATES(85),COLOR(64),SHAPE(66),GAIN(128),FLAGS(SINE)
	GO4K_FOP	OP(FOP_MULP)
	GO4K_PAN	PANNING(64)
	GO4K_OUT	GAIN(50), AUXSEND(0)
GO4K_END_PARAMDEF
GO4K_BEGIN_PARAMDEF(Instrument4)
	GO4K_ENV	ATTAC(0),DECAY(64),SUSTAIN(0),RELEASE(0),GAIN(128)
	GO4K_VCO	TRANSPOSE(64),DETUNE(64),PHASE(64),GATES(85),COLOR(64),SHAPE(64),GAIN(128),FLAGS(NOISE)
	GO4K_FOP	OP(FOP_MULP)
	GO4K_VCF	FREQUENCY(128),RESONANCE(128),VCFTYPE(HIGHPASS)
	GO4K_PAN	PANNING(64)
	GO4K_OUT	GAIN(23), AUXSEND(0)
GO4K_END_PARAMDEF
GO4K_BEGIN_PARAMDEF(Instrument5)
	GO4K_ENV	ATTAC(0),DECAY(64),SUSTAIN(104),RELEASE(64),GAIN(128)
	GO4K_VCO	TRANSPOSE(52),DETUNE(64),PHASE(48),GATES(85),COLOR(96),SHAPE(96),GAIN(128),FLAGS(TRISAW)
	GO4K_FOP	OP(FOP_MULP)
	GO4K_PAN	PANNING(64)
	GO4K_OUT	GAIN(70), AUXSEND(64)
GO4K_END_PARAMDEF
GO4K_BEGIN_PARAMDEF(Instrument6)
	GO4K_ENV	ATTAC(88),DECAY(88),SUSTAIN(88),RELEASE(88),GAIN(88)
	GO4K_VCO	TRANSPOSE(76),DETUNE(64),PHASE(64),GATES(85),COLOR(64),SHAPE(64),GAIN(64),FLAGS(SINE|LFO)
	GO4K_FST	AMOUNT(70),DEST(5*MAX_WORKSPACE_SLOTS+2)
	GO4K_FST	AMOUNT(70),DEST(6*MAX_WORKSPACE_SLOTS+5)
	GO4K_FOP	OP(FOP_POP)
	GO4K_VCO	TRANSPOSE(64),DETUNE(65),PHASE(64),GATES(85),COLOR(52),SHAPE(64),GAIN(64),FLAGS(TRISAW)
	GO4K_VCO	TRANSPOSE(64),DETUNE(63),PHASE(64),GATES(85),COLOR(52),SHAPE(64),GAIN(64),FLAGS(TRISAW)
	GO4K_FOP	OP(FOP_ADDP)
	GO4K_FOP	OP(FOP_MULP)
	GO4K_PAN	PANNING(64)
	GO4K_OUT	GAIN(0), AUXSEND(128)
GO4K_END_PARAMDEF
GO4K_BEGIN_PARAMDEF(Instrument7)
	GO4K_ENV	ATTAC(64),DECAY(64),SUSTAIN(64),RELEASE(64),GAIN(128)
	GO4K_VCO	TRANSPOSE(64),DETUNE(64),PHASE(0),GATES(85),COLOR(64),SHAPE(64),GAIN(128),FLAGS(SINE)
	GO4K_FOP	OP(FOP_MULP)
	GO4K_PAN	PANNING(64)
	GO4K_DLL	PREGAIN(64),DRY(128),FEEDBACK(64),DAMP(64),FREQUENCY(0),DEPTH(0),DELAY(18),COUNT(1)
	GO4K_FOP	OP(FOP_XCH)
	GO4K_DLL	PREGAIN(64),DRY(128),FEEDBACK(64),DAMP(64),FREQUENCY(0),DEPTH(0),DELAY(18),COUNT(1)
	GO4K_FOP	OP(FOP_XCH)
	GO4K_OUT	GAIN(64), AUXSEND(0)
GO4K_END_PARAMDEF
GO4K_BEGIN_PARAMDEF(Global)
	GO4K_ACC	ACCTYPE(AUX)
	GO4K_DLL	PREGAIN(48),DRY(128),FEEDBACK(125),DAMP(64),FREQUENCY(0),DEPTH(0),DELAY(0),COUNT(8)
	GO4K_FOP	OP(FOP_XCH)
	GO4K_DLL	PREGAIN(48),DRY(128),FEEDBACK(125),DAMP(64),FREQUENCY(0),DEPTH(0),DELAY(8),COUNT(8)
	GO4K_FOP	OP(FOP_XCH)
	GO4K_ACC	ACCTYPE(OUTPUT)
	GO4K_FOP	OP(FOP_ADDP2)
	GO4K_OUT	GAIN(64), AUXSEND(0)
GO4K_END_PARAMDEF
go4k_synth_parameter_values_end
%ifdef USE_SECTIONS
section .g4kmuc5 data align=1
%else
section .data
%endif
%ifdef GO4K_USE_DLL
global _go4k_delay_times
_go4k_delay_times
	dw 1116
	dw 1188
	dw 1276
	dw 1356
	dw 1422
	dw 1492
	dw 1556
	dw 1618
	dw 1140
	dw 1212
	dw 1300
	dw 1380
	dw 1446
	dw 1516
	dw 1580
	dw 1642
	dw 22050
	dw 33075
	dw 1024
%endif
